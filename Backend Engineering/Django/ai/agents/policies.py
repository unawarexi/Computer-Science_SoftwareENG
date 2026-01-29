"""
Agent Policies
==============
Guardrails, permissions, and safety policies for AI agents.

This module implements safety checks and permission controls to ensure
agents operate within defined boundaries and handle sensitive content
appropriately.
"""

import logging
import re
from typing import Any, Dict, List, Optional, Set
from enum import Enum
from dataclasses import dataclass, field

from pydantic import BaseModel, Field

logger = logging.getLogger("ai.agents.policies")


# =============================================================================
# DATA MODELS
# =============================================================================

class Permission(str, Enum):
    """Available permissions for agent operations."""
    READ_FILES = "read_files"
    WRITE_FILES = "write_files"
    EXECUTE_CODE = "execute_code"
    WEB_SEARCH = "web_search"
    DATABASE_READ = "database_read"
    DATABASE_WRITE = "database_write"
    EXTERNAL_API = "external_api"
    SEND_EMAIL = "send_email"
    ADMIN_ACTIONS = "admin_actions"


@dataclass
class PolicyResult:
    """Result of a policy check."""
    allowed: bool
    message: str = ""
    reason: str = ""
    warnings: List[str] = field(default_factory=list)
    modified_input: Optional[str] = None


class PolicyConfig(BaseModel):
    """Configuration for policy enforcement."""
    enabled: bool = True
    log_violations: bool = True
    block_on_violation: bool = True
    content_filter_enabled: bool = True
    rate_limit_enabled: bool = True
    max_tokens_per_request: int = 4096
    max_requests_per_minute: int = 60
    allowed_domains: List[str] = Field(default_factory=list)
    blocked_domains: List[str] = Field(default_factory=list)


# =============================================================================
# CONTENT FILTERS
# =============================================================================

class ContentFilter:
    """
    Filter for detecting and handling problematic content.
    """
    
    # Patterns for potentially harmful content
    HARMFUL_PATTERNS = [
        r"\b(password|api[_-]?key|secret[_-]?key|private[_-]?key)\s*[:=]\s*['\"][^'\"]+['\"]",
        r"\b(rm\s+-rf|drop\s+table|delete\s+from)\b",
        r"\b(eval|exec|subprocess\.call)\s*\(",
    ]
    
    # PII patterns
    PII_PATTERNS = [
        r"\b\d{3}[-.]?\d{2}[-.]?\d{4}\b",  # SSN
        r"\b\d{16}\b",  # Credit card
        r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b",  # Email
    ]
    
    # Injection patterns
    INJECTION_PATTERNS = [
        r";\s*(DROP|DELETE|UPDATE|INSERT)",  # SQL injection
        r"<script[^>]*>",  # XSS
        r"\{\{.*\}\}",  # Template injection
    ]
    
    def __init__(self):
        """Initialize content filter with compiled patterns."""
        self.harmful_regex = [re.compile(p, re.IGNORECASE) for p in self.HARMFUL_PATTERNS]
        self.pii_regex = [re.compile(p, re.IGNORECASE) for p in self.PII_PATTERNS]
        self.injection_regex = [re.compile(p, re.IGNORECASE) for p in self.INJECTION_PATTERNS]
    
    def check(self, content: str) -> PolicyResult:
        """
        Check content for policy violations.
        
        Args:
            content: The content to check
            
        Returns:
            PolicyResult with findings
        """
        warnings = []
        blocked = False
        reason = ""
        
        # Check for harmful patterns
        for pattern in self.harmful_regex:
            if pattern.search(content):
                warnings.append("Potentially harmful command detected")
                blocked = True
                reason = "harmful_content"
                break
        
        # Check for PII
        pii_found = []
        for pattern in self.pii_regex:
            matches = pattern.findall(content)
            if matches:
                pii_found.extend(matches)
        
        if pii_found:
            warnings.append(f"PII detected: {len(pii_found)} instance(s)")
        
        # Check for injection attempts
        for pattern in self.injection_regex:
            if pattern.search(content):
                blocked = True
                reason = "injection_attempt"
                warnings.append("Potential injection attack detected")
                break
        
        return PolicyResult(
            allowed=not blocked,
            message="Content blocked due to policy violation" if blocked else "OK",
            reason=reason,
            warnings=warnings,
        )
    
    def redact_pii(self, content: str) -> str:
        """Redact PII from content."""
        redacted = content
        for pattern in self.pii_regex:
            redacted = pattern.sub("[REDACTED]", redacted)
        return redacted


# =============================================================================
# RATE LIMITER
# =============================================================================

class RateLimiter:
    """
    Token bucket rate limiter for API requests.
    """
    
    def __init__(self, max_requests: int = 60, window_seconds: int = 60):
        """
        Initialize rate limiter.
        
        Args:
            max_requests: Maximum requests per window
            window_seconds: Time window in seconds
        """
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self._requests: Dict[str, List[float]] = {}
    
    def check(self, identifier: str) -> PolicyResult:
        """
        Check if request is allowed.
        
        Args:
            identifier: User or session identifier
            
        Returns:
            PolicyResult indicating if request is allowed
        """
        import time
        
        now = time.time()
        window_start = now - self.window_seconds
        
        # Get request history for identifier
        if identifier not in self._requests:
            self._requests[identifier] = []
        
        # Remove old requests outside window
        self._requests[identifier] = [
            ts for ts in self._requests[identifier]
            if ts > window_start
        ]
        
        # Check if under limit
        if len(self._requests[identifier]) >= self.max_requests:
            return PolicyResult(
                allowed=False,
                message=f"Rate limit exceeded. Max {self.max_requests} requests per {self.window_seconds}s",
                reason="rate_limit",
            )
        
        # Record request
        self._requests[identifier].append(now)
        
        return PolicyResult(allowed=True)


# =============================================================================
# PERMISSION MANAGER
# =============================================================================

class PermissionManager:
    """
    Manages permissions for agent operations.
    """
    
    # Default permissions for different roles
    ROLE_PERMISSIONS = {
        "anonymous": {Permission.WEB_SEARCH},
        "user": {
            Permission.READ_FILES,
            Permission.WEB_SEARCH,
            Permission.DATABASE_READ,
            Permission.EXTERNAL_API,
        },
        "admin": {
            Permission.READ_FILES,
            Permission.WRITE_FILES,
            Permission.EXECUTE_CODE,
            Permission.WEB_SEARCH,
            Permission.DATABASE_READ,
            Permission.DATABASE_WRITE,
            Permission.EXTERNAL_API,
            Permission.SEND_EMAIL,
            Permission.ADMIN_ACTIONS,
        },
    }
    
    def __init__(self):
        """Initialize permission manager."""
        self._user_permissions: Dict[str, Set[Permission]] = {}
    
    def get_permissions(self, user_id: str, role: str = "user") -> Set[Permission]:
        """Get permissions for a user."""
        # Check cached permissions first
        if user_id in self._user_permissions:
            return self._user_permissions[user_id]
        
        # Return role-based permissions
        return self.ROLE_PERMISSIONS.get(role, self.ROLE_PERMISSIONS["user"])
    
    def check_permission(
        self,
        user_id: str,
        required_permission: Permission,
        role: str = "user",
    ) -> PolicyResult:
        """
        Check if user has required permission.
        
        Args:
            user_id: User identifier
            required_permission: Permission to check
            role: User's role
            
        Returns:
            PolicyResult indicating if permission is granted
        """
        permissions = self.get_permissions(user_id, role)
        
        if required_permission in permissions:
            return PolicyResult(allowed=True)
        
        return PolicyResult(
            allowed=False,
            message=f"Permission denied: {required_permission.value}",
            reason="permission_denied",
        )
    
    def grant_permission(self, user_id: str, permission: Permission):
        """Grant a permission to a user."""
        if user_id not in self._user_permissions:
            self._user_permissions[user_id] = set()
        self._user_permissions[user_id].add(permission)
    
    def revoke_permission(self, user_id: str, permission: Permission):
        """Revoke a permission from a user."""
        if user_id in self._user_permissions:
            self._user_permissions[user_id].discard(permission)


# =============================================================================
# POLICY ENGINE
# =============================================================================

class PolicyEngine:
    """
    Central policy engine that coordinates all policy checks.
    
    Combines content filtering, rate limiting, and permission checks
    into a unified policy enforcement system.
    
    Example:
        engine = PolicyEngine()
        result = await engine.check("User query here", user_id="user123")
        if not result.allowed:
            return {"error": result.message}
    """
    
    def __init__(self, config: Optional[PolicyConfig] = None):
        """Initialize the policy engine."""
        self.config = config or PolicyConfig()
        self.content_filter = ContentFilter()
        self.rate_limiter = RateLimiter(
            max_requests=self.config.max_requests_per_minute
        )
        self.permission_manager = PermissionManager()
        
        logger.info("PolicyEngine initialized")
    
    async def check(
        self,
        content: str,
        user_id: Optional[str] = None,
        role: str = "user",
        required_permissions: Optional[List[Permission]] = None,
    ) -> PolicyResult:
        """
        Run all policy checks on content.
        
        Args:
            content: Content to check
            user_id: User identifier for rate limiting and permissions
            role: User's role
            required_permissions: Permissions required for this operation
            
        Returns:
            Aggregated PolicyResult
        """
        if not self.config.enabled:
            return PolicyResult(allowed=True)
        
        all_warnings = []
        
        # Rate limiting check
        if self.config.rate_limit_enabled and user_id:
            rate_result = self.rate_limiter.check(user_id)
            if not rate_result.allowed:
                if self.config.log_violations:
                    logger.warning(f"Rate limit exceeded for user {user_id}")
                return rate_result
        
        # Content filter check
        if self.config.content_filter_enabled:
            content_result = self.content_filter.check(content)
            all_warnings.extend(content_result.warnings)
            
            if not content_result.allowed and self.config.block_on_violation:
                if self.config.log_violations:
                    logger.warning(f"Content blocked: {content_result.reason}")
                return content_result
        
        # Permission check
        if required_permissions and user_id:
            for permission in required_permissions:
                perm_result = self.permission_manager.check_permission(
                    user_id, permission, role
                )
                if not perm_result.allowed:
                    if self.config.log_violations:
                        logger.warning(f"Permission denied for {user_id}: {permission}")
                    return perm_result
        
        return PolicyResult(
            allowed=True,
            warnings=all_warnings,
        )
    
    def redact_sensitive_data(self, content: str) -> str:
        """Redact sensitive data from content."""
        return self.content_filter.redact_pii(content)


# =============================================================================
# GUARDRAILS
# =============================================================================

class Guardrails:
    """
    High-level guardrails for agent behavior.
    """
    
    # Topics the agent should not engage with
    BLOCKED_TOPICS = [
        "illegal activities",
        "violence",
        "self-harm",
        "hate speech",
    ]
    
    # Maximum response lengths
    MAX_RESPONSE_LENGTH = 10000
    
    @classmethod
    async def check_output(cls, response: str) -> PolicyResult:
        """
        Check agent output against guardrails.
        
        Args:
            response: Agent's response to check
            
        Returns:
            PolicyResult
        """
        warnings = []
        
        # Check response length
        if len(response) > cls.MAX_RESPONSE_LENGTH:
            warnings.append("Response truncated due to length")
            response = response[:cls.MAX_RESPONSE_LENGTH] + "..."
        
        return PolicyResult(
            allowed=True,
            warnings=warnings,
            modified_input=response if warnings else None,
        )

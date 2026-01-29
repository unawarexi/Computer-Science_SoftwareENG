"""
HTTP Client Tool
================
HTTP request tools for AI agents.

Provides capabilities for:
- GET/POST/PUT/DELETE requests
- Header and authentication handling
- Response parsing
- Error handling
"""

import logging
import json
from typing import Any, Dict, List, Optional
from urllib.parse import urljoin, urlparse

import aiohttp
from langchain_core.tools import tool

from ai.tools.base import BaseTool

logger = logging.getLogger("ai.tools.http")


# =============================================================================
# HTTP CLIENT TOOL
# =============================================================================

class HTTPClientTool(BaseTool):
    """
    Make HTTP requests to external APIs.
    
    Features:
    - Support for GET, POST, PUT, DELETE, PATCH
    - Custom headers and authentication
    - JSON and form data support
    - Response parsing
    - Timeout handling
    """
    
    def __init__(
        self,
        default_headers: Optional[Dict[str, str]] = None,
        timeout: int = 30,
        allowed_domains: Optional[List[str]] = None,
        max_response_size: int = 1_000_000,  # 1MB
    ):
        """
        Initialize HTTP client tool.
        
        Args:
            default_headers: Headers to include in all requests
            timeout: Request timeout in seconds
            allowed_domains: List of allowed domains (None = all allowed)
            max_response_size: Maximum response size in bytes
        """
        super().__init__()
        self.default_headers = default_headers or {}
        self.timeout = aiohttp.ClientTimeout(total=timeout)
        self.allowed_domains = allowed_domains
        self.max_response_size = max_response_size
    
    @property
    def name(self) -> str:
        return "http_request"
    
    @property
    def description(self) -> str:
        return """Make HTTP requests to external APIs.
        Supports GET, POST, PUT, DELETE, PATCH methods.
        Can send JSON or form data and receive JSON responses."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "url": {
                "type": "string",
                "description": "The URL to request",
            },
            "method": {
                "type": "string",
                "description": "HTTP method (GET, POST, PUT, DELETE, PATCH)",
                "default": "GET",
            },
            "headers": {
                "type": "object",
                "description": "Request headers",
            },
            "body": {
                "type": "object",
                "description": "Request body (for POST/PUT/PATCH)",
            },
            "params": {
                "type": "object",
                "description": "Query parameters",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["url"]
    
    def _validate_url(self, url: str) -> None:
        """Validate URL is allowed."""
        if not self.allowed_domains:
            return
        
        parsed = urlparse(url)
        domain = parsed.netloc.lower()
        
        # Check if domain matches any allowed domain
        if not any(
            domain == allowed or domain.endswith(f".{allowed}")
            for allowed in self.allowed_domains
        ):
            raise PermissionError(
                f"Domain '{domain}' is not allowed. "
                f"Allowed domains: {self.allowed_domains}"
            )
    
    async def execute(
        self,
        url: str,
        method: str = "GET",
        headers: Optional[Dict[str, str]] = None,
        body: Optional[Dict[str, Any]] = None,
        params: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Make an HTTP request.
        
        Args:
            url: Request URL
            method: HTTP method
            headers: Request headers
            body: Request body
            params: Query parameters
            
        Returns:
            Response data
        """
        # Validate URL
        self._validate_url(url)
        
        # Merge headers
        request_headers = {**self.default_headers}
        if headers:
            request_headers.update(headers)
        
        # Set content type if body provided
        if body and "Content-Type" not in request_headers:
            request_headers["Content-Type"] = "application/json"
        
        method = method.upper()
        
        try:
            async with aiohttp.ClientSession(
                timeout=self.timeout,
                headers=request_headers,
            ) as session:
                # Prepare request kwargs
                kwargs = {}
                if params:
                    kwargs["params"] = params
                if body:
                    if request_headers.get("Content-Type") == "application/json":
                        kwargs["json"] = body
                    else:
                        kwargs["data"] = body
                
                # Make request
                async with session.request(method, url, **kwargs) as response:
                    # Check response size
                    content_length = response.headers.get("Content-Length")
                    if content_length and int(content_length) > self.max_response_size:
                        return {
                            "success": False,
                            "error": f"Response too large: {content_length} bytes",
                            "status_code": response.status,
                        }
                    
                    # Read response
                    content = await response.read()
                    
                    if len(content) > self.max_response_size:
                        return {
                            "success": False,
                            "error": f"Response too large: {len(content)} bytes",
                            "status_code": response.status,
                        }
                    
                    # Parse response
                    content_type = response.headers.get("Content-Type", "")
                    
                    if "application/json" in content_type:
                        try:
                            data = json.loads(content)
                        except json.JSONDecodeError:
                            data = content.decode("utf-8", errors="replace")
                    else:
                        data = content.decode("utf-8", errors="replace")
                    
                    return {
                        "success": response.status < 400,
                        "status_code": response.status,
                        "headers": dict(response.headers),
                        "data": data,
                    }
                    
        except aiohttp.ClientError as e:
            logger.error(f"HTTP request failed: {e}")
            return {
                "success": False,
                "error": f"Request failed: {str(e)}",
            }
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}",
            }


# =============================================================================
# API CLIENT TOOL
# =============================================================================

class APIClientTool(BaseTool):
    """
    Client for specific API with authentication.
    
    Pre-configured for common APIs with built-in auth handling.
    """
    
    def __init__(
        self,
        base_url: str,
        api_key: Optional[str] = None,
        api_key_header: str = "Authorization",
        api_key_prefix: str = "Bearer",
    ):
        """
        Initialize API client.
        
        Args:
            base_url: Base URL for the API
            api_key: API key for authentication
            api_key_header: Header name for API key
            api_key_prefix: Prefix for API key value
        """
        super().__init__()
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key
        self.api_key_header = api_key_header
        self.api_key_prefix = api_key_prefix
        
        # Initialize HTTP client
        headers = {}
        if api_key:
            if api_key_prefix:
                headers[api_key_header] = f"{api_key_prefix} {api_key}"
            else:
                headers[api_key_header] = api_key
        
        self.http_client = HTTPClientTool(default_headers=headers)
    
    @property
    def name(self) -> str:
        return "api_client"
    
    @property
    def description(self) -> str:
        return f"""Make authenticated requests to {self.base_url}.
        Supports GET, POST, PUT, DELETE methods with automatic authentication."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "endpoint": {
                "type": "string",
                "description": "API endpoint path (e.g., '/users', '/items/123')",
            },
            "method": {
                "type": "string",
                "description": "HTTP method",
                "default": "GET",
            },
            "body": {
                "type": "object",
                "description": "Request body",
            },
            "params": {
                "type": "object",
                "description": "Query parameters",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["endpoint"]
    
    async def execute(
        self,
        endpoint: str,
        method: str = "GET",
        body: Optional[Dict[str, Any]] = None,
        params: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Make an API request.
        
        Args:
            endpoint: API endpoint path
            method: HTTP method
            body: Request body
            params: Query parameters
            
        Returns:
            API response
        """
        # Build full URL
        url = urljoin(self.base_url + "/", endpoint.lstrip("/"))
        
        # Delegate to HTTP client
        return await self.http_client.execute(
            url=url,
            method=method,
            body=body,
            params=params,
        )


# =============================================================================
# LANGCHAIN TOOL DECORATORS
# =============================================================================

@tool
def http_get(url: str) -> str:
    """Make a GET request to a URL and return the response."""
    import asyncio
    tool = HTTPClientTool()
    result = asyncio.get_event_loop().run_until_complete(tool.execute(url=url))
    
    if result.get("success"):
        data = result.get("data")
        if isinstance(data, dict):
            return json.dumps(data, indent=2)
        return str(data)[:5000]  # Limit response size
    else:
        return f"Request failed: {result.get('error', 'Unknown error')}"


@tool
def http_post(url: str, body: str) -> str:
    """Make a POST request with JSON body. Body should be a JSON string."""
    import asyncio
    
    try:
        body_dict = json.loads(body)
    except json.JSONDecodeError:
        return "Error: body must be a valid JSON string"
    
    tool = HTTPClientTool()
    result = asyncio.get_event_loop().run_until_complete(
        tool.execute(url=url, method="POST", body=body_dict)
    )
    
    if result.get("success"):
        data = result.get("data")
        if isinstance(data, dict):
            return json.dumps(data, indent=2)
        return str(data)[:5000]
    else:
        return f"Request failed: {result.get('error', 'Unknown error')}"


# =============================================================================
# WEBHOOK HANDLER
# =============================================================================

class WebhookTool(BaseTool):
    """
    Handle incoming webhooks and trigger actions.
    """
    
    def __init__(self, secret: Optional[str] = None):
        """
        Initialize webhook handler.
        
        Args:
            secret: Webhook secret for verification
        """
        super().__init__()
        self.secret = secret
    
    @property
    def name(self) -> str:
        return "webhook_handler"
    
    @property
    def description(self) -> str:
        return "Process incoming webhook payloads"
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "payload": {
                "type": "object",
                "description": "Webhook payload",
            },
            "headers": {
                "type": "object",
                "description": "Request headers",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["payload"]
    
    def _verify_signature(
        self,
        payload: bytes,
        signature: str,
    ) -> bool:
        """Verify webhook signature."""
        if not self.secret:
            return True
        
        import hmac
        import hashlib
        
        expected = hmac.new(
            self.secret.encode(),
            payload,
            hashlib.sha256
        ).hexdigest()
        
        return hmac.compare_digest(signature, expected)
    
    async def execute(
        self,
        payload: Dict[str, Any],
        headers: Optional[Dict[str, str]] = None,
    ) -> Dict[str, Any]:
        """
        Process webhook payload.
        
        Args:
            payload: Webhook data
            headers: Request headers for verification
            
        Returns:
            Processing result
        """
        headers = headers or {}
        
        # Verify signature if secret configured
        if self.secret:
            signature = headers.get("X-Webhook-Signature", "")
            payload_bytes = json.dumps(payload).encode()
            
            if not self._verify_signature(payload_bytes, signature):
                return {
                    "success": False,
                    "error": "Invalid signature",
                }
        
        # Process payload (can be extended for specific webhook types)
        event_type = payload.get("event", payload.get("type", "unknown"))
        
        return {
            "success": True,
            "event_type": event_type,
            "payload": payload,
            "processed": True,
        }

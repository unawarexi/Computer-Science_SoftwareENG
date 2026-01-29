"""
User Models
===========
Custom user model with AI-related features.
"""

import uuid
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models


class UserManager(BaseUserManager):
    """Custom user manager."""
    
    def create_user(self, email, password=None, **extra_fields):
        """Create and save a regular user."""
        if not email:
            raise ValueError('Email is required')
        
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, password=None, **extra_fields):
        """Create and save a superuser."""
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, password, **extra_fields)


class User(AbstractUser):
    """
    Custom user model with email as username.
    """
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    username = None  # Remove username field
    email = models.EmailField('email address', unique=True)
    
    # Profile
    full_name = models.CharField(max_length=255, blank=True)
    avatar_url = models.URLField(blank=True)
    
    # AI settings
    default_model = models.CharField(max_length=100, default='gpt-4o-mini')
    default_temperature = models.FloatField(default=0.7)
    
    # Usage tracking
    total_tokens_used = models.PositiveBigIntegerField(default=0)
    total_conversations = models.PositiveIntegerField(default=0)
    
    # Limits
    monthly_token_limit = models.PositiveBigIntegerField(default=1_000_000)
    tokens_used_this_month = models.PositiveBigIntegerField(default=0)
    
    # Preferences
    preferences = models.JSONField(default=dict, blank=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []
    
    objects = UserManager()
    
    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'
    
    def __str__(self):
        return self.email
    
    def get_full_name(self):
        return self.full_name or self.email
    
    def get_short_name(self):
        return self.email.split('@')[0]
    
    @property
    def has_token_limit(self):
        """Check if user has reached token limit."""
        return self.tokens_used_this_month >= self.monthly_token_limit
    
    def add_token_usage(self, tokens: int):
        """Add token usage."""
        self.total_tokens_used += tokens
        self.tokens_used_this_month += tokens
        self.save(update_fields=['total_tokens_used', 'tokens_used_this_month'])
    
    def reset_monthly_usage(self):
        """Reset monthly token usage."""
        self.tokens_used_this_month = 0
        self.save(update_fields=['tokens_used_this_month'])


class APIKey(models.Model):
    """
    API keys for user authentication.
    """
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='api_keys',
    )
    name = models.CharField(max_length=100)
    key_prefix = models.CharField(max_length=8, unique=True)
    key_hash = models.CharField(max_length=128)
    
    # Permissions
    scopes = models.JSONField(default=list)  # ['read', 'write', 'admin']
    
    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    last_used_at = models.DateTimeField(null=True, blank=True)
    expires_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.name} ({self.key_prefix}...)"
    
    @classmethod
    def generate_key(cls):
        """Generate a new API key."""
        import secrets
        import hashlib
        
        key = secrets.token_urlsafe(32)
        prefix = key[:8]
        key_hash = hashlib.sha256(key.encode()).hexdigest()
        
        return key, prefix, key_hash
    
    @classmethod
    def verify_key(cls, key: str) -> 'APIKey':
        """Verify an API key and return the APIKey object."""
        import hashlib
        from django.utils import timezone
        
        prefix = key[:8]
        key_hash = hashlib.sha256(key.encode()).hexdigest()
        
        try:
            api_key = cls.objects.get(
                key_prefix=prefix,
                key_hash=key_hash,
                is_active=True,
            )
            
            # Check expiration
            if api_key.expires_at and api_key.expires_at < timezone.now():
                return None
            
            # Update last used
            api_key.last_used_at = timezone.now()
            api_key.save(update_fields=['last_used_at'])
            
            return api_key
        except cls.DoesNotExist:
            return None

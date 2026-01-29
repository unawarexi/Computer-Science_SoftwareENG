"""
API Application Configuration
"""

from django.apps import AppConfig


class APIConfig(AppConfig):
    """API application configuration."""
    
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.api'
    verbose_name = 'API'

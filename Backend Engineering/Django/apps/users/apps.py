"""
Users Application Configuration
"""

from django.apps import AppConfig


class UsersConfig(AppConfig):
    """Users application configuration."""
    
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.users'
    verbose_name = 'Users'
    
    def ready(self):
        """Run when application is ready."""
        try:
            from apps.users import signals  # noqa
        except ImportError:
            pass

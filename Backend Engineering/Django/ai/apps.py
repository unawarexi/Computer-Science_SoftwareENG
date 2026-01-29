"""
AI App Configuration
====================
Django app configuration for AI module.
"""

from django.apps import AppConfig


class AiConfig(AppConfig):
    """Configuration for the AI application."""
    
    default_auto_field = "django.db.models.BigAutoField"
    name = "ai"
    verbose_name = "AI Agents"
    
    def ready(self):
        """Initialize AI components when Django starts."""
        # Import signal handlers
        try:
            from ai import signals  # noqa: F401
        except ImportError:
            pass
        
        # Initialize LLM providers
        from ai.models.llm_router import LLMRouter
        LLMRouter.initialize()

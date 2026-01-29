"""
Celery Configuration
====================
Celery app configuration for background task processing.
"""

import os

from celery import Celery
from celery.schedules import crontab

# Set default Django settings module
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "learnDjango.settings.development")

# Create Celery app
app = Celery("django_ai_agents")

# Load config from Django settings
app.config_from_object("django.conf:settings", namespace="CELERY")

# Auto-discover tasks in all installed apps
app.autodiscover_tasks()

# =============================================================================
# TASK QUEUES
# =============================================================================

app.conf.task_queues = {
    "default": {
        "exchange": "default",
        "routing_key": "default",
    },
    "ai_tasks": {
        "exchange": "ai_tasks",
        "routing_key": "ai_tasks",
    },
    "high_priority": {
        "exchange": "high_priority",
        "routing_key": "high_priority",
    },
}

# =============================================================================
# TASK ROUTING
# =============================================================================

app.conf.task_routes = {
    "ai.agents.tasks.*": {"queue": "ai_tasks"},
    "ai.rag.tasks.*": {"queue": "ai_tasks"},
    "ai.eval.tasks.*": {"queue": "ai_tasks"},
    "apps.*.tasks.send_*": {"queue": "high_priority"},
}

# =============================================================================
# PERIODIC TASKS (Celery Beat)
# =============================================================================

app.conf.beat_schedule = {
    # Clean up old agent sessions every hour
    "cleanup-agent-sessions": {
        "task": "ai.memory.tasks.cleanup_expired_sessions",
        "schedule": crontab(minute=0),  # Every hour
    },
    # Sync vector store indexes daily
    "sync-vector-indexes": {
        "task": "ai.rag.tasks.sync_vector_indexes",
        "schedule": crontab(hour=2, minute=0),  # 2 AM daily
    },
    # Generate daily AI usage report
    "generate-ai-usage-report": {
        "task": "ai.eval.tasks.generate_daily_report",
        "schedule": crontab(hour=6, minute=0),  # 6 AM daily
    },
    # Health check for LLM providers
    "llm-health-check": {
        "task": "ai.models.tasks.health_check_providers",
        "schedule": crontab(minute="*/15"),  # Every 15 minutes
    },
}

# =============================================================================
# TASK CONFIGURATION
# =============================================================================

app.conf.update(
    # Retry configuration
    task_acks_late=True,
    task_reject_on_worker_lost=True,
    
    # Result configuration
    result_expires=3600,  # 1 hour
    
    # Concurrency
    worker_prefetch_multiplier=1,
    worker_concurrency=4,
    
    # Timeouts
    task_soft_time_limit=300,  # 5 minutes
    task_time_limit=600,  # 10 minutes
    
    # AI tasks get longer timeouts
    task_annotations={
        "ai.agents.tasks.*": {
            "soft_time_limit": 600,
            "time_limit": 900,
        }
    },
)


@app.task(bind=True, ignore_result=True)
def debug_task(self):
    """Debug task for testing Celery setup."""
    print(f"Request: {self.request!r}")

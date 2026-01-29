"""
Django Testing Settings
=======================
Settings optimized for running tests.
"""

from .base import *  # noqa: F401, F403

# =============================================================================
# DEBUG
# =============================================================================

DEBUG = False

# =============================================================================
# SECRET KEY
# =============================================================================

SECRET_KEY = "test-secret-key-not-for-production"

# =============================================================================
# DATABASE - SQLite for fast tests
# =============================================================================

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",
    }
}

# =============================================================================
# PASSWORD HASHERS - Fast hashing for tests
# =============================================================================

PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.MD5PasswordHasher",
]

# =============================================================================
# EMAIL
# =============================================================================

EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"

# =============================================================================
# CACHING - Local memory
# =============================================================================

CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.locmem.LocMemCache",
    }
}

# =============================================================================
# CELERY - Eager execution for tests
# =============================================================================

CELERY_TASK_ALWAYS_EAGER = True
CELERY_TASK_EAGER_PROPAGATES = True

# =============================================================================
# MEDIA
# =============================================================================

MEDIA_ROOT = BASE_DIR / "test_media"

# =============================================================================
# AI CONFIG - Test settings
# =============================================================================

AI_CONFIG["AGENT_VERBOSE"] = False
AI_CONFIG["AGENT_MAX_ITERATIONS"] = 3
AI_CONFIG["AGENT_TIMEOUT_SECONDS"] = 30

# Mock API keys for testing
AI_CONFIG["OPENAI_API_KEY"] = "test-key"
AI_CONFIG["ANTHROPIC_API_KEY"] = "test-key"

# =============================================================================
# LOGGING - Minimal for tests
# =============================================================================

LOGGING = {
    "version": 1,
    "disable_existing_loggers": True,
    "handlers": {
        "null": {
            "class": "logging.NullHandler",
        },
    },
    "root": {
        "handlers": ["null"],
    },
}

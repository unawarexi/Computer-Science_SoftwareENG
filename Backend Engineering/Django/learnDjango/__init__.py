# learnDjango/__init__.py
"""
Django configuration package.
Includes settings, WSGI/ASGI applications, and Celery configuration.
"""

from .celery import app as celery_app

__all__ = ('celery_app',)

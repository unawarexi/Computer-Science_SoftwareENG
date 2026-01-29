"""
WSGI Configuration
==================
WSGI config for production deployment with Gunicorn.
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "learnDjango.settings.production")

application = get_wsgi_application()

"""
API URL Configuration
=====================
URL routing for API endpoints.
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter

from apps.api.views import (
    ConversationViewSet,
    DocumentViewSet,
    AgentTaskViewSet,
)

router = DefaultRouter()
router.register(r'conversations', ConversationViewSet, basename='conversation')
router.register(r'documents', DocumentViewSet, basename='document')
router.register(r'tasks', AgentTaskViewSet, basename='task')

urlpatterns = [
    path('', include(router.urls)),
]

"""
WebSocket Routing
=================
WebSocket URL patterns for real-time AI agent communication.
"""

from django.urls import re_path

from ai.agents.consumers import AgentConsumer

websocket_urlpatterns = [
    re_path(r"ws/agent/(?P<session_id>\w+)/$", AgentConsumer.as_asgi()),
]

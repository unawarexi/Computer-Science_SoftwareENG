"""
AI URL Configuration
====================
URL routing for all AI-related endpoints.
"""

from django.urls import path, include

app_name = "ai"

urlpatterns = [
    # Agent endpoints
    path("agents/", include("ai.agents.urls")),
    
    # RAG endpoints
    path("rag/", include("ai.rag.urls")),
    
    # Memory endpoints
    path("memory/", include("ai.memory.urls")),
    
    # Model endpoints
    path("models/", include("ai.models.urls")),
    
    # Evaluation endpoints
    path("eval/", include("ai.eval.urls")),
]

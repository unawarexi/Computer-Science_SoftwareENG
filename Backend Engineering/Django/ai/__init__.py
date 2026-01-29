"""
AI Module
=========
Django app for AI agent integration.

This package contains all AI-related functionality including:
- agents: LangGraph agent definitions and orchestration
- tools: Tool implementations (search, database, external APIs)
- rag: Retrieval-Augmented Generation (chunking, embedding, retrieval)
- memory: Short-term and long-term memory systems
- models: LLM routing and embedding models
- eval: Metrics, tracing, and evaluation
"""

default_app_config = "ai.apps.AiConfig"

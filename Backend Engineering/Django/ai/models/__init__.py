"""
AI Models Module
================
LLM and embedding model management.

This module provides:
- LLM router for multi-provider support
- Embeddings configuration
- Model selection and fallback
"""

from ai.models.llm_router import (
    LLMRouter,
    ModelConfig,
    get_llm,
    get_default_llm,
)
from ai.models.embeddings import (
    EmbeddingsManager,
    get_embeddings,
    get_default_embeddings,
)

__all__ = [
    # LLM
    "LLMRouter",
    "ModelConfig",
    "get_llm",
    "get_default_llm",
    # Embeddings
    "EmbeddingsManager",
    "get_embeddings",
    "get_default_embeddings",
]

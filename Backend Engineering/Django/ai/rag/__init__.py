"""
AI RAG (Retrieval-Augmented Generation) Module
==============================================
Document ingestion, retrieval, and RAG pipeline components.

This module provides:
- Document ingestion and chunking
- Vector storage and retrieval
- Reranking and relevance filtering
- Prompt templates for RAG
"""

from ai.rag.ingest import (
    DocumentProcessor,
    ChunkingStrategy,
    TextSplitter,
)
from ai.rag.retriever import (
    VectorRetriever,
    HybridRetriever,
    RetrievalResult,
)
from ai.rag.reranker import (
    Reranker,
    CohereReranker,
    CrossEncoderReranker,
)
from ai.rag.prompts import (
    RAGPromptTemplate,
    get_rag_prompt,
)

__all__ = [
    # Ingestion
    "DocumentProcessor",
    "ChunkingStrategy",
    "TextSplitter",
    # Retrieval
    "VectorRetriever",
    "HybridRetriever",
    "RetrievalResult",
    # Reranking
    "Reranker",
    "CohereReranker",
    "CrossEncoderReranker",
    # Prompts
    "RAGPromptTemplate",
    "get_rag_prompt",
]

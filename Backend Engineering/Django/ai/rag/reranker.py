"""
Reranking Module
================
Document reranking for improved retrieval quality.

This module provides:
- Cross-encoder reranking
- Cohere reranking
- LLM-based reranking
- Diversity reranking
"""

import logging
from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional, Tuple
from dataclasses import dataclass

from langchain_core.documents import Document

logger = logging.getLogger("ai.rag.reranker")


# =============================================================================
# BASE RERANKER
# =============================================================================

@dataclass
class RerankResult:
    """Result from reranking."""
    document: Document
    score: float
    original_rank: int
    new_rank: int


class Reranker(ABC):
    """Base class for document rerankers."""
    
    @abstractmethod
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """
        Rerank documents based on query relevance.
        
        Args:
            query: Search query
            documents: Documents to rerank
            top_k: Number of top documents to return
            
        Returns:
            Reranked documents
        """
        pass
    
    async def arerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Async rerank (default: sync fallback)."""
        return self.rerank(query, documents, top_k)


# =============================================================================
# CROSS-ENCODER RERANKER
# =============================================================================

class CrossEncoderReranker(Reranker):
    """
    Rerank using cross-encoder model.
    
    Cross-encoders jointly encode query and document for more accurate
    relevance scoring than bi-encoders.
    """
    
    def __init__(
        self,
        model_name: str = "cross-encoder/ms-marco-MiniLM-L-6-v2",
        device: Optional[str] = None,
        batch_size: int = 32,
    ):
        """
        Initialize cross-encoder reranker.
        
        Args:
            model_name: HuggingFace model name
            device: Device to use (cuda/cpu)
            batch_size: Batch size for encoding
        """
        self.model_name = model_name
        self.device = device
        self.batch_size = batch_size
        self._model = None
    
    @property
    def model(self):
        """Lazy load model."""
        if self._model is None:
            try:
                from sentence_transformers import CrossEncoder
                self._model = CrossEncoder(
                    self.model_name,
                    device=self.device,
                )
            except ImportError:
                raise ImportError(
                    "sentence-transformers required. "
                    "Install with: pip install sentence-transformers"
                )
        return self._model
    
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Rerank using cross-encoder."""
        if not documents:
            return []
        
        # Create query-document pairs
        pairs = [(query, doc.page_content) for doc in documents]
        
        # Get scores
        scores = self.model.predict(pairs, batch_size=self.batch_size)
        
        # Sort by score
        scored_docs = list(zip(documents, scores))
        scored_docs.sort(key=lambda x: x[1], reverse=True)
        
        # Return top k
        if top_k:
            scored_docs = scored_docs[:top_k]
        
        # Add scores to metadata
        results = []
        for doc, score in scored_docs:
            doc.metadata["rerank_score"] = float(score)
            results.append(doc)
        
        return results


# =============================================================================
# COHERE RERANKER
# =============================================================================

class CohereReranker(Reranker):
    """
    Rerank using Cohere Rerank API.
    
    High-quality reranking with minimal setup.
    """
    
    def __init__(
        self,
        api_key: Optional[str] = None,
        model: str = "rerank-english-v3.0",
        top_n: Optional[int] = None,
    ):
        """
        Initialize Cohere reranker.
        
        Args:
            api_key: Cohere API key
            model: Rerank model name
            top_n: Default number of results
        """
        self.model = model
        self.top_n = top_n
        
        try:
            import cohere
            self.client = cohere.Client(api_key)
        except ImportError:
            raise ImportError("cohere required. Install with: pip install cohere")
    
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Rerank using Cohere API."""
        if not documents:
            return []
        
        # Extract texts
        texts = [doc.page_content for doc in documents]
        
        # Call Cohere
        response = self.client.rerank(
            model=self.model,
            query=query,
            documents=texts,
            top_n=top_k or self.top_n or len(documents),
        )
        
        # Build results
        results = []
        for result in response.results:
            doc = documents[result.index]
            doc.metadata["rerank_score"] = result.relevance_score
            results.append(doc)
        
        return results


# =============================================================================
# LLM RERANKER
# =============================================================================

class LLMReranker(Reranker):
    """
    Rerank using LLM for relevance scoring.
    
    More expensive but can understand complex relevance.
    """
    
    RERANK_PROMPT = """Rate the relevance of the following document to the query on a scale of 0-10.
Only output a single number.

Query: {query}

Document:
{document}

Relevance score (0-10):"""
    
    def __init__(
        self,
        llm: Any,
        batch_size: int = 5,
    ):
        """
        Initialize LLM reranker.
        
        Args:
            llm: LangChain LLM
            batch_size: Number of concurrent evaluations
        """
        self.llm = llm
        self.batch_size = batch_size
    
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Rerank using LLM."""
        if not documents:
            return []
        
        # Score each document
        scored = []
        for doc in documents:
            score = self._score_document(query, doc)
            scored.append((doc, score))
        
        # Sort by score
        scored.sort(key=lambda x: x[1], reverse=True)
        
        # Return top k
        if top_k:
            scored = scored[:top_k]
        
        # Add scores
        results = []
        for doc, score in scored:
            doc.metadata["rerank_score"] = score
            results.append(doc)
        
        return results
    
    def _score_document(self, query: str, doc: Document) -> float:
        """Score single document."""
        try:
            prompt = self.RERANK_PROMPT.format(
                query=query,
                document=doc.page_content[:1000],
            )
            
            response = self.llm.invoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            # Parse score
            score = float(content.strip())
            return min(max(score, 0), 10) / 10  # Normalize to 0-1
            
        except Exception as e:
            logger.warning(f"LLM scoring failed: {e}")
            return 0.5


# =============================================================================
# DIVERSITY RERANKER
# =============================================================================

class DiversityReranker(Reranker):
    """
    Rerank with diversity (MMR-style).
    
    Balances relevance with diversity to reduce redundancy.
    """
    
    def __init__(
        self,
        embeddings_model: Any,
        lambda_mult: float = 0.5,
    ):
        """
        Initialize diversity reranker.
        
        Args:
            embeddings_model: LangChain embeddings model
            lambda_mult: Balance between relevance and diversity (0-1)
        """
        self.embeddings_model = embeddings_model
        self.lambda_mult = lambda_mult
    
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Rerank with MMR."""
        if not documents:
            return []
        
        top_k = top_k or len(documents)
        
        # Get embeddings
        import numpy as np
        
        query_embedding = self.embeddings_model.embed_query(query)
        doc_embeddings = self.embeddings_model.embed_documents(
            [doc.page_content for doc in documents]
        )
        
        # Convert to numpy
        query_embedding = np.array(query_embedding)
        doc_embeddings = np.array(doc_embeddings)
        
        # Calculate similarity to query
        query_sims = np.dot(doc_embeddings, query_embedding)
        
        # MMR selection
        selected_indices = []
        remaining_indices = list(range(len(documents)))
        
        while len(selected_indices) < top_k and remaining_indices:
            if not selected_indices:
                # First doc: most similar to query
                best_idx = np.argmax(query_sims[remaining_indices])
                best_doc_idx = remaining_indices[best_idx]
            else:
                # Calculate MMR scores
                mmr_scores = []
                
                for idx in remaining_indices:
                    # Relevance score
                    relevance = query_sims[idx]
                    
                    # Diversity score (max similarity to selected docs)
                    selected_embeddings = doc_embeddings[selected_indices]
                    max_sim = np.max(np.dot(selected_embeddings, doc_embeddings[idx]))
                    
                    # MMR score
                    mmr = self.lambda_mult * relevance - (1 - self.lambda_mult) * max_sim
                    mmr_scores.append(mmr)
                
                best_idx = np.argmax(mmr_scores)
                best_doc_idx = remaining_indices[best_idx]
            
            selected_indices.append(best_doc_idx)
            remaining_indices.remove(best_doc_idx)
        
        # Build results
        results = []
        for i, idx in enumerate(selected_indices):
            doc = documents[idx]
            doc.metadata["mmr_rank"] = i
            doc.metadata["relevance_score"] = float(query_sims[idx])
            results.append(doc)
        
        return results


# =============================================================================
# ENSEMBLE RERANKER
# =============================================================================

class EnsembleReranker(Reranker):
    """
    Combine multiple rerankers.
    
    Uses weighted voting from multiple rerankers.
    """
    
    def __init__(
        self,
        rerankers: List[Tuple[Reranker, float]],
    ):
        """
        Initialize ensemble reranker.
        
        Args:
            rerankers: List of (reranker, weight) tuples
        """
        self.rerankers = rerankers
    
    def rerank(
        self,
        query: str,
        documents: List[Document],
        top_k: Optional[int] = None,
    ) -> List[Document]:
        """Rerank using ensemble."""
        if not documents:
            return []
        
        # Collect scores from each reranker
        doc_scores: Dict[int, float] = {i: 0 for i in range(len(documents))}
        
        for reranker, weight in self.rerankers:
            ranked = reranker.rerank(query, documents)
            
            for rank, doc in enumerate(ranked):
                # Find original index
                for i, orig_doc in enumerate(documents):
                    if orig_doc.page_content == doc.page_content:
                        # RRF-style scoring
                        doc_scores[i] += weight / (60 + rank + 1)
                        break
        
        # Sort by combined score
        sorted_indices = sorted(
            doc_scores.keys(),
            key=lambda x: doc_scores[x],
            reverse=True
        )
        
        # Build results
        results = []
        for i, idx in enumerate(sorted_indices[:top_k] if top_k else sorted_indices):
            doc = documents[idx]
            doc.metadata["ensemble_score"] = doc_scores[idx]
            results.append(doc)
        
        return results

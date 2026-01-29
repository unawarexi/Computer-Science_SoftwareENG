"""
Retrieval Module
================
Vector retrieval and hybrid search for RAG.

This module provides:
- Vector similarity search
- Hybrid retrieval (vector + keyword)
- Multi-query retrieval
- Contextual compression
"""

import logging
from typing import Any, Dict, List, Optional, Union
from dataclasses import dataclass, field
from enum import Enum

from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun

logger = logging.getLogger("ai.rag.retriever")


# =============================================================================
# RETRIEVAL RESULTS
# =============================================================================

@dataclass
class RetrievalResult:
    """Result from retrieval operation."""
    document: Document
    score: float
    retriever_type: str = "vector"
    metadata: Dict[str, Any] = field(default_factory=dict)


class RetrievalMode(str, Enum):
    """Retrieval modes."""
    VECTOR = "vector"  # Pure vector similarity
    KEYWORD = "keyword"  # BM25/keyword search
    HYBRID = "hybrid"  # Combined vector + keyword
    MMRR = "mmr"  # Maximum Marginal Relevance


# =============================================================================
# VECTOR RETRIEVER
# =============================================================================

class VectorRetriever(BaseRetriever):
    """
    Vector similarity retriever.
    
    Uses embedding similarity to find relevant documents.
    """
    
    vector_store: Any
    k: int = 4
    score_threshold: Optional[float] = None
    search_type: str = "similarity"  # similarity, mmr
    mmr_lambda: float = 0.5
    
    class Config:
        arbitrary_types_allowed = True
    
    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: Optional[CallbackManagerForRetrieverRun] = None,
    ) -> List[Document]:
        """Retrieve documents."""
        if self.search_type == "mmr":
            return self.vector_store.max_marginal_relevance_search(
                query,
                k=self.k,
                lambda_mult=self.mmr_lambda,
            )
        
        if self.score_threshold:
            return self.vector_store.similarity_search_with_relevance_scores(
                query,
                k=self.k,
                score_threshold=self.score_threshold,
            )
        
        return self.vector_store.similarity_search(query, k=self.k)
    
    async def _aget_relevant_documents(
        self,
        query: str,
        *,
        run_manager: Optional[CallbackManagerForRetrieverRun] = None,
    ) -> List[Document]:
        """Async retrieve documents."""
        if self.search_type == "mmr":
            return await self.vector_store.amax_marginal_relevance_search(
                query,
                k=self.k,
                lambda_mult=self.mmr_lambda,
            )
        
        return await self.vector_store.asimilarity_search(query, k=self.k)


# =============================================================================
# HYBRID RETRIEVER
# =============================================================================

class HybridRetriever(BaseRetriever):
    """
    Hybrid retriever combining vector and keyword search.
    
    Uses Reciprocal Rank Fusion (RRF) to combine results.
    """
    
    vector_store: Any
    keyword_retriever: Optional[Any] = None
    k: int = 4
    vector_weight: float = 0.5
    keyword_weight: float = 0.5
    rrf_k: int = 60  # RRF constant
    
    class Config:
        arbitrary_types_allowed = True
    
    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: Optional[CallbackManagerForRetrieverRun] = None,
    ) -> List[Document]:
        """Retrieve using hybrid search."""
        # Get vector results
        vector_docs = self.vector_store.similarity_search(
            query, k=self.k * 2
        )
        
        # Get keyword results if available
        keyword_docs = []
        if self.keyword_retriever:
            keyword_docs = self.keyword_retriever.get_relevant_documents(
                query
            )[:self.k * 2]
        
        # Combine using RRF
        return self._reciprocal_rank_fusion(
            vector_docs,
            keyword_docs,
        )
    
    def _reciprocal_rank_fusion(
        self,
        vector_docs: List[Document],
        keyword_docs: List[Document],
    ) -> List[Document]:
        """
        Combine results using Reciprocal Rank Fusion.
        
        RRF score = sum(1 / (k + rank))
        """
        scores: Dict[str, float] = {}
        doc_map: Dict[str, Document] = {}
        
        # Score vector results
        for rank, doc in enumerate(vector_docs):
            doc_id = self._get_doc_id(doc)
            rrf_score = self.vector_weight / (self.rrf_k + rank + 1)
            scores[doc_id] = scores.get(doc_id, 0) + rrf_score
            doc_map[doc_id] = doc
        
        # Score keyword results
        for rank, doc in enumerate(keyword_docs):
            doc_id = self._get_doc_id(doc)
            rrf_score = self.keyword_weight / (self.rrf_k + rank + 1)
            scores[doc_id] = scores.get(doc_id, 0) + rrf_score
            doc_map[doc_id] = doc
        
        # Sort by combined score
        sorted_ids = sorted(scores.keys(), key=lambda x: scores[x], reverse=True)
        
        return [doc_map[doc_id] for doc_id in sorted_ids[:self.k]]
    
    def _get_doc_id(self, doc: Document) -> str:
        """Get unique document identifier."""
        return doc.metadata.get("chunk_id", doc.page_content[:100])


# =============================================================================
# MULTI-QUERY RETRIEVER
# =============================================================================

class MultiQueryRetriever(BaseRetriever):
    """
    Generate multiple query variations for better retrieval.
    
    Uses LLM to generate alternative queries.
    """
    
    base_retriever: BaseRetriever
    llm: Any
    query_count: int = 3
    include_original: bool = True
    
    class Config:
        arbitrary_types_allowed = True
    
    QUERY_GENERATION_PROMPT = """You are an AI assistant helping to generate alternative search queries.

Given the original query, generate {query_count} alternative queries that might help find relevant information.
Each alternative should approach the topic from a different angle or use different terminology.

Original query: {query}

Generate {query_count} alternative queries, one per line:"""
    
    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: Optional[CallbackManagerForRetrieverRun] = None,
    ) -> List[Document]:
        """Retrieve with multiple queries."""
        # Generate alternative queries
        queries = self._generate_queries(query)
        
        # Retrieve for each query
        all_docs: Dict[str, Document] = {}
        
        for q in queries:
            docs = self.base_retriever.get_relevant_documents(q)
            for doc in docs:
                doc_id = doc.metadata.get("chunk_id", doc.page_content[:100])
                if doc_id not in all_docs:
                    all_docs[doc_id] = doc
        
        return list(all_docs.values())
    
    def _generate_queries(self, original_query: str) -> List[str]:
        """Generate alternative queries using LLM."""
        queries = [original_query] if self.include_original else []
        
        try:
            prompt = self.QUERY_GENERATION_PROMPT.format(
                query=original_query,
                query_count=self.query_count,
            )
            
            response = self.llm.invoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            # Parse response
            for line in content.strip().split("\n"):
                line = line.strip()
                if line and not line.startswith(("1.", "2.", "3.", "-", "*")):
                    queries.append(line)
                elif line:
                    # Remove numbering
                    queries.append(line.lstrip("0123456789.-*) "))
            
        except Exception as e:
            logger.warning(f"Query generation failed: {e}")
        
        return queries[:self.query_count + (1 if self.include_original else 0)]


# =============================================================================
# CONTEXTUAL COMPRESSION
# =============================================================================

class ContextualCompressionRetriever(BaseRetriever):
    """
    Compress retrieved documents to extract relevant portions.
    
    Uses LLM to extract only the relevant parts of documents.
    """
    
    base_retriever: BaseRetriever
    llm: Any
    max_output_tokens: int = 500
    
    class Config:
        arbitrary_types_allowed = True
    
    COMPRESSION_PROMPT = """Extract the most relevant information from the document that answers the query.
Only include information that is directly relevant. Be concise.

Query: {query}

Document:
{document}

Relevant excerpt:"""
    
    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: Optional[CallbackManagerForRetrieverRun] = None,
    ) -> List[Document]:
        """Retrieve and compress documents."""
        # Get base documents
        docs = self.base_retriever.get_relevant_documents(query)
        
        # Compress each document
        compressed = []
        for doc in docs:
            compressed_content = self._compress_document(query, doc)
            if compressed_content:
                compressed.append(Document(
                    page_content=compressed_content,
                    metadata={
                        **doc.metadata,
                        "original_length": len(doc.page_content),
                        "compressed": True,
                    }
                ))
        
        return compressed
    
    def _compress_document(self, query: str, doc: Document) -> str:
        """Compress single document."""
        try:
            prompt = self.COMPRESSION_PROMPT.format(
                query=query,
                document=doc.page_content[:2000],  # Limit input
            )
            
            response = self.llm.invoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            return content.strip()
            
        except Exception as e:
            logger.warning(f"Compression failed: {e}")
            return doc.page_content


# =============================================================================
# RETRIEVAL CHAIN
# =============================================================================

class RetrievalChain:
    """
    Complete retrieval pipeline with configurable steps.
    """
    
    def __init__(
        self,
        retrievers: List[BaseRetriever],
        reranker: Optional[Any] = None,
        final_k: int = 4,
    ):
        """
        Initialize retrieval chain.
        
        Args:
            retrievers: List of retrievers to use
            reranker: Optional reranker for final ranking
            final_k: Number of final documents to return
        """
        self.retrievers = retrievers
        self.reranker = reranker
        self.final_k = final_k
    
    def retrieve(self, query: str) -> List[Document]:
        """
        Execute retrieval pipeline.
        
        Args:
            query: Search query
            
        Returns:
            Retrieved and ranked documents
        """
        # Collect from all retrievers
        all_docs: Dict[str, Document] = {}
        
        for retriever in self.retrievers:
            docs = retriever.get_relevant_documents(query)
            for doc in docs:
                doc_id = doc.metadata.get("chunk_id", doc.page_content[:100])
                if doc_id not in all_docs:
                    all_docs[doc_id] = doc
        
        documents = list(all_docs.values())
        
        # Rerank if available
        if self.reranker:
            documents = self.reranker.rerank(query, documents)
        
        return documents[:self.final_k]
    
    async def aretrieve(self, query: str) -> List[Document]:
        """Async retrieval."""
        # Collect from all retrievers
        all_docs: Dict[str, Document] = {}
        
        for retriever in self.retrievers:
            docs = await retriever.aget_relevant_documents(query)
            for doc in docs:
                doc_id = doc.metadata.get("chunk_id", doc.page_content[:100])
                if doc_id not in all_docs:
                    all_docs[doc_id] = doc
        
        documents = list(all_docs.values())
        
        # Rerank if available
        if self.reranker:
            documents = await self.reranker.arerank(query, documents)
        
        return documents[:self.final_k]

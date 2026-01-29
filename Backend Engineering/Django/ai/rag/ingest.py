"""
Document Ingestion
==================
Document processing and chunking for RAG pipelines.

This module provides:
- Document loading from various sources
- Text chunking strategies
- Metadata extraction
- Embedding generation
"""

import logging
import hashlib
from enum import Enum
from typing import Any, Dict, List, Optional, Iterator
from dataclasses import dataclass, field

from langchain_text_splitters import (
    RecursiveCharacterTextSplitter,
    TokenTextSplitter,
    MarkdownHeaderTextSplitter,
    HTMLHeaderTextSplitter,
)
from langchain_core.documents import Document

logger = logging.getLogger("ai.rag.ingest")


# =============================================================================
# CHUNKING STRATEGIES
# =============================================================================

class ChunkingStrategy(str, Enum):
    """Available chunking strategies."""
    RECURSIVE = "recursive"  # Best for general text
    TOKEN = "token"  # Token-based (useful for LLM context limits)
    MARKDOWN = "markdown"  # Preserves markdown structure
    HTML = "html"  # Preserves HTML structure
    SEMANTIC = "semantic"  # Semantic-based chunking
    SENTENCE = "sentence"  # Sentence-level chunking


@dataclass
class ChunkConfig:
    """Configuration for text chunking."""
    strategy: ChunkingStrategy = ChunkingStrategy.RECURSIVE
    chunk_size: int = 1000
    chunk_overlap: int = 200
    separators: Optional[List[str]] = None
    
    # Token-based settings
    encoding_name: str = "cl100k_base"
    
    # Semantic chunking settings
    breakpoint_threshold: float = 0.5


# =============================================================================
# TEXT SPLITTER
# =============================================================================

class TextSplitter:
    """
    Unified interface for text splitting.
    
    Supports multiple chunking strategies with consistent API.
    """
    
    def __init__(self, config: Optional[ChunkConfig] = None):
        """
        Initialize text splitter.
        
        Args:
            config: Chunking configuration
        """
        self.config = config or ChunkConfig()
        self._splitter = self._create_splitter()
    
    def _create_splitter(self):
        """Create the appropriate splitter based on strategy."""
        config = self.config
        
        if config.strategy == ChunkingStrategy.RECURSIVE:
            return RecursiveCharacterTextSplitter(
                chunk_size=config.chunk_size,
                chunk_overlap=config.chunk_overlap,
                separators=config.separators or [
                    "\n\n", "\n", ". ", " ", ""
                ],
                length_function=len,
            )
        
        elif config.strategy == ChunkingStrategy.TOKEN:
            return TokenTextSplitter(
                chunk_size=config.chunk_size,
                chunk_overlap=config.chunk_overlap,
                encoding_name=config.encoding_name,
            )
        
        elif config.strategy == ChunkingStrategy.MARKDOWN:
            headers_to_split_on = [
                ("#", "header_1"),
                ("##", "header_2"),
                ("###", "header_3"),
            ]
            return MarkdownHeaderTextSplitter(
                headers_to_split_on=headers_to_split_on
            )
        
        elif config.strategy == ChunkingStrategy.HTML:
            headers_to_split_on = [
                ("h1", "header_1"),
                ("h2", "header_2"),
                ("h3", "header_3"),
            ]
            return HTMLHeaderTextSplitter(
                headers_to_split_on=headers_to_split_on
            )
        
        else:
            # Default to recursive
            return RecursiveCharacterTextSplitter(
                chunk_size=config.chunk_size,
                chunk_overlap=config.chunk_overlap,
            )
    
    def split_text(self, text: str) -> List[str]:
        """Split text into chunks."""
        return self._splitter.split_text(text)
    
    def split_documents(self, documents: List[Document]) -> List[Document]:
        """Split documents into chunks."""
        return self._splitter.split_documents(documents)
    
    def create_documents(
        self,
        texts: List[str],
        metadatas: Optional[List[Dict[str, Any]]] = None,
    ) -> List[Document]:
        """Create documents from texts."""
        return self._splitter.create_documents(texts, metadatas)


# =============================================================================
# DOCUMENT PROCESSOR
# =============================================================================

@dataclass
class ProcessedDocument:
    """Processed document with chunks and metadata."""
    id: str
    source: str
    chunks: List[Document] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)
    chunk_count: int = 0


class DocumentProcessor:
    """
    Process documents for RAG ingestion.
    
    Features:
    - Document loading from various formats
    - Text extraction and cleaning
    - Chunking with configurable strategies
    - Metadata enrichment
    - Embedding generation
    """
    
    def __init__(
        self,
        chunk_config: Optional[ChunkConfig] = None,
        embeddings_model: Optional[Any] = None,
    ):
        """
        Initialize document processor.
        
        Args:
            chunk_config: Chunking configuration
            embeddings_model: LangChain embeddings model
        """
        self.chunk_config = chunk_config or ChunkConfig()
        self.text_splitter = TextSplitter(self.chunk_config)
        self.embeddings_model = embeddings_model
    
    def _generate_doc_id(self, content: str, source: str) -> str:
        """Generate unique document ID."""
        hash_input = f"{source}:{content[:1000]}"
        return hashlib.sha256(hash_input.encode()).hexdigest()[:16]
    
    def process_text(
        self,
        text: str,
        source: str = "unknown",
        metadata: Optional[Dict[str, Any]] = None,
    ) -> ProcessedDocument:
        """
        Process raw text into chunks.
        
        Args:
            text: Raw text content
            source: Document source identifier
            metadata: Additional metadata
            
        Returns:
            ProcessedDocument with chunks
        """
        doc_id = self._generate_doc_id(text, source)
        base_metadata = metadata or {}
        base_metadata.update({
            "source": source,
            "doc_id": doc_id,
        })
        
        # Split into chunks
        chunks = self.text_splitter.create_documents(
            texts=[text],
            metadatas=[base_metadata],
        )
        
        # Add chunk-specific metadata
        for i, chunk in enumerate(chunks):
            chunk.metadata["chunk_index"] = i
            chunk.metadata["chunk_id"] = f"{doc_id}_{i}"
        
        return ProcessedDocument(
            id=doc_id,
            source=source,
            chunks=chunks,
            metadata=base_metadata,
            chunk_count=len(chunks),
        )
    
    def process_documents(
        self,
        documents: List[Document],
    ) -> List[ProcessedDocument]:
        """
        Process multiple documents.
        
        Args:
            documents: List of LangChain documents
            
        Returns:
            List of processed documents
        """
        results = []
        
        for doc in documents:
            source = doc.metadata.get("source", "unknown")
            processed = self.process_text(
                text=doc.page_content,
                source=source,
                metadata=doc.metadata,
            )
            results.append(processed)
        
        return results
    
    async def process_and_embed(
        self,
        text: str,
        source: str = "unknown",
        metadata: Optional[Dict[str, Any]] = None,
    ) -> List[Dict[str, Any]]:
        """
        Process text and generate embeddings.
        
        Args:
            text: Raw text content
            source: Document source
            metadata: Additional metadata
            
        Returns:
            List of chunks with embeddings
        """
        if not self.embeddings_model:
            raise ValueError("Embeddings model not configured")
        
        # Process into chunks
        processed = self.process_text(text, source, metadata)
        
        # Generate embeddings
        texts = [chunk.page_content for chunk in processed.chunks]
        embeddings = await self.embeddings_model.aembed_documents(texts)
        
        # Combine chunks with embeddings
        results = []
        for chunk, embedding in zip(processed.chunks, embeddings):
            results.append({
                "id": chunk.metadata["chunk_id"],
                "content": chunk.page_content,
                "embedding": embedding,
                "metadata": chunk.metadata,
            })
        
        return results


# =============================================================================
# DOCUMENT LOADERS
# =============================================================================

class DocumentLoaderFactory:
    """Factory for creating document loaders."""
    
    @staticmethod
    def get_loader(file_path: str, **kwargs):
        """
        Get appropriate loader for file type.
        
        Args:
            file_path: Path to document
            **kwargs: Additional loader arguments
        """
        from pathlib import Path
        
        ext = Path(file_path).suffix.lower()
        
        if ext == ".pdf":
            from langchain_community.document_loaders import PyPDFLoader
            return PyPDFLoader(file_path, **kwargs)
        
        elif ext in (".doc", ".docx"):
            from langchain_community.document_loaders import Docx2txtLoader
            return Docx2txtLoader(file_path)
        
        elif ext in (".txt", ".md"):
            from langchain_community.document_loaders import TextLoader
            return TextLoader(file_path, **kwargs)
        
        elif ext in (".html", ".htm"):
            from langchain_community.document_loaders import BSHTMLLoader
            return BSHTMLLoader(file_path, **kwargs)
        
        elif ext == ".csv":
            from langchain_community.document_loaders import CSVLoader
            return CSVLoader(file_path, **kwargs)
        
        elif ext == ".json":
            from langchain_community.document_loaders import JSONLoader
            return JSONLoader(file_path, **kwargs)
        
        else:
            # Default to text loader
            from langchain_community.document_loaders import TextLoader
            return TextLoader(file_path)
    
    @staticmethod
    def load_url(url: str, **kwargs) -> List[Document]:
        """Load document from URL."""
        from langchain_community.document_loaders import WebBaseLoader
        loader = WebBaseLoader(url, **kwargs)
        return loader.load()
    
    @staticmethod
    def load_directory(
        directory: str,
        glob: str = "**/*.*",
        **kwargs,
    ) -> List[Document]:
        """Load all documents from directory."""
        from langchain_community.document_loaders import DirectoryLoader
        loader = DirectoryLoader(directory, glob=glob, **kwargs)
        return loader.load()


# =============================================================================
# BATCH PROCESSOR
# =============================================================================

class BatchDocumentProcessor:
    """
    Process documents in batches for large-scale ingestion.
    """
    
    def __init__(
        self,
        processor: DocumentProcessor,
        batch_size: int = 100,
    ):
        """
        Initialize batch processor.
        
        Args:
            processor: Document processor instance
            batch_size: Number of documents per batch
        """
        self.processor = processor
        self.batch_size = batch_size
    
    def process_batch(
        self,
        documents: List[Document],
    ) -> Iterator[List[ProcessedDocument]]:
        """
        Process documents in batches.
        
        Args:
            documents: Documents to process
            
        Yields:
            Batches of processed documents
        """
        for i in range(0, len(documents), self.batch_size):
            batch = documents[i:i + self.batch_size]
            yield self.processor.process_documents(batch)
    
    async def process_and_store(
        self,
        documents: List[Document],
        vector_store,
    ) -> int:
        """
        Process and store documents in vector store.
        
        Args:
            documents: Documents to process
            vector_store: Vector store instance
            
        Returns:
            Number of chunks stored
        """
        total_chunks = 0
        
        for batch in self.process_batch(documents):
            # Collect all chunks from batch
            all_chunks = []
            for processed in batch:
                all_chunks.extend(processed.chunks)
            
            # Store in vector store
            await vector_store.aadd_documents(all_chunks)
            total_chunks += len(all_chunks)
            
            logger.info(f"Stored {len(all_chunks)} chunks (total: {total_chunks})")
        
        return total_chunks

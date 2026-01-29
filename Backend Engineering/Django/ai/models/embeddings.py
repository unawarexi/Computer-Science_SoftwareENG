"""
Embeddings Module
=================
Embedding model management.

This module provides:
- Multi-provider embeddings
- Caching
- Batch processing
"""

import logging
from enum import Enum
from typing import Any, Dict, List, Optional
from dataclasses import dataclass

from pydantic import BaseModel

logger = logging.getLogger("ai.models.embeddings")


# =============================================================================
# CONFIGURATION
# =============================================================================

class EmbeddingProvider(str, Enum):
    """Supported embedding providers."""
    OPENAI = "openai"
    COHERE = "cohere"
    HUGGINGFACE = "huggingface"
    SENTENCE_TRANSFORMERS = "sentence_transformers"
    GOOGLE = "google"
    OLLAMA = "ollama"
    AZURE_OPENAI = "azure_openai"


class EmbeddingConfig(BaseModel):
    """Configuration for embedding model."""
    provider: EmbeddingProvider
    model_name: str
    api_key: Optional[str] = None
    dimensions: Optional[int] = None
    batch_size: int = 100
    
    # Provider-specific
    base_url: Optional[str] = None
    api_version: Optional[str] = None
    
    # Cost
    cost_per_1k: float = 0.0
    
    class Config:
        use_enum_values = True


# Preset embedding models
PRESET_EMBEDDINGS = {
    "text-embedding-3-small": EmbeddingConfig(
        provider=EmbeddingProvider.OPENAI,
        model_name="text-embedding-3-small",
        dimensions=1536,
        cost_per_1k=0.00002,
    ),
    "text-embedding-3-large": EmbeddingConfig(
        provider=EmbeddingProvider.OPENAI,
        model_name="text-embedding-3-large",
        dimensions=3072,
        cost_per_1k=0.00013,
    ),
    "embed-english-v3.0": EmbeddingConfig(
        provider=EmbeddingProvider.COHERE,
        model_name="embed-english-v3.0",
        dimensions=1024,
        cost_per_1k=0.0001,
    ),
    "all-MiniLM-L6-v2": EmbeddingConfig(
        provider=EmbeddingProvider.SENTENCE_TRANSFORMERS,
        model_name="all-MiniLM-L6-v2",
        dimensions=384,
        cost_per_1k=0.0,  # Local
    ),
    "bge-large-en-v1.5": EmbeddingConfig(
        provider=EmbeddingProvider.HUGGINGFACE,
        model_name="BAAI/bge-large-en-v1.5",
        dimensions=1024,
        cost_per_1k=0.0,  # Local
    ),
}


# =============================================================================
# EMBEDDINGS FACTORY
# =============================================================================

def create_embeddings(config: EmbeddingConfig) -> Any:
    """
    Create embeddings model from configuration.
    
    Args:
        config: Embedding configuration
        
    Returns:
        LangChain embeddings instance
    """
    if config.provider == EmbeddingProvider.OPENAI:
        from langchain_openai import OpenAIEmbeddings
        return OpenAIEmbeddings(
            model=config.model_name,
            api_key=config.api_key,
            dimensions=config.dimensions,
        )
    
    elif config.provider == EmbeddingProvider.COHERE:
        from langchain_cohere import CohereEmbeddings
        return CohereEmbeddings(
            model=config.model_name,
            cohere_api_key=config.api_key,
        )
    
    elif config.provider == EmbeddingProvider.GOOGLE:
        from langchain_google_genai import GoogleGenerativeAIEmbeddings
        return GoogleGenerativeAIEmbeddings(
            model=config.model_name,
            google_api_key=config.api_key,
        )
    
    elif config.provider == EmbeddingProvider.HUGGINGFACE:
        from langchain_huggingface import HuggingFaceEmbeddings
        return HuggingFaceEmbeddings(
            model_name=config.model_name,
        )
    
    elif config.provider == EmbeddingProvider.SENTENCE_TRANSFORMERS:
        from langchain_huggingface import HuggingFaceEmbeddings
        return HuggingFaceEmbeddings(
            model_name=config.model_name,
        )
    
    elif config.provider == EmbeddingProvider.OLLAMA:
        from langchain_ollama import OllamaEmbeddings
        return OllamaEmbeddings(
            model=config.model_name,
            base_url=config.base_url or "http://localhost:11434",
        )
    
    elif config.provider == EmbeddingProvider.AZURE_OPENAI:
        from langchain_openai import AzureOpenAIEmbeddings
        return AzureOpenAIEmbeddings(
            model=config.model_name,
            api_key=config.api_key,
            api_version=config.api_version or "2024-02-15-preview",
            azure_endpoint=config.base_url,
        )
    
    else:
        raise ValueError(f"Unsupported provider: {config.provider}")


# =============================================================================
# EMBEDDINGS MANAGER
# =============================================================================

@dataclass
class EmbeddingStats:
    """Track embedding usage."""
    total_texts: int = 0
    total_batches: int = 0
    total_cost: float = 0.0


class EmbeddingsManager:
    """
    Manage embedding models.
    
    Features:
    - Multiple provider support
    - Caching
    - Batch processing
    - Cost tracking
    """
    
    def __init__(
        self,
        default_model: str = "text-embedding-3-small",
        models: Optional[Dict[str, EmbeddingConfig]] = None,
        cache_embeddings: bool = True,
    ):
        """
        Initialize embeddings manager.
        
        Args:
            default_model: Default embedding model
            models: Custom model configurations
            cache_embeddings: Whether to cache embeddings
        """
        self.default_model = default_model
        self.models = {**PRESET_EMBEDDINGS, **(models or {})}
        self.cache_embeddings = cache_embeddings
        
        self._instances: Dict[str, Any] = {}
        self._stats: Dict[str, EmbeddingStats] = {}
        self._cache: Dict[str, List[float]] = {}
    
    def get_embeddings(
        self,
        model_name: Optional[str] = None,
    ) -> Any:
        """
        Get embeddings model instance.
        
        Args:
            model_name: Model name (uses default if None)
            
        Returns:
            LangChain embeddings instance
        """
        model_name = model_name or self.default_model
        
        # Check cache
        if model_name in self._instances:
            return self._instances[model_name]
        
        # Get config
        if model_name not in self.models:
            raise ValueError(f"Unknown model: {model_name}")
        
        config = self.models[model_name].model_copy()
        
        # Load API key from Django settings if not set
        if not config.api_key:
            config.api_key = self._get_api_key(config.provider)
        
        # Create instance
        embeddings = create_embeddings(config)
        self._instances[model_name] = embeddings
        
        # Initialize stats
        if model_name not in self._stats:
            self._stats[model_name] = EmbeddingStats()
        
        return embeddings
    
    def _get_api_key(self, provider: EmbeddingProvider) -> Optional[str]:
        """Get API key from Django settings."""
        try:
            from django.conf import settings
            ai_config = getattr(settings, "AI_CONFIG", {})
            
            key_map = {
                EmbeddingProvider.OPENAI: "OPENAI_API_KEY",
                EmbeddingProvider.COHERE: "COHERE_API_KEY",
                EmbeddingProvider.GOOGLE: "GOOGLE_API_KEY",
            }
            
            key_name = key_map.get(provider)
            return ai_config.get(key_name) if key_name else None
        except Exception:
            return None
    
    async def embed_text(
        self,
        text: str,
        model_name: Optional[str] = None,
    ) -> List[float]:
        """
        Embed single text.
        
        Args:
            text: Text to embed
            model_name: Model to use
            
        Returns:
            Embedding vector
        """
        model_name = model_name or self.default_model
        
        # Check cache
        cache_key = f"{model_name}:{hash(text)}"
        if self.cache_embeddings and cache_key in self._cache:
            return self._cache[cache_key]
        
        embeddings = self.get_embeddings(model_name)
        vector = await embeddings.aembed_query(text)
        
        # Update stats
        config = self.models[model_name]
        self._stats[model_name].total_texts += 1
        self._stats[model_name].total_cost += config.cost_per_1k / 1000
        
        # Cache
        if self.cache_embeddings:
            self._cache[cache_key] = vector
        
        return vector
    
    async def embed_texts(
        self,
        texts: List[str],
        model_name: Optional[str] = None,
    ) -> List[List[float]]:
        """
        Embed multiple texts.
        
        Args:
            texts: Texts to embed
            model_name: Model to use
            
        Returns:
            List of embedding vectors
        """
        model_name = model_name or self.default_model
        embeddings = self.get_embeddings(model_name)
        
        config = self.models[model_name]
        batch_size = config.batch_size
        
        all_vectors = []
        
        # Process in batches
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            
            # Check cache for batch
            if self.cache_embeddings:
                vectors = []
                uncached = []
                uncached_indices = []
                
                for j, text in enumerate(batch):
                    cache_key = f"{model_name}:{hash(text)}"
                    if cache_key in self._cache:
                        vectors.append(self._cache[cache_key])
                    else:
                        uncached.append(text)
                        uncached_indices.append(j)
                
                # Embed uncached texts
                if uncached:
                    new_vectors = await embeddings.aembed_documents(uncached)
                    
                    # Cache and insert
                    for idx, (text, vector) in enumerate(zip(uncached, new_vectors)):
                        cache_key = f"{model_name}:{hash(text)}"
                        self._cache[cache_key] = vector
                        vectors.insert(uncached_indices[idx], vector)
                
                all_vectors.extend(vectors)
            else:
                vectors = await embeddings.aembed_documents(batch)
                all_vectors.extend(vectors)
            
            # Update stats
            self._stats[model_name].total_texts += len(batch)
            self._stats[model_name].total_batches += 1
            self._stats[model_name].total_cost += (len(batch) * config.cost_per_1k / 1000)
        
        return all_vectors
    
    def get_stats(self) -> Dict[str, Dict[str, Any]]:
        """Get usage statistics."""
        return {
            model: {
                "total_texts": stats.total_texts,
                "total_batches": stats.total_batches,
                "total_cost": round(stats.total_cost, 6),
            }
            for model, stats in self._stats.items()
        }
    
    def clear_cache(self) -> int:
        """Clear embedding cache. Returns number of entries cleared."""
        count = len(self._cache)
        self._cache.clear()
        return count


# =============================================================================
# CONVENIENCE FUNCTIONS
# =============================================================================

# Global manager instance
_manager: Optional[EmbeddingsManager] = None


def get_manager() -> EmbeddingsManager:
    """Get global embeddings manager."""
    global _manager
    if _manager is None:
        _manager = EmbeddingsManager()
    return _manager


def get_embeddings(model_name: Optional[str] = None) -> Any:
    """Get embeddings model from global manager."""
    return get_manager().get_embeddings(model_name)


def get_default_embeddings() -> Any:
    """Get default embeddings model."""
    return get_manager().get_embeddings()

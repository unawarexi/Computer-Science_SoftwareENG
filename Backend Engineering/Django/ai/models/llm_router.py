"""
LLM Router
==========
Multi-provider LLM routing and management.

This module provides:
- LLM configuration
- Provider routing
- Fallback handling
- Cost tracking
"""

import logging
from enum import Enum
from typing import Any, Dict, List, Optional, Callable
from dataclasses import dataclass, field

from pydantic import BaseModel, Field

logger = logging.getLogger("ai.models.llm_router")


# =============================================================================
# MODEL CONFIGURATION
# =============================================================================

class ModelProvider(str, Enum):
    """Supported LLM providers."""
    OPENAI = "openai"
    ANTHROPIC = "anthropic"
    GOOGLE = "google"
    COHERE = "cohere"
    AZURE_OPENAI = "azure_openai"
    OLLAMA = "ollama"
    HUGGINGFACE = "huggingface"


class ModelConfig(BaseModel):
    """Configuration for an LLM model."""
    provider: ModelProvider
    model_name: str
    api_key: Optional[str] = None
    temperature: float = 0.7
    max_tokens: Optional[int] = None
    top_p: float = 1.0
    timeout: int = 60
    max_retries: int = 3
    
    # Provider-specific settings
    base_url: Optional[str] = None
    api_version: Optional[str] = None  # For Azure
    deployment_name: Optional[str] = None  # For Azure
    
    # Cost tracking
    input_cost_per_1k: float = 0.0
    output_cost_per_1k: float = 0.0
    
    class Config:
        use_enum_values = True


# Pre-defined model configurations
PRESET_MODELS = {
    "gpt-4o": ModelConfig(
        provider=ModelProvider.OPENAI,
        model_name="gpt-4o",
        input_cost_per_1k=0.005,
        output_cost_per_1k=0.015,
    ),
    "gpt-4o-mini": ModelConfig(
        provider=ModelProvider.OPENAI,
        model_name="gpt-4o-mini",
        input_cost_per_1k=0.00015,
        output_cost_per_1k=0.0006,
    ),
    "gpt-3.5-turbo": ModelConfig(
        provider=ModelProvider.OPENAI,
        model_name="gpt-3.5-turbo",
        input_cost_per_1k=0.0005,
        output_cost_per_1k=0.0015,
    ),
    "claude-3-5-sonnet": ModelConfig(
        provider=ModelProvider.ANTHROPIC,
        model_name="claude-3-5-sonnet-20241022",
        input_cost_per_1k=0.003,
        output_cost_per_1k=0.015,
    ),
    "claude-3-opus": ModelConfig(
        provider=ModelProvider.ANTHROPIC,
        model_name="claude-3-opus-20240229",
        input_cost_per_1k=0.015,
        output_cost_per_1k=0.075,
    ),
    "claude-3-haiku": ModelConfig(
        provider=ModelProvider.ANTHROPIC,
        model_name="claude-3-haiku-20240307",
        input_cost_per_1k=0.00025,
        output_cost_per_1k=0.00125,
    ),
    "gemini-pro": ModelConfig(
        provider=ModelProvider.GOOGLE,
        model_name="gemini-pro",
        input_cost_per_1k=0.0005,
        output_cost_per_1k=0.0015,
    ),
}


# =============================================================================
# LLM FACTORY
# =============================================================================

def create_llm(config: ModelConfig) -> Any:
    """
    Create LLM instance from configuration.
    
    Args:
        config: Model configuration
        
    Returns:
        LangChain LLM instance
    """
    common_params = {
        "temperature": config.temperature,
        "max_tokens": config.max_tokens,
    }
    
    if config.provider == ModelProvider.OPENAI:
        from langchain_openai import ChatOpenAI
        return ChatOpenAI(
            model=config.model_name,
            api_key=config.api_key,
            timeout=config.timeout,
            max_retries=config.max_retries,
            **common_params,
        )
    
    elif config.provider == ModelProvider.ANTHROPIC:
        from langchain_anthropic import ChatAnthropic
        return ChatAnthropic(
            model=config.model_name,
            api_key=config.api_key,
            timeout=config.timeout,
            max_retries=config.max_retries,
            **common_params,
        )
    
    elif config.provider == ModelProvider.GOOGLE:
        from langchain_google_genai import ChatGoogleGenerativeAI
        return ChatGoogleGenerativeAI(
            model=config.model_name,
            google_api_key=config.api_key,
            **common_params,
        )
    
    elif config.provider == ModelProvider.AZURE_OPENAI:
        from langchain_openai import AzureChatOpenAI
        return AzureChatOpenAI(
            deployment_name=config.deployment_name or config.model_name,
            api_key=config.api_key,
            api_version=config.api_version or "2024-02-15-preview",
            azure_endpoint=config.base_url,
            **common_params,
        )
    
    elif config.provider == ModelProvider.OLLAMA:
        from langchain_ollama import ChatOllama
        return ChatOllama(
            model=config.model_name,
            base_url=config.base_url or "http://localhost:11434",
            **common_params,
        )
    
    elif config.provider == ModelProvider.COHERE:
        from langchain_cohere import ChatCohere
        return ChatCohere(
            model=config.model_name,
            cohere_api_key=config.api_key,
            **common_params,
        )
    
    else:
        raise ValueError(f"Unsupported provider: {config.provider}")


# =============================================================================
# LLM ROUTER
# =============================================================================

@dataclass
class UsageStats:
    """Track LLM usage statistics."""
    total_calls: int = 0
    total_input_tokens: int = 0
    total_output_tokens: int = 0
    total_cost: float = 0.0
    errors: int = 0
    
    def update(
        self,
        input_tokens: int,
        output_tokens: int,
        input_cost_per_1k: float,
        output_cost_per_1k: float,
    ) -> None:
        """Update statistics."""
        self.total_calls += 1
        self.total_input_tokens += input_tokens
        self.total_output_tokens += output_tokens
        self.total_cost += (
            (input_tokens / 1000) * input_cost_per_1k +
            (output_tokens / 1000) * output_cost_per_1k
        )


class LLMRouter:
    """
    Route LLM requests across multiple providers.
    
    Features:
    - Multiple provider support
    - Automatic fallback
    - Cost tracking
    - Request routing based on task type
    """
    
    def __init__(
        self,
        default_model: str = "gpt-4o-mini",
        models: Optional[Dict[str, ModelConfig]] = None,
        fallback_order: Optional[List[str]] = None,
    ):
        """
        Initialize LLM router.
        
        Args:
            default_model: Default model name
            models: Custom model configurations
            fallback_order: Order of models for fallback
        """
        self.default_model = default_model
        self.models = {**PRESET_MODELS, **(models or {})}
        self.fallback_order = fallback_order or [default_model]
        
        self._instances: Dict[str, Any] = {}
        self._stats: Dict[str, UsageStats] = {}
    
    def get_llm(
        self,
        model_name: Optional[str] = None,
        **overrides,
    ) -> Any:
        """
        Get or create LLM instance.
        
        Args:
            model_name: Model name (uses default if None)
            **overrides: Override config parameters
            
        Returns:
            LangChain LLM instance
        """
        model_name = model_name or self.default_model
        
        # Check cache
        cache_key = f"{model_name}:{hash(frozenset(overrides.items()))}"
        if cache_key in self._instances:
            return self._instances[cache_key]
        
        # Get config
        if model_name not in self.models:
            raise ValueError(f"Unknown model: {model_name}")
        
        config = self.models[model_name].model_copy()
        
        # Apply overrides
        for key, value in overrides.items():
            if hasattr(config, key):
                setattr(config, key, value)
        
        # Load API key from Django settings if not set
        if not config.api_key:
            config.api_key = self._get_api_key(config.provider)
        
        # Create instance
        llm = create_llm(config)
        self._instances[cache_key] = llm
        
        # Initialize stats
        if model_name not in self._stats:
            self._stats[model_name] = UsageStats()
        
        return llm
    
    def _get_api_key(self, provider: ModelProvider) -> Optional[str]:
        """Get API key from Django settings."""
        try:
            from django.conf import settings
            ai_config = getattr(settings, "AI_CONFIG", {})
            
            key_map = {
                ModelProvider.OPENAI: "OPENAI_API_KEY",
                ModelProvider.ANTHROPIC: "ANTHROPIC_API_KEY",
                ModelProvider.GOOGLE: "GOOGLE_API_KEY",
                ModelProvider.COHERE: "COHERE_API_KEY",
            }
            
            key_name = key_map.get(provider)
            return ai_config.get(key_name) if key_name else None
        except Exception:
            return None
    
    async def invoke(
        self,
        prompt: str,
        model_name: Optional[str] = None,
        **kwargs,
    ) -> str:
        """
        Invoke LLM with automatic fallback.
        
        Args:
            prompt: Input prompt
            model_name: Model to use
            **kwargs: Additional parameters
            
        Returns:
            Model response
        """
        models_to_try = [model_name] if model_name else []
        models_to_try.extend(self.fallback_order)
        
        last_error = None
        
        for model in models_to_try:
            try:
                llm = self.get_llm(model)
                response = await llm.ainvoke(prompt)
                
                # Track usage
                if hasattr(response, 'usage_metadata'):
                    usage = response.usage_metadata
                    config = self.models[model]
                    self._stats[model].update(
                        input_tokens=usage.get("input_tokens", 0),
                        output_tokens=usage.get("output_tokens", 0),
                        input_cost_per_1k=config.input_cost_per_1k,
                        output_cost_per_1k=config.output_cost_per_1k,
                    )
                
                return response.content if hasattr(response, 'content') else str(response)
                
            except Exception as e:
                logger.warning(f"Model {model} failed: {e}")
                self._stats.setdefault(model, UsageStats()).errors += 1
                last_error = e
                continue
        
        raise last_error or Exception("All models failed")
    
    def get_for_task(self, task_type: str) -> Any:
        """
        Get model optimized for specific task.
        
        Args:
            task_type: Type of task (chat, code, reasoning, fast)
            
        Returns:
            LLM instance
        """
        task_models = {
            "chat": "gpt-4o-mini",
            "code": "claude-3-5-sonnet",
            "reasoning": "gpt-4o",
            "fast": "gpt-3.5-turbo",
            "creative": "claude-3-opus",
        }
        
        model_name = task_models.get(task_type, self.default_model)
        return self.get_llm(model_name)
    
    def get_stats(self) -> Dict[str, Dict[str, Any]]:
        """Get usage statistics for all models."""
        return {
            model: {
                "total_calls": stats.total_calls,
                "total_input_tokens": stats.total_input_tokens,
                "total_output_tokens": stats.total_output_tokens,
                "total_cost": round(stats.total_cost, 4),
                "errors": stats.errors,
            }
            for model, stats in self._stats.items()
        }


# =============================================================================
# CONVENIENCE FUNCTIONS
# =============================================================================

# Global router instance
_router: Optional[LLMRouter] = None


def get_router() -> LLMRouter:
    """Get global LLM router instance."""
    global _router
    if _router is None:
        _router = LLMRouter()
    return _router


def get_llm(model_name: Optional[str] = None, **kwargs) -> Any:
    """Get LLM instance from global router."""
    return get_router().get_llm(model_name, **kwargs)


def get_default_llm() -> Any:
    """Get default LLM instance."""
    return get_router().get_llm()

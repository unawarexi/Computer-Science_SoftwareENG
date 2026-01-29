"""
Base Tool Classes
=================
Base classes and utilities for building agent tools.

Provides a consistent interface for all tools with:
- Schema definition for LLM function calling
- Error handling and logging
- Execution tracking and metrics
"""

import logging
from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional
from dataclasses import dataclass, field
from datetime import datetime

from pydantic import BaseModel, Field
from langchain_core.tools import BaseTool as LangChainBaseTool

logger = logging.getLogger("ai.tools")


# =============================================================================
# DATA MODELS
# =============================================================================

@dataclass
class ToolResult:
    """Result from a tool execution."""
    success: bool
    result: Any
    error: Optional[str] = None
    error_type: Optional[str] = None
    execution_time: float = 0.0
    metadata: Dict[str, Any] = field(default_factory=dict)
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return {
            "success": self.success,
            "result": self.result,
            "error": self.error,
            "error_type": self.error_type,
            "execution_time": self.execution_time,
            "metadata": self.metadata,
        }


class ToolSchema(BaseModel):
    """Schema definition for a tool."""
    name: str
    description: str
    parameters: Dict[str, Any] = Field(default_factory=dict)
    required: List[str] = Field(default_factory=list)
    returns: str = "string"
    examples: List[Dict] = Field(default_factory=list)
    
    def to_openai_function(self) -> Dict:
        """Convert to OpenAI function calling format."""
        return {
            "type": "function",
            "function": {
                "name": self.name,
                "description": self.description,
                "parameters": {
                    "type": "object",
                    "properties": self.parameters,
                    "required": self.required,
                },
            },
        }
    
    def to_anthropic_tool(self) -> Dict:
        """Convert to Anthropic tool format."""
        return {
            "name": self.name,
            "description": self.description,
            "input_schema": {
                "type": "object",
                "properties": self.parameters,
                "required": self.required,
            },
        }


# =============================================================================
# BASE TOOL CLASS
# =============================================================================

class BaseTool(ABC):
    """
    Abstract base class for all agent tools.
    
    Provides a consistent interface for tool implementation with:
    - Automatic error handling
    - Execution tracking
    - Logging
    
    Example:
        class MyTool(BaseTool):
            @property
            def name(self) -> str:
                return "my_tool"
            
            @property
            def description(self) -> str:
                return "Does something useful"
            
            async def execute(self, **kwargs) -> Any:
                return "result"
    """
    
    def __init__(self):
        """Initialize the tool."""
        self.call_count = 0
        self.error_count = 0
        self.total_execution_time = 0.0
    
    @property
    @abstractmethod
    def name(self) -> str:
        """Return the tool name."""
        pass
    
    @property
    @abstractmethod
    def description(self) -> str:
        """Return a description of what the tool does."""
        pass
    
    @property
    def parameters(self) -> Dict[str, Any]:
        """Return JSON Schema for tool parameters."""
        return {}
    
    @property
    def required_params(self) -> List[str]:
        """Return list of required parameter names."""
        return []
    
    @abstractmethod
    async def execute(self, **kwargs) -> Any:
        """Execute the tool with given parameters."""
        pass
    
    async def __call__(self, **kwargs) -> ToolResult:
        """
        Execute the tool with error handling and tracking.
        
        Args:
            **kwargs: Tool parameters
            
        Returns:
            ToolResult with execution results
        """
        import time
        
        self.call_count += 1
        start_time = time.time()
        
        try:
            # Validate required parameters
            for param in self.required_params:
                if param not in kwargs:
                    raise ValueError(f"Missing required parameter: {param}")
            
            # Execute the tool
            result = await self.execute(**kwargs)
            
            execution_time = time.time() - start_time
            self.total_execution_time += execution_time
            
            logger.debug(f"Tool {self.name} executed in {execution_time:.3f}s")
            
            return ToolResult(
                success=True,
                result=result,
                execution_time=execution_time,
            )
            
        except Exception as e:
            self.error_count += 1
            execution_time = time.time() - start_time
            
            logger.error(f"Tool {self.name} failed: {e}")
            
            return ToolResult(
                success=False,
                result=None,
                error=str(e),
                error_type=type(e).__name__,
                execution_time=execution_time,
            )
    
    def get_schema(self) -> ToolSchema:
        """Get the tool's schema."""
        return ToolSchema(
            name=self.name,
            description=self.description,
            parameters=self.parameters,
            required=self.required_params,
        )
    
    def get_stats(self) -> Dict[str, Any]:
        """Get tool usage statistics."""
        return {
            "name": self.name,
            "call_count": self.call_count,
            "error_count": self.error_count,
            "success_rate": (
                (self.call_count - self.error_count) / self.call_count
                if self.call_count > 0 else 0
            ),
            "total_execution_time": self.total_execution_time,
            "avg_execution_time": (
                self.total_execution_time / self.call_count
                if self.call_count > 0 else 0
            ),
        }
    
    def to_langchain_tool(self) -> LangChainBaseTool:
        """Convert to LangChain tool format."""
        from langchain_core.tools import StructuredTool
        
        # Create sync wrapper for async execute
        def sync_execute(**kwargs):
            import asyncio
            loop = asyncio.get_event_loop()
            result = loop.run_until_complete(self(**kwargs))
            return result.result if result.success else f"Error: {result.error}"
        
        return StructuredTool.from_function(
            func=sync_execute,
            name=self.name,
            description=self.description,
        )


# =============================================================================
# TOOL REGISTRY
# =============================================================================

class ToolRegistry:
    """
    Central registry for managing tools.
    
    Provides tool discovery, registration, and access.
    """
    
    _instance = None
    
    def __new__(cls):
        """Singleton pattern."""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._tools: Dict[str, BaseTool] = {}
            cls._instance._categories: Dict[str, List[str]] = {}
        return cls._instance
    
    def register(self, tool: BaseTool, category: str = "general"):
        """Register a tool."""
        self._tools[tool.name] = tool
        
        if category not in self._categories:
            self._categories[category] = []
        self._categories[category].append(tool.name)
        
        logger.info(f"Registered tool: {tool.name} in category: {category}")
    
    def get(self, name: str) -> Optional[BaseTool]:
        """Get a tool by name."""
        return self._tools.get(name)
    
    def get_by_category(self, category: str) -> List[BaseTool]:
        """Get all tools in a category."""
        names = self._categories.get(category, [])
        return [self._tools[name] for name in names if name in self._tools]
    
    def list_tools(self) -> Dict[str, List[str]]:
        """List all registered tools by category."""
        return self._categories.copy()
    
    def get_all_schemas(self) -> List[Dict]:
        """Get schemas for all registered tools."""
        return [
            tool.get_schema().to_openai_function()
            for tool in self._tools.values()
        ]
    
    def get_all_tools(self) -> List[BaseTool]:
        """Get all registered tools."""
        return list(self._tools.values())


# Global registry instance
tool_registry = ToolRegistry()

"""
AI Tools Module
===============
Tool implementations for AI agents.

This module provides various tools that agents can use to interact with
the external world, including search, database access, code execution,
and API integrations.

Components:
- base: Base tool class, registry, and utilities
- search: Web search tools (Tavily, Serper, DuckDuckGo)
- db: Database query tools (SQL, Django ORM)
- code_execution: Safe code execution and calculator
- http_client: HTTP requests and API clients
- file_operations: Safe file access and document loading
"""

from ai.tools.base import BaseTool, ToolResult, ToolSchema, ToolRegistry
from ai.tools.search import (
    WebSearchTool,
    TavilySearchTool,
    SerperSearchTool,
    DuckDuckGoSearchTool,
)
from ai.tools.db import DatabaseQueryTool, DjangoORMTool
from ai.tools.code_execution import CodeExecutionTool, CalculatorTool
from ai.tools.http_client import HTTPClientTool, APIClientTool, WebhookTool
from ai.tools.file_operations import FileOperationsTool, DocumentLoaderTool

__all__ = [
    # Base
    "BaseTool",
    "ToolResult",
    "ToolSchema",
    "ToolRegistry",
    # Search
    "WebSearchTool",
    "TavilySearchTool",
    "SerperSearchTool",
    "DuckDuckGoSearchTool",
    # Database
    "DatabaseQueryTool",
    "DjangoORMTool",
    # Code Execution
    "CodeExecutionTool",
    "CalculatorTool",
    # HTTP
    "HTTPClientTool",
    "APIClientTool",
    "WebhookTool",
    # Files
    "FileOperationsTool",
    "DocumentLoaderTool",
    # Utilities
    "get_default_tools",
    "get_langchain_tools",
]


def get_default_tools():
    """Get the default set of tools for agents."""
    from django.conf import settings
    
    tools = []
    
    # Search tool
    tavily_key = settings.AI_CONFIG.get("TAVILY_API_KEY")
    if tavily_key:
        tools.append(TavilySearchTool(api_key=tavily_key))
    else:
        tools.append(WebSearchTool())
    
    # Calculator
    tools.append(CalculatorTool())
    
    # Code execution (if enabled)
    tools.append(CodeExecutionTool())
    
    # HTTP requests
    tools.append(HTTPClientTool())
    
    return tools


def get_langchain_tools():
    """
    Get LangChain-compatible tools for use with LangChain agents.
    
    Returns list of @tool decorated functions.
    """
    from ai.tools.search import web_search
    from ai.tools.db import query_database
    from ai.tools.code_execution import execute_python, calculate
    from ai.tools.http_client import http_get, http_post
    from ai.tools.file_operations import read_file_content, list_directory
    
    return [
        web_search,
        query_database,
        execute_python,
        calculate,
        http_get,
        http_post,
        read_file_content,
        list_directory,
    ]

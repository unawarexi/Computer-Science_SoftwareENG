"""
Search Tools
============
Web search tool implementations using various providers.

Supports:
- Tavily API (recommended for AI agents)
- Serper API (Google search)
- DuckDuckGo (free, no API key)
"""

import logging
from typing import Any, Dict, List, Optional

import httpx
from langchain_core.tools import tool

from ai.tools.base import BaseTool

logger = logging.getLogger("ai.tools.search")


# =============================================================================
# TAVILY SEARCH TOOL
# =============================================================================

class TavilySearchTool(BaseTool):
    """
    Web search using Tavily API.
    
    Tavily is optimized for AI agents and provides clean, relevant results
    with optional answer extraction.
    """
    
    def __init__(
        self,
        api_key: str,
        search_depth: str = "basic",
        include_answer: bool = True,
        include_raw_content: bool = False,
        max_results: int = 5,
    ):
        """
        Initialize Tavily search tool.
        
        Args:
            api_key: Tavily API key
            search_depth: "basic" or "advanced" (more thorough but slower)
            include_answer: Include AI-generated answer
            include_raw_content: Include raw page content
            max_results: Maximum number of results
        """
        super().__init__()
        self.api_key = api_key
        self.search_depth = search_depth
        self.include_answer = include_answer
        self.include_raw_content = include_raw_content
        self.max_results = max_results
        self.endpoint = "https://api.tavily.com/search"
    
    @property
    def name(self) -> str:
        return "tavily_search"
    
    @property
    def description(self) -> str:
        return """Search the web for current information using Tavily.
        Use this when you need up-to-date information, news, facts, or research.
        Returns relevant search results with titles, snippets, and URLs."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "The search query - be specific for better results",
            },
            "search_depth": {
                "type": "string",
                "description": "Search depth: 'basic' (fast) or 'advanced' (thorough)",
                "enum": ["basic", "advanced"],
                "default": "basic",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(
        self,
        query: str,
        search_depth: Optional[str] = None,
    ) -> Dict[str, Any]:
        """
        Execute web search.
        
        Args:
            query: Search query
            search_depth: Override default search depth
            
        Returns:
            Search results with answer, sources, and content
        """
        async with httpx.AsyncClient(timeout=30) as client:
            response = await client.post(
                self.endpoint,
                json={
                    "api_key": self.api_key,
                    "query": query,
                    "search_depth": search_depth or self.search_depth,
                    "include_answer": self.include_answer,
                    "include_raw_content": self.include_raw_content,
                    "max_results": self.max_results,
                }
            )
            response.raise_for_status()
            data = response.json()
        
        results = {
            "query": query,
            "answer": data.get("answer"),
            "results": [
                {
                    "title": r.get("title"),
                    "url": r.get("url"),
                    "content": r.get("content"),
                    "score": r.get("score"),
                }
                for r in data.get("results", [])
            ],
        }
        
        logger.info(f"Tavily search for '{query}' returned {len(results['results'])} results")
        
        return results


# =============================================================================
# SERPER SEARCH TOOL
# =============================================================================

class SerperSearchTool(BaseTool):
    """
    Web search using Serper API (Google Search).
    """
    
    def __init__(self, api_key: str, num_results: int = 10):
        """Initialize Serper search tool."""
        super().__init__()
        self.api_key = api_key
        self.num_results = num_results
        self.endpoint = "https://google.serper.dev/search"
    
    @property
    def name(self) -> str:
        return "google_search"
    
    @property
    def description(self) -> str:
        return """Search Google for information.
        Use for finding websites, articles, news, and general information."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "The search query",
            },
            "num_results": {
                "type": "integer",
                "description": "Number of results to return",
                "default": 10,
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(
        self,
        query: str,
        num_results: Optional[int] = None,
    ) -> List[Dict[str, Any]]:
        """Execute Google search via Serper."""
        async with httpx.AsyncClient(timeout=30) as client:
            response = await client.post(
                self.endpoint,
                headers={"X-API-KEY": self.api_key, "Content-Type": "application/json"},
                json={"q": query, "num": num_results or self.num_results}
            )
            response.raise_for_status()
            data = response.json()
        
        results = []
        
        # Organic results
        for r in data.get("organic", []):
            results.append({
                "type": "organic",
                "title": r.get("title"),
                "url": r.get("link"),
                "snippet": r.get("snippet"),
                "position": r.get("position"),
            })
        
        # Knowledge graph
        if "knowledgeGraph" in data:
            kg = data["knowledgeGraph"]
            results.insert(0, {
                "type": "knowledge_graph",
                "title": kg.get("title"),
                "description": kg.get("description"),
                "attributes": kg.get("attributes", {}),
            })
        
        return results


# =============================================================================
# DUCKDUCKGO SEARCH TOOL (Free)
# =============================================================================

class DuckDuckGoSearchTool(BaseTool):
    """
    Web search using DuckDuckGo (no API key required).
    """
    
    def __init__(self, max_results: int = 10):
        """Initialize DuckDuckGo search tool."""
        super().__init__()
        self.max_results = max_results
    
    @property
    def name(self) -> str:
        return "duckduckgo_search"
    
    @property
    def description(self) -> str:
        return """Search the web using DuckDuckGo.
        Good for general searches. No API key required."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "The search query",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(self, query: str) -> List[Dict[str, Any]]:
        """Execute DuckDuckGo search."""
        try:
            from duckduckgo_search import DDGS
        except ImportError:
            raise ImportError("Install duckduckgo-search: pip install duckduckgo-search")
        
        results = []
        with DDGS() as ddgs:
            for r in ddgs.text(query, max_results=self.max_results):
                results.append({
                    "title": r.get("title"),
                    "url": r.get("href"),
                    "snippet": r.get("body"),
                })
        
        return results


# =============================================================================
# GENERIC WEB SEARCH TOOL (uses available provider)
# =============================================================================

class WebSearchTool(BaseTool):
    """
    Generic web search tool that uses the best available provider.
    
    Falls back through providers: Tavily -> Serper -> DuckDuckGo
    """
    
    def __init__(self):
        """Initialize with available provider."""
        super().__init__()
        self._provider = None
        self._init_provider()
    
    def _init_provider(self):
        """Initialize the best available search provider."""
        from django.conf import settings
        
        tavily_key = settings.AI_CONFIG.get("TAVILY_API_KEY")
        serper_key = settings.AI_CONFIG.get("SERPER_API_KEY")
        
        if tavily_key:
            self._provider = TavilySearchTool(api_key=tavily_key)
            self._provider_name = "tavily"
        elif serper_key:
            self._provider = SerperSearchTool(api_key=serper_key)
            self._provider_name = "serper"
        else:
            self._provider = DuckDuckGoSearchTool()
            self._provider_name = "duckduckgo"
        
        logger.info(f"WebSearchTool initialized with provider: {self._provider_name}")
    
    @property
    def name(self) -> str:
        return "web_search"
    
    @property
    def description(self) -> str:
        return """Search the web for current information.
        Use when you need to find recent information, news, facts, or research online.
        Returns relevant search results with titles, snippets, and URLs."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "The search query - be specific for better results",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(self, query: str) -> Any:
        """Execute search using the available provider."""
        return await self._provider.execute(query=query)


# =============================================================================
# LANGCHAIN TOOL DECORATORS
# =============================================================================

@tool
def search_web(query: str) -> str:
    """Search the web for information. Use for finding current information, news, and facts."""
    import asyncio
    tool = WebSearchTool()
    result = asyncio.get_event_loop().run_until_complete(tool.execute(query=query))
    
    # Format results as string
    if isinstance(result, dict):
        answer = result.get("answer", "")
        results = result.get("results", [])
        formatted = f"Answer: {answer}\n\nSources:\n"
        for r in results[:5]:
            formatted += f"- {r.get('title')}: {r.get('content', '')[:200]}...\n"
        return formatted
    elif isinstance(result, list):
        formatted = "Search Results:\n"
        for r in result[:5]:
            formatted += f"- {r.get('title')}: {r.get('snippet', '')}\n"
        return formatted
    
    return str(result)

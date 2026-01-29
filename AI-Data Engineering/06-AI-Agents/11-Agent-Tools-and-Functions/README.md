# 🔧 Module 11: Agent Tools and Functions

## Overview

This module covers designing, implementing, and integrating tools that extend AI agent capabilities beyond pure text generation.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Design** effective tool interfaces for agents
2. **Implement** custom tools with proper error handling
3. **Understand** function calling protocols
4. **Build** tool registries and dynamic loading
5. **Handle** tool execution security and sandboxing

---

## 📚 Prerequisites

- Module 03: AI Agent Frameworks
- Module 05: Understanding AI Agents
- Python programming fundamentals

---

## 🛠️ What Are Agent Tools?

```
┌─────────────────────────────────────────────────────────────────┐
│                       AGENT TOOLS OVERVIEW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Tools are interfaces that allow agents to:                     │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │  Access  │  │  Execute │  │ Interact │  │  Query   │        │
│  │  Data    │  │   Code   │  │  with    │  │   APIs   │        │
│  │          │  │          │  │  World   │  │          │        │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │
│       │             │             │             │                │
│       ▼             ▼             ▼             ▼                │
│  ┌─────────────────────────────────────────────────────┐       │
│  │                      AGENT                           │       │
│  │  "I need to search the web for recent news..."      │       │
│  │  "Let me calculate this equation..."                │       │
│  │  "I'll query the database for user info..."         │       │
│  └─────────────────────────────────────────────────────┘       │
│                                                                  │
│  TOOL CATEGORIES:                                               │
│  • Information: Search, RAG, Database queries                   │
│  • Computation: Math, Code execution, Data analysis             │
│  • Communication: Email, Messaging, Notifications               │
│  • File Operations: Read, Write, Edit files                     │
│  • External Services: APIs, Webhooks, Integrations              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📋 Tool Design Principles

### The Anatomy of a Good Tool

```python
from typing import Dict, Any, Optional, List
from dataclasses import dataclass, field
from abc import ABC, abstractmethod
from pydantic import BaseModel, Field

@dataclass
class ToolSchema:
    """Schema definition for a tool."""
    name: str
    description: str
    parameters: Dict[str, Any]
    required: List[str] = field(default_factory=list)
    returns: str = "string"
    examples: List[Dict] = field(default_factory=list)
    
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
                    "required": self.required
                }
            }
        }
    
    def to_anthropic_tool(self) -> Dict:
        """Convert to Anthropic tool format."""
        return {
            "name": self.name,
            "description": self.description,
            "input_schema": {
                "type": "object",
                "properties": self.parameters,
                "required": self.required
            }
        }


class BaseTool(ABC):
    """Base class for all agent tools."""
    
    def __init__(self):
        self.name = self.__class__.__name__
        self.call_count = 0
        self.error_count = 0
    
    @property
    @abstractmethod
    def description(self) -> str:
        """Human-readable description of what the tool does."""
        pass
    
    @property
    @abstractmethod
    def parameters(self) -> Dict[str, Any]:
        """JSON Schema for tool parameters."""
        pass
    
    @property
    def required_params(self) -> List[str]:
        """List of required parameter names."""
        return []
    
    @abstractmethod
    async def execute(self, **kwargs) -> Any:
        """Execute the tool with given parameters."""
        pass
    
    async def __call__(self, **kwargs) -> Dict[str, Any]:
        """Wrapper for execute with error handling and logging."""
        self.call_count += 1
        
        try:
            # Validate required parameters
            for param in self.required_params:
                if param not in kwargs:
                    raise ValueError(f"Missing required parameter: {param}")
            
            # Execute tool
            result = await self.execute(**kwargs)
            
            return {
                "success": True,
                "result": result,
                "tool": self.name
            }
        
        except Exception as e:
            self.error_count += 1
            return {
                "success": False,
                "error": str(e),
                "error_type": type(e).__name__,
                "tool": self.name
            }
    
    def get_schema(self) -> ToolSchema:
        """Get the tool's schema."""
        return ToolSchema(
            name=self.name,
            description=self.description,
            parameters=self.parameters,
            required=self.required_params
        )
```

---

## 🔌 Core Tool Implementations

### Web Search Tool

```python
import httpx
from typing import List, Dict

class WebSearchTool(BaseTool):
    """Search the web using various providers."""
    
    def __init__(self, api_key: str, provider: str = "serper"):
        super().__init__()
        self.api_key = api_key
        self.provider = provider
        self.endpoints = {
            "serper": "https://google.serper.dev/search",
            "serpapi": "https://serpapi.com/search",
            "tavily": "https://api.tavily.com/search"
        }
    
    @property
    def description(self) -> str:
        return """Search the web for current information.
        Use this when you need up-to-date information that may not be in your training data.
        Returns titles, snippets, and URLs of relevant results."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "The search query"
            },
            "num_results": {
                "type": "integer",
                "description": "Number of results to return (default: 5)",
                "default": 5
            }
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(self, query: str, num_results: int = 5) -> List[Dict]:
        """Execute web search."""
        async with httpx.AsyncClient() as client:
            if self.provider == "serper":
                response = await client.post(
                    self.endpoints["serper"],
                    headers={"X-API-KEY": self.api_key},
                    json={"q": query, "num": num_results}
                )
                data = response.json()
                
                return [
                    {
                        "title": r.get("title"),
                        "snippet": r.get("snippet"),
                        "url": r.get("link")
                    }
                    for r in data.get("organic", [])[:num_results]
                ]
            
            elif self.provider == "tavily":
                response = await client.post(
                    self.endpoints["tavily"],
                    json={
                        "api_key": self.api_key,
                        "query": query,
                        "max_results": num_results
                    }
                )
                data = response.json()
                
                return [
                    {
                        "title": r.get("title"),
                        "snippet": r.get("content"),
                        "url": r.get("url")
                    }
                    for r in data.get("results", [])
                ]
```

### Code Execution Tool

```python
import subprocess
import tempfile
import os
from typing import Dict, Any

class CodeExecutionTool(BaseTool):
    """Execute code in a sandboxed environment."""
    
    def __init__(self, allowed_languages: List[str] = None, timeout: int = 30):
        super().__init__()
        self.allowed_languages = allowed_languages or ["python", "javascript"]
        self.timeout = timeout
    
    @property
    def description(self) -> str:
        return f"""Execute code and return the output.
        Supported languages: {', '.join(self.allowed_languages)}
        Use for calculations, data processing, or testing code.
        Code runs in a sandboxed environment with {self.timeout}s timeout."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "code": {
                "type": "string",
                "description": "The code to execute"
            },
            "language": {
                "type": "string",
                "description": f"Programming language ({', '.join(self.allowed_languages)})",
                "enum": self.allowed_languages
            }
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["code", "language"]
    
    async def execute(self, code: str, language: str) -> Dict[str, str]:
        """Execute code safely."""
        if language not in self.allowed_languages:
            raise ValueError(f"Language {language} not allowed")
        
        # Create temp file
        extensions = {"python": ".py", "javascript": ".js"}
        commands = {"python": ["python"], "javascript": ["node"]}
        
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix=extensions[language],
            delete=False
        ) as f:
            f.write(code)
            temp_path = f.name
        
        try:
            result = subprocess.run(
                commands[language] + [temp_path],
                capture_output=True,
                text=True,
                timeout=self.timeout,
                # Sandbox considerations (simplified)
                env={**os.environ, "PATH": "/usr/bin:/bin"}
            )
            
            return {
                "stdout": result.stdout,
                "stderr": result.stderr,
                "return_code": result.returncode
            }
        
        except subprocess.TimeoutExpired:
            return {
                "stdout": "",
                "stderr": f"Execution timed out after {self.timeout} seconds",
                "return_code": -1
            }
        
        finally:
            os.unlink(temp_path)
```

### Database Query Tool

```python
from typing import List, Dict, Any
import sqlite3
import json

class DatabaseQueryTool(BaseTool):
    """Query databases safely with parameterized queries."""
    
    def __init__(self, connection_string: str, read_only: bool = True):
        super().__init__()
        self.connection_string = connection_string
        self.read_only = read_only
        self.allowed_operations = ["SELECT"] if read_only else ["SELECT", "INSERT", "UPDATE", "DELETE"]
    
    @property
    def description(self) -> str:
        ops = ", ".join(self.allowed_operations)
        return f"""Query the database. Allowed operations: {ops}.
        Use parameterized queries for safety. Returns results as JSON."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "SQL query (use ? for parameters)"
            },
            "params": {
                "type": "array",
                "description": "Query parameters (for ? placeholders)",
                "items": {"type": "string"},
                "default": []
            }
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    async def execute(self, query: str, params: List = None) -> Dict:
        """Execute database query safely."""
        params = params or []
        
        # Validate operation
        operation = query.strip().split()[0].upper()
        if operation not in self.allowed_operations:
            raise PermissionError(f"Operation {operation} not allowed")
        
        # Execute with parameterization
        conn = sqlite3.connect(self.connection_string)
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()
        
        try:
            cursor.execute(query, params)
            
            if operation == "SELECT":
                rows = cursor.fetchall()
                return {
                    "rows": [dict(row) for row in rows],
                    "count": len(rows)
                }
            else:
                conn.commit()
                return {
                    "affected_rows": cursor.rowcount,
                    "success": True
                }
        
        finally:
            conn.close()
```

### File Operations Tool

```python
import os
from pathlib import Path

class FileOperationsTool(BaseTool):
    """Safely read and write files within allowed directories."""
    
    def __init__(self, allowed_paths: List[str], max_file_size: int = 1_000_000):
        super().__init__()
        self.allowed_paths = [Path(p).resolve() for p in allowed_paths]
        self.max_file_size = max_file_size
    
    @property
    def description(self) -> str:
        return """Read, write, or list files in allowed directories.
        Operations: read, write, list, exists, delete.
        File sizes limited for safety."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "operation": {
                "type": "string",
                "description": "Operation to perform",
                "enum": ["read", "write", "list", "exists", "delete"]
            },
            "path": {
                "type": "string",
                "description": "File or directory path"
            },
            "content": {
                "type": "string",
                "description": "Content to write (for write operation)"
            }
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["operation", "path"]
    
    def _validate_path(self, path: str) -> Path:
        """Validate path is within allowed directories."""
        resolved = Path(path).resolve()
        
        for allowed in self.allowed_paths:
            if str(resolved).startswith(str(allowed)):
                return resolved
        
        raise PermissionError(f"Path {path} not in allowed directories")
    
    async def execute(
        self,
        operation: str,
        path: str,
        content: str = None
    ) -> Any:
        """Execute file operation."""
        validated_path = self._validate_path(path)
        
        if operation == "read":
            if validated_path.stat().st_size > self.max_file_size:
                raise ValueError(f"File too large (>{self.max_file_size} bytes)")
            return validated_path.read_text()
        
        elif operation == "write":
            if content is None:
                raise ValueError("Content required for write operation")
            if len(content) > self.max_file_size:
                raise ValueError("Content too large")
            validated_path.write_text(content)
            return {"written": len(content), "path": str(validated_path)}
        
        elif operation == "list":
            if validated_path.is_dir():
                return [str(p.name) for p in validated_path.iterdir()]
            raise ValueError("Path is not a directory")
        
        elif operation == "exists":
            return validated_path.exists()
        
        elif operation == "delete":
            if validated_path.exists():
                validated_path.unlink()
                return {"deleted": True, "path": str(validated_path)}
            return {"deleted": False, "reason": "File not found"}
```

### HTTP Request Tool

```python
import httpx
from typing import Dict, Any, Optional

class HTTPRequestTool(BaseTool):
    """Make HTTP requests to external APIs."""
    
    def __init__(
        self,
        allowed_domains: List[str] = None,
        default_headers: Dict[str, str] = None,
        timeout: int = 30
    ):
        super().__init__()
        self.allowed_domains = allowed_domains  # None = allow all
        self.default_headers = default_headers or {}
        self.timeout = timeout
    
    @property
    def description(self) -> str:
        domains = ", ".join(self.allowed_domains) if self.allowed_domains else "any domain"
        return f"""Make HTTP requests to external APIs.
        Allowed domains: {domains}
        Supports GET, POST, PUT, DELETE methods."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "method": {
                "type": "string",
                "description": "HTTP method",
                "enum": ["GET", "POST", "PUT", "DELETE"]
            },
            "url": {
                "type": "string",
                "description": "Full URL to request"
            },
            "headers": {
                "type": "object",
                "description": "Request headers"
            },
            "body": {
                "type": "object",
                "description": "Request body (for POST/PUT)"
            }
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["method", "url"]
    
    def _validate_domain(self, url: str) -> bool:
        """Check if URL domain is allowed."""
        if not self.allowed_domains:
            return True
        
        from urllib.parse import urlparse
        domain = urlparse(url).netloc
        
        return any(
            domain == allowed or domain.endswith(f".{allowed}")
            for allowed in self.allowed_domains
        )
    
    async def execute(
        self,
        method: str,
        url: str,
        headers: Dict = None,
        body: Dict = None
    ) -> Dict:
        """Execute HTTP request."""
        if not self._validate_domain(url):
            raise PermissionError(f"Domain not allowed: {url}")
        
        headers = {**self.default_headers, **(headers or {})}
        
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.request(
                method=method,
                url=url,
                headers=headers,
                json=body if method in ["POST", "PUT"] else None
            )
            
            # Try to parse JSON response
            try:
                response_body = response.json()
            except:
                response_body = response.text[:5000]  # Limit text size
            
            return {
                "status_code": response.status_code,
                "headers": dict(response.headers),
                "body": response_body
            }
```

---

## 📦 Tool Registry

```python
from typing import Dict, Type, Optional
import importlib

class ToolRegistry:
    """
    Central registry for managing and discovering tools.
    """
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._tools = {}
            cls._instance._categories = {}
        return cls._instance
    
    def register(
        self,
        tool: BaseTool,
        category: str = "general"
    ):
        """Register a tool."""
        self._tools[tool.name] = tool
        
        if category not in self._categories:
            self._categories[category] = []
        self._categories[category].append(tool.name)
        
        print(f"Registered tool: {tool.name} in category: {category}")
    
    def get(self, name: str) -> Optional[BaseTool]:
        """Get a tool by name."""
        return self._tools.get(name)
    
    def get_by_category(self, category: str) -> List[BaseTool]:
        """Get all tools in a category."""
        names = self._categories.get(category, [])
        return [self._tools[name] for name in names]
    
    def list_tools(self) -> Dict[str, List[str]]:
        """List all registered tools by category."""
        return self._categories.copy()
    
    def get_all_schemas(self) -> List[Dict]:
        """Get schemas for all registered tools."""
        return [tool.get_schema().to_openai_function() for tool in self._tools.values()]
    
    def load_from_config(self, config: Dict):
        """Load tools from configuration."""
        for tool_config in config.get("tools", []):
            module_path = tool_config["module"]
            class_name = tool_config["class"]
            kwargs = tool_config.get("kwargs", {})
            category = tool_config.get("category", "general")
            
            # Dynamic import
            module = importlib.import_module(module_path)
            tool_class = getattr(module, class_name)
            tool = tool_class(**kwargs)
            
            self.register(tool, category)


# Example usage
registry = ToolRegistry()

# Register tools
registry.register(WebSearchTool(api_key="..."), "information")
registry.register(CodeExecutionTool(), "computation")
registry.register(DatabaseQueryTool("data.db"), "data")
registry.register(FileOperationsTool(["/app/workspace"]), "filesystem")
registry.register(HTTPRequestTool(allowed_domains=["api.github.com"]), "http")
```

---

## 🔄 Function Calling Integration

### OpenAI Function Calling

```python
from openai import AsyncOpenAI

class OpenAIFunctionCaller:
    """Handle OpenAI function calling."""
    
    def __init__(self, client: AsyncOpenAI, tools: List[BaseTool]):
        self.client = client
        self.tools = {tool.name: tool for tool in tools}
    
    def _get_tool_definitions(self) -> List[Dict]:
        """Get tool definitions in OpenAI format."""
        return [
            tool.get_schema().to_openai_function()
            for tool in self.tools.values()
        ]
    
    async def run(self, messages: List[Dict], model: str = "gpt-4") -> str:
        """Run conversation with function calling."""
        tools = self._get_tool_definitions()
        
        while True:
            response = await self.client.chat.completions.create(
                model=model,
                messages=messages,
                tools=tools,
                tool_choice="auto"
            )
            
            message = response.choices[0].message
            
            # Check if model wants to call tools
            if not message.tool_calls:
                return message.content
            
            # Add assistant message
            messages.append(message)
            
            # Execute tool calls
            for tool_call in message.tool_calls:
                function_name = tool_call.function.name
                arguments = json.loads(tool_call.function.arguments)
                
                # Execute tool
                tool = self.tools.get(function_name)
                if tool:
                    result = await tool(**arguments)
                else:
                    result = {"error": f"Tool {function_name} not found"}
                
                # Add tool result
                messages.append({
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(result)
                })


# Example
async def main():
    client = AsyncOpenAI()
    tools = [
        WebSearchTool(api_key="..."),
        CodeExecutionTool()
    ]
    
    caller = OpenAIFunctionCaller(client, tools)
    
    messages = [
        {"role": "user", "content": "Search for the latest Python 3.12 features and calculate 15! factorial"}
    ]
    
    response = await caller.run(messages)
    print(response)
```

### Anthropic Tool Use

```python
from anthropic import AsyncAnthropic

class AnthropicToolCaller:
    """Handle Anthropic tool use."""
    
    def __init__(self, client: AsyncAnthropic, tools: List[BaseTool]):
        self.client = client
        self.tools = {tool.name: tool for tool in tools}
    
    def _get_tool_definitions(self) -> List[Dict]:
        """Get tool definitions in Anthropic format."""
        return [
            tool.get_schema().to_anthropic_tool()
            for tool in self.tools.values()
        ]
    
    async def run(self, messages: List[Dict], model: str = "claude-3-5-sonnet-20241022") -> str:
        """Run conversation with tool use."""
        tools = self._get_tool_definitions()
        
        while True:
            response = await self.client.messages.create(
                model=model,
                max_tokens=4096,
                tools=tools,
                messages=messages
            )
            
            # Check for tool use
            tool_use_blocks = [
                block for block in response.content
                if block.type == "tool_use"
            ]
            
            if not tool_use_blocks:
                # Return text response
                text_blocks = [
                    block.text for block in response.content
                    if block.type == "text"
                ]
                return "\n".join(text_blocks)
            
            # Add assistant message
            messages.append({
                "role": "assistant",
                "content": response.content
            })
            
            # Execute tools and add results
            tool_results = []
            for tool_block in tool_use_blocks:
                tool = self.tools.get(tool_block.name)
                if tool:
                    result = await tool(**tool_block.input)
                else:
                    result = {"error": f"Tool {tool_block.name} not found"}
                
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": tool_block.id,
                    "content": json.dumps(result)
                })
            
            messages.append({
                "role": "user",
                "content": tool_results
            })
```

---

## 🔒 Security and Sandboxing

```python
from typing import Dict, Any, List
import resource
import signal

class SecureToolExecutor:
    """
    Execute tools with security constraints.
    """
    def __init__(
        self,
        max_memory_mb: int = 512,
        max_cpu_seconds: int = 30,
        allowed_tools: List[str] = None
    ):
        self.max_memory = max_memory_mb * 1024 * 1024
        self.max_cpu = max_cpu_seconds
        self.allowed_tools = set(allowed_tools) if allowed_tools else None
        self.audit_log = []
    
    def _apply_limits(self):
        """Apply resource limits (Unix only)."""
        # Memory limit
        resource.setrlimit(
            resource.RLIMIT_AS,
            (self.max_memory, self.max_memory)
        )
        
        # CPU time limit
        resource.setrlimit(
            resource.RLIMIT_CPU,
            (self.max_cpu, self.max_cpu)
        )
    
    def _log_execution(
        self,
        tool_name: str,
        args: Dict,
        result: Any,
        duration: float
    ):
        """Log tool execution for audit."""
        self.audit_log.append({
            "timestamp": datetime.now().isoformat(),
            "tool": tool_name,
            "args": {k: str(v)[:100] for k, v in args.items()},  # Truncate
            "success": result.get("success", False),
            "duration": duration
        })
    
    async def execute(
        self,
        tool: BaseTool,
        **kwargs
    ) -> Dict:
        """Execute tool with security checks."""
        # Check if tool is allowed
        if self.allowed_tools and tool.name not in self.allowed_tools:
            return {
                "success": False,
                "error": f"Tool {tool.name} not allowed"
            }
        
        # Sanitize inputs
        sanitized = self._sanitize_inputs(kwargs)
        
        # Execute with timeout
        start = time.time()
        try:
            # Apply resource limits in subprocess
            result = await asyncio.wait_for(
                tool(**sanitized),
                timeout=self.max_cpu
            )
        except asyncio.TimeoutError:
            result = {
                "success": False,
                "error": f"Execution timed out after {self.max_cpu}s"
            }
        
        duration = time.time() - start
        
        # Log execution
        self._log_execution(tool.name, sanitized, result, duration)
        
        return result
    
    def _sanitize_inputs(self, inputs: Dict) -> Dict:
        """Sanitize tool inputs."""
        sanitized = {}
        
        for key, value in inputs.items():
            if isinstance(value, str):
                # Remove potential injection attempts
                value = value.replace("\x00", "")  # Null bytes
                # Could add more sanitization
            sanitized[key] = value
        
        return sanitized
    
    def get_audit_log(self) -> List[Dict]:
        """Get execution audit log."""
        return self.audit_log.copy()
```

---

## 🧪 Tool Testing Framework

```python
import pytest
from typing import Dict, Any

class ToolTestCase:
    """Base class for tool testing."""
    
    def __init__(self, tool: BaseTool):
        self.tool = tool
    
    async def test_basic_execution(self, **kwargs) -> bool:
        """Test basic tool execution."""
        result = await self.tool(**kwargs)
        return result.get("success", False)
    
    async def test_error_handling(self) -> Dict[str, bool]:
        """Test error handling scenarios."""
        results = {}
        
        # Test missing required params
        result = await self.tool()
        results["handles_missing_params"] = not result.get("success")
        
        # Test invalid params (if applicable)
        result = await self.tool(invalid_param="test")
        results["handles_invalid_params"] = not result.get("success")
        
        return results
    
    async def test_performance(
        self,
        iterations: int = 10,
        **kwargs
    ) -> Dict[str, float]:
        """Test tool performance."""
        times = []
        
        for _ in range(iterations):
            start = time.time()
            await self.tool(**kwargs)
            times.append(time.time() - start)
        
        return {
            "avg_time": sum(times) / len(times),
            "min_time": min(times),
            "max_time": max(times)
        }


# Example pytest tests
class TestWebSearchTool:
    """Tests for WebSearchTool."""
    
    @pytest.fixture
    def tool(self):
        return WebSearchTool(api_key="test_key")
    
    @pytest.mark.asyncio
    async def test_basic_search(self, tool):
        result = await tool(query="Python programming")
        assert result["success"]
        assert len(result["result"]) > 0
    
    @pytest.mark.asyncio
    async def test_missing_query(self, tool):
        result = await tool()
        assert not result["success"]
        assert "Missing required parameter" in result["error"]
    
    @pytest.mark.asyncio
    async def test_result_format(self, tool):
        result = await tool(query="test")
        if result["success"]:
            for item in result["result"]:
                assert "title" in item
                assert "url" in item
```

---

## 📝 Key Takeaways

1. **Tool Design**: Clear descriptions, typed parameters, good error handling
2. **Security**: Validate inputs, sandbox execution, audit logging
3. **Registry**: Central management for tool discovery and loading
4. **Integration**: Adapt to different LLM provider formats
5. **Testing**: Comprehensive tests for reliability
6. **Documentation**: Tools need clear docs for LLMs to use them well

---

## 🔗 What's Next?

Module 12: **Model Context Protocol (MCP)** - Standard protocol for tool integration

---

## 📚 Resources

### Documentation
- [OpenAI Function Calling](https://platform.openai.com/docs/guides/function-calling)
- [Anthropic Tool Use](https://docs.anthropic.com/claude/docs/tool-use)
- [LangChain Tools](https://python.langchain.com/docs/modules/agents/tools/)

### Libraries
- [LangChain Tools](https://github.com/langchain-ai/langchain)
- [Composio](https://github.com/ComposioHQ/composio)

---

*Module 11 Complete. Continue to Module 12: Model Context Protocol (MCP) →*

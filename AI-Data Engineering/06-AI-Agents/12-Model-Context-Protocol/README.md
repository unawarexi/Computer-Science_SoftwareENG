# 🔌 Module 12: Model Context Protocol (MCP)

## Overview

This module covers the Model Context Protocol (MCP), an open standard developed by Anthropic for connecting AI models to external data sources and tools through a unified interface.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** MCP architecture and concepts
2. **Build** MCP servers that expose tools and resources
3. **Connect** MCP clients to servers
4. **Implement** resources, tools, and prompts
5. **Deploy** MCP servers for production use

---

## 📚 Prerequisites

- Module 11: Agent Tools and Functions
- Understanding of JSON-RPC
- Node.js or Python programming

---

## 🏗️ What is MCP?

```
┌─────────────────────────────────────────────────────────────────┐
│                MODEL CONTEXT PROTOCOL (MCP)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  MCP is a standardized protocol for AI model context management │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                      MCP CLIENT                           │   │
│  │  (Claude Desktop, VS Code, Custom Apps)                  │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│                           │                                      │
│                    JSON-RPC Transport                            │
│              (stdio, HTTP/SSE, WebSocket)                       │
│                           │                                      │
│  ┌────────────────────────┼─────────────────────────────────┐   │
│  │                        ▼                                  │   │
│  │               ┌─────────────┐                            │   │
│  │               │ MCP SERVER  │                            │   │
│  │               └──────┬──────┘                            │   │
│  │                      │                                    │   │
│  │     ┌────────────────┼────────────────┐                  │   │
│  │     ▼                ▼                ▼                  │   │
│  │ ┌────────┐    ┌──────────┐    ┌────────────┐            │   │
│  │ │ TOOLS  │    │RESOURCES │    │  PROMPTS   │            │   │
│  │ │        │    │          │    │            │            │   │
│  │ │Execute │    │Read data │    │Templates   │            │   │
│  │ │actions │    │from files│    │for common  │            │   │
│  │ │        │    │databases │    │tasks       │            │   │
│  │ └────────┘    └──────────┘    └────────────┘            │   │
│  │                                                          │   │
│  │                    DATA SOURCES                          │   │
│  │  [Files] [Databases] [APIs] [Services]                  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Core Concepts

| Concept | Description | Example |
|---------|-------------|---------|
| **Resources** | Read-only data exposed to the model | File contents, database records |
| **Tools** | Functions the model can execute | Search, calculate, API calls |
| **Prompts** | Reusable prompt templates | Code review, summarization |
| **Transport** | Communication layer | stdio, HTTP+SSE |
| **Sampling** | Request model completions | Generate text from server |

---

## 📦 MCP Server Structure

### TypeScript Server

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema
} from '@modelcontextprotocol/sdk/types.js';

// Create server instance
const server = new Server(
  {
    name: "my-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      resources: {},
      tools: {},
      prompts: {}
    },
  }
);

// ============= TOOLS =============
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "calculate",
        description: "Perform mathematical calculations",
        inputSchema: {
          type: "object",
          properties: {
            expression: {
              type: "string",
              description: "Mathematical expression to evaluate"
            }
          },
          required: ["expression"]
        }
      },
      {
        name: "search_files",
        description: "Search for files matching a pattern",
        inputSchema: {
          type: "object",
          properties: {
            pattern: {
              type: "string",
              description: "Glob pattern to match files"
            },
            directory: {
              type: "string",
              description: "Directory to search in"
            }
          },
          required: ["pattern"]
        }
      }
    ]
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "calculate": {
      const expression = args.expression as string;
      try {
        // Safe evaluation (in production, use a proper math parser)
        const result = Function(`"use strict"; return (${expression})`)();
        return {
          content: [
            {
              type: "text",
              text: `Result: ${result}`
            }
          ]
        };
      } catch (error) {
        return {
          content: [
            {
              type: "text",
              text: `Error: ${error.message}`
            }
          ],
          isError: true
        };
      }
    }

    case "search_files": {
      const pattern = args.pattern as string;
      const directory = args.directory as string || ".";
      
      const glob = require("glob");
      const files = glob.sync(pattern, { cwd: directory });
      
      return {
        content: [
          {
            type: "text",
            text: `Found ${files.length} files:\n${files.join('\n')}`
          }
        ]
      };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// ============= RESOURCES =============
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: [
      {
        uri: "file:///config/settings.json",
        name: "Application Settings",
        description: "Main configuration file",
        mimeType: "application/json"
      },
      {
        uri: "db://users/all",
        name: "All Users",
        description: "List of all users in the database",
        mimeType: "application/json"
      }
    ]
  };
});

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  if (uri === "file:///config/settings.json") {
    const fs = require("fs");
    const content = fs.readFileSync("./config/settings.json", "utf-8");
    return {
      contents: [
        {
          uri,
          mimeType: "application/json",
          text: content
        }
      ]
    };
  }

  if (uri === "db://users/all") {
    // Simulate database query
    const users = [
      { id: 1, name: "Alice", email: "alice@example.com" },
      { id: 2, name: "Bob", email: "bob@example.com" }
    ];
    return {
      contents: [
        {
          uri,
          mimeType: "application/json",
          text: JSON.stringify(users, null, 2)
        }
      ]
    };
  }

  throw new Error(`Resource not found: ${uri}`);
});

// ============= PROMPTS =============
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: [
      {
        name: "code_review",
        description: "Review code for quality and issues",
        arguments: [
          {
            name: "code",
            description: "The code to review",
            required: true
          },
          {
            name: "language",
            description: "Programming language",
            required: false
          }
        ]
      },
      {
        name: "summarize",
        description: "Summarize text content",
        arguments: [
          {
            name: "text",
            description: "Text to summarize",
            required: true
          },
          {
            name: "max_length",
            description: "Maximum summary length",
            required: false
          }
        ]
      }
    ]
  };
});

server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "code_review":
      return {
        description: "Code review prompt",
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Please review the following ${args?.language || ""} code for:
1. Code quality and best practices
2. Potential bugs or issues
3. Performance improvements
4. Security concerns

Code:
\`\`\`${args?.language || ""}
${args?.code}
\`\`\`

Provide specific, actionable feedback.`
            }
          }
        ]
      };

    case "summarize":
      return {
        description: "Summarization prompt",
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Summarize the following text${args?.max_length ? ` in ${args.max_length} words or less` : ""}:

${args?.text}

Provide a clear, concise summary capturing the main points.`
            }
          }
        ]
      };

    default:
      throw new Error(`Unknown prompt: ${name}`);
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP server running on stdio");
}

main().catch(console.error);
```

### Python Server

```python
import asyncio
import json
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import (
    Resource,
    Tool,
    TextContent,
    Prompt,
    PromptMessage,
    GetPromptResult
)

# Create server
server = Server("my-mcp-server")

# ============= TOOLS =============
@server.list_tools()
async def list_tools() -> list[Tool]:
    """List available tools."""
    return [
        Tool(
            name="calculate",
            description="Perform mathematical calculations",
            inputSchema={
                "type": "object",
                "properties": {
                    "expression": {
                        "type": "string",
                        "description": "Mathematical expression to evaluate"
                    }
                },
                "required": ["expression"]
            }
        ),
        Tool(
            name="fetch_url",
            description="Fetch content from a URL",
            inputSchema={
                "type": "object",
                "properties": {
                    "url": {
                        "type": "string",
                        "description": "URL to fetch"
                    }
                },
                "required": ["url"]
            }
        ),
        Tool(
            name="execute_python",
            description="Execute Python code safely",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "Python code to execute"
                    }
                },
                "required": ["code"]
            }
        )
    ]


@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Execute a tool."""
    
    if name == "calculate":
        expression = arguments["expression"]
        try:
            # Use safe evaluation
            import ast
            result = eval(compile(ast.parse(expression, mode='eval'), '', 'eval'))
            return [TextContent(type="text", text=f"Result: {result}")]
        except Exception as e:
            return [TextContent(type="text", text=f"Error: {str(e)}")]
    
    elif name == "fetch_url":
        import httpx
        url = arguments["url"]
        try:
            async with httpx.AsyncClient() as client:
                response = await client.get(url, timeout=30)
                return [TextContent(
                    type="text",
                    text=f"Status: {response.status_code}\n\n{response.text[:5000]}"
                )]
        except Exception as e:
            return [TextContent(type="text", text=f"Error fetching URL: {str(e)}")]
    
    elif name == "execute_python":
        code = arguments["code"]
        try:
            # Capture output
            import io
            import sys
            from contextlib import redirect_stdout, redirect_stderr
            
            stdout_capture = io.StringIO()
            stderr_capture = io.StringIO()
            
            with redirect_stdout(stdout_capture), redirect_stderr(stderr_capture):
                exec(code, {"__builtins__": __builtins__})
            
            output = stdout_capture.getvalue()
            errors = stderr_capture.getvalue()
            
            result = f"Output:\n{output}" if output else "No output"
            if errors:
                result += f"\nErrors:\n{errors}"
            
            return [TextContent(type="text", text=result)]
        except Exception as e:
            return [TextContent(type="text", text=f"Execution error: {str(e)}")]
    
    raise ValueError(f"Unknown tool: {name}")


# ============= RESOURCES =============
@server.list_resources()
async def list_resources() -> list[Resource]:
    """List available resources."""
    return [
        Resource(
            uri="file:///workspace/readme.md",
            name="Project README",
            description="Main project documentation",
            mimeType="text/markdown"
        ),
        Resource(
            uri="env://variables",
            name="Environment Variables",
            description="Current environment configuration",
            mimeType="application/json"
        ),
        Resource(
            uri="system://info",
            name="System Information",
            description="Current system status and info",
            mimeType="application/json"
        )
    ]


@server.read_resource()
async def read_resource(uri: str) -> str:
    """Read a resource."""
    import os
    import platform
    
    if uri == "file:///workspace/readme.md":
        try:
            with open("readme.md", "r") as f:
                return f.read()
        except FileNotFoundError:
            return "# Project\n\nNo README found."
    
    elif uri == "env://variables":
        # Return safe subset of env vars
        safe_vars = {
            "PATH": os.environ.get("PATH", ""),
            "HOME": os.environ.get("HOME", ""),
            "USER": os.environ.get("USER", ""),
            "SHELL": os.environ.get("SHELL", "")
        }
        return json.dumps(safe_vars, indent=2)
    
    elif uri == "system://info":
        info = {
            "platform": platform.system(),
            "platform_release": platform.release(),
            "python_version": platform.python_version(),
            "processor": platform.processor()
        }
        return json.dumps(info, indent=2)
    
    raise ValueError(f"Unknown resource: {uri}")


# ============= PROMPTS =============
@server.list_prompts()
async def list_prompts() -> list[Prompt]:
    """List available prompts."""
    return [
        Prompt(
            name="debug_code",
            description="Debug and fix code issues",
            arguments=[
                {"name": "code", "description": "Code with bugs", "required": True},
                {"name": "error", "description": "Error message", "required": False}
            ]
        ),
        Prompt(
            name="explain_concept",
            description="Explain a technical concept",
            arguments=[
                {"name": "concept", "description": "Concept to explain", "required": True},
                {"name": "level", "description": "Expertise level", "required": False}
            ]
        )
    ]


@server.get_prompt()
async def get_prompt(name: str, arguments: dict | None) -> GetPromptResult:
    """Get a prompt template."""
    arguments = arguments or {}
    
    if name == "debug_code":
        code = arguments.get("code", "")
        error = arguments.get("error", "No error message provided")
        
        return GetPromptResult(
            description="Debug code prompt",
            messages=[
                PromptMessage(
                    role="user",
                    content=TextContent(
                        type="text",
                        text=f"""Please help debug this code:

```
{code}
```

Error encountered: {error}

Please:
1. Identify the bug(s)
2. Explain why they occur
3. Provide the corrected code
4. Suggest any improvements"""
                    )
                )
            ]
        )
    
    elif name == "explain_concept":
        concept = arguments.get("concept", "")
        level = arguments.get("level", "intermediate")
        
        return GetPromptResult(
            description="Explain concept prompt",
            messages=[
                PromptMessage(
                    role="user",
                    content=TextContent(
                        type="text",
                        text=f"""Explain the concept of "{concept}" for someone at the {level} level.

Include:
1. A clear definition
2. Why it matters
3. Real-world examples
4. Common misconceptions
5. Resources for learning more"""
                    )
                )
            ]
        )
    
    raise ValueError(f"Unknown prompt: {name}")


# Run server
async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options()
        )


if __name__ == "__main__":
    asyncio.run(main())
```

---

## 🔧 Building Practical MCP Servers

### Database Server

```python
import sqlite3
from mcp.server import Server
from mcp.types import Tool, TextContent, Resource

server = Server("database-mcp")

# Database connection
def get_db():
    conn = sqlite3.connect("app.db")
    conn.row_factory = sqlite3.Row
    return conn

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="query_database",
            description="Execute a read-only SQL query",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "SELECT query to execute"
                    }
                },
                "required": ["query"]
            }
        ),
        Tool(
            name="get_schema",
            description="Get database schema information",
            inputSchema={
                "type": "object",
                "properties": {
                    "table_name": {
                        "type": "string",
                        "description": "Table name (optional, for specific table)"
                    }
                }
            }
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    conn = get_db()
    cursor = conn.cursor()
    
    if name == "query_database":
        query = arguments["query"].strip()
        
        # Security: Only allow SELECT
        if not query.upper().startswith("SELECT"):
            return [TextContent(type="text", text="Error: Only SELECT queries allowed")]
        
        try:
            cursor.execute(query)
            rows = cursor.fetchall()
            
            if not rows:
                return [TextContent(type="text", text="No results found")]
            
            # Format as table
            headers = rows[0].keys()
            result = " | ".join(headers) + "\n"
            result += "-" * len(result) + "\n"
            for row in rows:
                result += " | ".join(str(row[h]) for h in headers) + "\n"
            
            return [TextContent(type="text", text=result)]
        except Exception as e:
            return [TextContent(type="text", text=f"Query error: {str(e)}")]
    
    elif name == "get_schema":
        table_name = arguments.get("table_name")
        
        if table_name:
            cursor.execute(f"PRAGMA table_info({table_name})")
            columns = cursor.fetchall()
            
            result = f"Schema for {table_name}:\n"
            for col in columns:
                result += f"  - {col['name']}: {col['type']}"
                if col['pk']:
                    result += " (PRIMARY KEY)"
                if col['notnull']:
                    result += " NOT NULL"
                result += "\n"
        else:
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
            tables = cursor.fetchall()
            result = "Tables:\n" + "\n".join(f"  - {t['name']}" for t in tables)
        
        return [TextContent(type="text", text=result)]
    
    conn.close()

@server.list_resources()
async def list_resources():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = cursor.fetchall()
    conn.close()
    
    return [
        Resource(
            uri=f"db://table/{t['name']}",
            name=f"Table: {t['name']}",
            description=f"Contents of {t['name']} table",
            mimeType="application/json"
        )
        for t in tables
    ]

@server.read_resource()
async def read_resource(uri: str):
    if uri.startswith("db://table/"):
        table_name = uri.split("/")[-1]
        
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute(f"SELECT * FROM {table_name} LIMIT 100")
        rows = cursor.fetchall()
        conn.close()
        
        return json.dumps([dict(row) for row in rows], indent=2)
    
    raise ValueError(f"Unknown resource: {uri}")
```

### GitHub Integration Server

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { Octokit } from '@octokit/rest';

const server = new Server({
  name: "github-mcp",
  version: "1.0.0"
}, {
  capabilities: { tools: {}, resources: {} }
});

const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "search_repos",
      description: "Search GitHub repositories",
      inputSchema: {
        type: "object",
        properties: {
          query: { type: "string", description: "Search query" },
          language: { type: "string", description: "Filter by language" }
        },
        required: ["query"]
      }
    },
    {
      name: "get_repo_info",
      description: "Get detailed repository information",
      inputSchema: {
        type: "object",
        properties: {
          owner: { type: "string" },
          repo: { type: "string" }
        },
        required: ["owner", "repo"]
      }
    },
    {
      name: "list_issues",
      description: "List repository issues",
      inputSchema: {
        type: "object",
        properties: {
          owner: { type: "string" },
          repo: { type: "string" },
          state: { type: "string", enum: ["open", "closed", "all"] }
        },
        required: ["owner", "repo"]
      }
    },
    {
      name: "create_issue",
      description: "Create a new issue",
      inputSchema: {
        type: "object",
        properties: {
          owner: { type: "string" },
          repo: { type: "string" },
          title: { type: "string" },
          body: { type: "string" }
        },
        required: ["owner", "repo", "title"]
      }
    }
  ]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "search_repos": {
      let q = args.query as string;
      if (args.language) {
        q += ` language:${args.language}`;
      }
      
      const { data } = await octokit.search.repos({ q, per_page: 10 });
      
      const results = data.items.map(repo => ({
        name: repo.full_name,
        description: repo.description,
        stars: repo.stargazers_count,
        url: repo.html_url
      }));
      
      return {
        content: [{
          type: "text",
          text: JSON.stringify(results, null, 2)
        }]
      };
    }

    case "get_repo_info": {
      const { data } = await octokit.repos.get({
        owner: args.owner as string,
        repo: args.repo as string
      });
      
      return {
        content: [{
          type: "text",
          text: `# ${data.full_name}

${data.description || 'No description'}

- ⭐ Stars: ${data.stargazers_count}
- 🍴 Forks: ${data.forks_count}
- 👀 Watchers: ${data.watchers_count}
- 📝 Open Issues: ${data.open_issues_count}
- 📅 Created: ${data.created_at}
- 🔄 Last Updated: ${data.updated_at}
- 📜 License: ${data.license?.name || 'None'}
- 🔗 URL: ${data.html_url}`
        }]
      };
    }

    case "list_issues": {
      const { data } = await octokit.issues.listForRepo({
        owner: args.owner as string,
        repo: args.repo as string,
        state: (args.state as 'open' | 'closed' | 'all') || 'open',
        per_page: 20
      });
      
      const issues = data.map(issue => 
        `- #${issue.number}: ${issue.title} (${issue.state})`
      ).join('\n');
      
      return {
        content: [{
          type: "text",
          text: `Issues for ${args.owner}/${args.repo}:\n\n${issues}`
        }]
      };
    }

    case "create_issue": {
      const { data } = await octokit.issues.create({
        owner: args.owner as string,
        repo: args.repo as string,
        title: args.title as string,
        body: args.body as string
      });
      
      return {
        content: [{
          type: "text",
          text: `Created issue #${data.number}: ${data.html_url}`
        }]
      };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});
```

---

## ⚙️ Client Configuration

### Claude Desktop Configuration

```json
// ~/Library/Application Support/Claude/claude_desktop_config.json
{
  "mcpServers": {
    "database": {
      "command": "python",
      "args": ["/path/to/database_server.py"],
      "env": {
        "DATABASE_PATH": "/path/to/app.db"
      }
    },
    "github": {
      "command": "node",
      "args": ["/path/to/github_server.js"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxx"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/me/projects"
      ]
    }
  }
}
```

### VS Code Configuration

```json
// .vscode/settings.json
{
  "mcp.servers": {
    "my-server": {
      "command": "python",
      "args": ["mcp_server.py"],
      "cwd": "${workspaceFolder}"
    }
  }
}
```

---

## 🔒 Security Best Practices

```python
from typing import List, Set
import os
import re

class SecureMCPServer:
    """
    MCP Server with security controls.
    """
    def __init__(
        self,
        allowed_paths: List[str],
        allowed_domains: List[str],
        rate_limit: int = 100  # requests per minute
    ):
        self.allowed_paths = [os.path.abspath(p) for p in allowed_paths]
        self.allowed_domains = set(allowed_domains)
        self.rate_limit = rate_limit
        self.request_counts = {}
    
    def validate_path(self, path: str) -> bool:
        """Validate path is within allowed directories."""
        abs_path = os.path.abspath(path)
        return any(
            abs_path.startswith(allowed)
            for allowed in self.allowed_paths
        )
    
    def validate_url(self, url: str) -> bool:
        """Validate URL domain is allowed."""
        from urllib.parse import urlparse
        domain = urlparse(url).netloc
        return domain in self.allowed_domains
    
    def sanitize_query(self, query: str) -> str:
        """Sanitize SQL query."""
        # Remove potential SQL injection attempts
        dangerous_patterns = [
            r';\s*DROP',
            r';\s*DELETE',
            r';\s*UPDATE',
            r';\s*INSERT',
            r'--',
            r'/\*.*\*/'
        ]
        
        for pattern in dangerous_patterns:
            if re.search(pattern, query, re.IGNORECASE):
                raise ValueError("Potentially dangerous SQL detected")
        
        return query
    
    def check_rate_limit(self, client_id: str) -> bool:
        """Check if client is within rate limit."""
        import time
        current_minute = int(time.time() / 60)
        
        key = f"{client_id}:{current_minute}"
        self.request_counts[key] = self.request_counts.get(key, 0) + 1
        
        # Clean old entries
        self.request_counts = {
            k: v for k, v in self.request_counts.items()
            if k.endswith(f":{current_minute}")
        }
        
        return self.request_counts[key] <= self.rate_limit
```

---

## 🧪 Testing MCP Servers

```python
import pytest
import asyncio
from mcp.client import Client
from mcp.client.stdio import stdio_client

class TestMCPServer:
    """Test suite for MCP server."""
    
    @pytest.fixture
    async def client(self):
        """Create test client."""
        async with stdio_client(
            command="python",
            args=["mcp_server.py"]
        ) as (read, write):
            client = Client("test-client", "1.0.0")
            await client.connect(read, write)
            yield client
    
    @pytest.mark.asyncio
    async def test_list_tools(self, client):
        """Test listing tools."""
        tools = await client.list_tools()
        assert len(tools) > 0
        assert all(hasattr(t, 'name') for t in tools)
    
    @pytest.mark.asyncio
    async def test_call_tool(self, client):
        """Test calling a tool."""
        result = await client.call_tool(
            "calculate",
            {"expression": "2 + 2"}
        )
        assert "4" in result[0].text
    
    @pytest.mark.asyncio
    async def test_list_resources(self, client):
        """Test listing resources."""
        resources = await client.list_resources()
        assert isinstance(resources, list)
    
    @pytest.mark.asyncio
    async def test_read_resource(self, client):
        """Test reading a resource."""
        resources = await client.list_resources()
        if resources:
            content = await client.read_resource(resources[0].uri)
            assert content is not None
    
    @pytest.mark.asyncio
    async def test_invalid_tool(self, client):
        """Test calling invalid tool."""
        with pytest.raises(Exception):
            await client.call_tool("nonexistent_tool", {})
```

---

## 📊 MCP Ecosystem

```
┌─────────────────────────────────────────────────────────────────┐
│                       MCP ECOSYSTEM                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  OFFICIAL SERVERS                                               │
│  ────────────────                                               │
│  @modelcontextprotocol/server-filesystem  - File operations     │
│  @modelcontextprotocol/server-github      - GitHub API          │
│  @modelcontextprotocol/server-postgres    - PostgreSQL          │
│  @modelcontextprotocol/server-sqlite      - SQLite              │
│  @modelcontextprotocol/server-puppeteer   - Browser automation  │
│  @modelcontextprotocol/server-fetch       - HTTP requests       │
│  @modelcontextprotocol/server-memory      - Knowledge graph     │
│                                                                  │
│  COMMUNITY SERVERS                                              │
│  ─────────────────                                              │
│  mcp-server-kubernetes  - K8s management                        │
│  mcp-server-docker      - Docker operations                     │
│  mcp-server-aws         - AWS services                          │
│  mcp-server-slack       - Slack integration                     │
│  mcp-server-notion      - Notion database                       │
│  mcp-server-linear      - Linear issues                         │
│                                                                  │
│  CLIENTS                                                        │
│  ───────                                                        │
│  Claude Desktop         - Anthropic's desktop app               │
│  VS Code + Continue     - Code editor integration               │
│  Cursor                 - AI-first code editor                  │
│  Custom applications    - Your own MCP clients                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📝 Key Takeaways

1. **MCP Basics**: Resources (data), Tools (actions), Prompts (templates)
2. **Transport**: stdio for local, HTTP+SSE for remote
3. **Security**: Validate inputs, restrict access, rate limit
4. **Implementation**: TypeScript and Python SDKs available
5. **Ecosystem**: Growing collection of official and community servers
6. **Integration**: Works with Claude Desktop, VS Code, custom apps

---

## 🔗 Resources

### Official
- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [MCP GitHub](https://github.com/modelcontextprotocol)
- [MCP SDK (TypeScript)](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP SDK (Python)](https://github.com/modelcontextprotocol/python-sdk)

### Server Directory
- [MCP Servers](https://github.com/modelcontextprotocol/servers)
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)

### Tutorials
- [Building Your First MCP Server](https://modelcontextprotocol.io/quickstart)
- [MCP with Claude Desktop](https://docs.anthropic.com/claude/docs/mcp)

---

*Module 12 Complete. Congratulations on completing the AI Agents curriculum! 🎉*

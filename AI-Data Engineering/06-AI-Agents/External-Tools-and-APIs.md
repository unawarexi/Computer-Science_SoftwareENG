# 🔧 External Tools and APIs for AI Agents

## Overview

This comprehensive reference lists all major tools, APIs, packages, and services used in building AI agents, particularly for Model Context Protocol (MCP) implementations and agent frameworks.

---

## 📚 Table of Contents

1. [Agent Frameworks](#agent-frameworks)
2. [LLM Providers & APIs](#llm-providers--apis)
3. [Vector Databases](#vector-databases)
4. [Search & Web Tools](#search--web-tools)
5. [Code Execution](#code-execution)
6. [Browser Automation](#browser-automation)
7. [Database Tools](#database-tools)
8. [File & Document Tools](#file--document-tools)
9. [Communication Tools](#communication-tools)
10. [MCP Servers](#mcp-servers)
11. [Monitoring & Observability](#monitoring--observability)
12. [Deployment Platforms](#deployment-platforms)

---

## 🤖 Agent Frameworks

### Primary Frameworks

| Framework | Language | Best For | GitHub Stars |
|-----------|----------|----------|--------------|
| **LangChain** | Python/JS | General agents | 75k+ |
| **LangGraph** | Python/JS | Stateful workflows | 5k+ |
| **AutoGen** | Python | Multi-agent chat | 25k+ |
| **CrewAI** | Python | Agent teams | 15k+ |
| **Semantic Kernel** | C#/Python | Enterprise | 18k+ |
| **Haystack** | Python | RAG pipelines | 13k+ |
| **LlamaIndex** | Python | Data agents | 30k+ |

```bash
# Installation
pip install langchain langgraph langchain-openai
pip install autogen-agentchat
pip install crewai crewai-tools
pip install llama-index
pip install semantic-kernel
```

### Specialized Frameworks

| Framework | Specialty | URL |
|-----------|-----------|-----|
| **Phidata** | Production agents | phidata.com |
| **AgentOps** | Agent monitoring | agentops.ai |
| **Instructor** | Structured outputs | github.com/jxnl/instructor |
| **Marvin** | AI functions | askmarvin.ai |
| **Guidance** | Constrained generation | github.com/guidance-ai/guidance |
| **DSPy** | Programmatic prompting | github.com/stanfordnlp/dspy |

---

## 🧠 LLM Providers & APIs

### Commercial APIs

| Provider | Models | Pricing | Best For |
|----------|--------|---------|----------|
| **OpenAI** | GPT-4o, GPT-4, GPT-3.5 | Per token | General purpose |
| **Anthropic** | Claude 3.5, 3 Opus/Sonnet/Haiku | Per token | Long context, safety |
| **Google** | Gemini 1.5 Pro/Flash | Per token | Multimodal, long context |
| **Cohere** | Command R+, Embed | Per token | RAG, enterprise |
| **Mistral** | Large, Medium, Small | Per token | EU compliance |
| **Groq** | LLaMA, Mixtral (fast) | Per token | Speed |
| **Together AI** | Open source models | Per token | Cost-effective |
| **Fireworks AI** | Fine-tuned models | Per token | Performance |
| **Anyscale** | Open source hosting | Per token | Scale |

```python
# OpenAI
from openai import OpenAI
client = OpenAI(api_key="...")

# Anthropic
from anthropic import Anthropic
client = Anthropic(api_key="...")

# Google
import google.generativeai as genai
genai.configure(api_key="...")

# Cohere
import cohere
co = cohere.Client("...")

# Universal via LiteLLM
from litellm import completion
response = completion(model="gpt-4o", messages=[...])
```

### Local LLM Solutions

| Tool | Description | URL |
|------|-------------|-----|
| **Ollama** | Run models locally | ollama.ai |
| **LM Studio** | GUI for local LLMs | lmstudio.ai |
| **vLLM** | Fast inference server | github.com/vllm-project |
| **llama.cpp** | C++ inference | github.com/ggerganov/llama.cpp |
| **LocalAI** | OpenAI-compatible local | localai.io |
| **GPT4All** | Local chatbot | gpt4all.io |
| **Text Generation WebUI** | Feature-rich UI | github.com/oobabooga |

```bash
# Ollama
ollama pull llama3.1
ollama run llama3.1

# vLLM
pip install vllm
python -m vllm.entrypoints.openai.api_server --model meta-llama/Llama-3.1-8B-Instruct
```

---

## 🗄️ Vector Databases

### Managed Services

| Service | Free Tier | Best For | URL |
|---------|-----------|----------|-----|
| **Pinecone** | 1 index | Production | pinecone.io |
| **Weaviate Cloud** | Limited | Hybrid search | weaviate.io |
| **Qdrant Cloud** | 1GB | Performance | qdrant.io |
| **Zilliz Cloud** | Limited | Scale | zilliz.com |
| **Supabase pgvector** | 500MB | PostgreSQL users | supabase.com |
| **MongoDB Atlas** | 512MB | Document + vector | mongodb.com |
| **Astra DB** | 5GB | Cassandra-based | datastax.com |

### Self-Hosted Options

| Database | Language | Best For |
|----------|----------|----------|
| **ChromaDB** | Python | Development |
| **Qdrant** | Rust | Production |
| **Milvus** | Go/C++ | Large scale |
| **Weaviate** | Go | Hybrid search |
| **FAISS** | C++/Python | Research |
| **pgvector** | SQL | PostgreSQL users |
| **LanceDB** | Rust | Embedded |

```python
# ChromaDB
import chromadb
client = chromadb.Client()

# Pinecone
from pinecone import Pinecone
pc = Pinecone(api_key="...")

# Qdrant
from qdrant_client import QdrantClient
client = QdrantClient(":memory:")

# Weaviate
import weaviate
client = weaviate.connect_to_local()
```

---

## 🔍 Search & Web Tools

### Search APIs

| Service | Type | Free Tier | URL |
|---------|------|-----------|-----|
| **Tavily** | AI Search | 1000/mo | tavily.com |
| **SerpAPI** | Google Search | 100/mo | serpapi.com |
| **Serper** | Google Search | 2500/mo | serper.dev |
| **Brave Search** | Privacy search | 2000/mo | brave.com/search/api |
| **Bing Search** | Microsoft | 1000/mo | azure.microsoft.com |
| **DuckDuckGo** | Privacy search | Free | (via scraping) |
| **Exa** | Neural search | Limited | exa.ai |
| **You.com** | AI search | Limited | you.com |

```python
# Tavily
from tavily import TavilyClient
tavily = TavilyClient(api_key="...")
results = tavily.search("AI agents")

# LangChain tools
from langchain_community.tools import DuckDuckGoSearchRun
from langchain_community.tools.tavily_search import TavilySearchResults

search = DuckDuckGoSearchRun()
tavily = TavilySearchResults()
```

### Web Scraping

| Tool | Type | Best For |
|------|------|----------|
| **Firecrawl** | AI scraping | Clean extraction |
| **Jina Reader** | URL to markdown | Simple extraction |
| **Apify** | Scraping platform | Complex sites |
| **ScrapingBee** | API scraping | JavaScript sites |
| **BeautifulSoup** | HTML parsing | Basic scraping |
| **Scrapy** | Framework | Large scale |

```python
# Firecrawl
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key="...")
data = app.scrape_url("https://example.com")

# Jina Reader (free)
import requests
url = "https://r.jina.ai/https://example.com"
response = requests.get(url)
```

---

## 💻 Code Execution

### Sandboxed Environments

| Service | Language Support | Free Tier | URL |
|---------|------------------|-----------|-----|
| **E2B** | Python, JS, etc. | 100 hrs/mo | e2b.dev |
| **Modal** | Python | $30 credit | modal.com |
| **Replit** | Multiple | Limited | replit.com |
| **CodeSandbox** | Web dev | Limited | codesandbox.io |
| **Jupyter** | Python | Self-host | jupyter.org |

```python
# E2B
from e2b_code_interpreter import CodeInterpreter

with CodeInterpreter() as sandbox:
    execution = sandbox.notebook.exec_cell("print('Hello')")
    print(execution.logs.stdout)

# Modal
import modal
app = modal.App()

@app.function()
def run_code(code: str):
    exec(code)
```

### Local Execution

| Tool | Safety Level | Best For |
|------|--------------|----------|
| **Docker** | High | Isolated containers |
| **subprocess** | Low | Simple scripts |
| **RestrictedPython** | Medium | Limited Python |
| **PyPy Sandbox** | Medium | Sandboxed Python |

---

## 🌐 Browser Automation

| Tool | Type | Best For | URL |
|------|------|----------|-----|
| **Playwright** | Automation | Modern apps | playwright.dev |
| **Selenium** | Automation | Legacy support | selenium.dev |
| **Puppeteer** | Chrome/Node | Chrome-specific | pptr.dev |
| **Browser Use** | AI agents | Agent browsing | browseruse.com |
| **AgentQL** | AI scraping | Semantic queries | agentql.com |
| **Browserbase** | Cloud browsers | Scaling | browserbase.com |

```python
# Playwright
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://example.com")
    content = page.content()

# Browser Use (for agents)
from browser_use import Agent
agent = Agent(task="Find the best laptop under $1000")
result = await agent.run()
```

---

## 🗃️ Database Tools

### SQL Databases

| Tool | Type | Best For |
|------|------|----------|
| **SQLAlchemy** | ORM | Python apps |
| **Prisma** | Type-safe ORM | TypeScript |
| **Supabase** | PostgreSQL + API | Rapid development |
| **PlanetScale** | MySQL | Serverless |
| **Neon** | PostgreSQL | Serverless |
| **CockroachDB** | Distributed | Scale |

```python
# SQLAlchemy tool for agents
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import SQLDatabaseToolkit

db = SQLDatabase.from_uri("sqlite:///data.db")
toolkit = SQLDatabaseToolkit(db=db, llm=llm)
```

### NoSQL & Specialized

| Tool | Type | Best For |
|------|------|----------|
| **MongoDB** | Document | Flexible schema |
| **Redis** | Key-value | Caching, sessions |
| **Neo4j** | Graph | Relationships |
| **Elasticsearch** | Search | Full-text search |
| **InfluxDB** | Time series | Metrics |

---

## 📄 File & Document Tools

### Document Loaders

| Tool | Formats | URL |
|------|---------|-----|
| **Unstructured** | PDF, DOCX, HTML | unstructured.io |
| **LlamaParse** | Complex PDFs | llamaindex.ai |
| **PyPDF** | PDF | pypdf.readthedocs.io |
| **python-docx** | DOCX | python-docx.readthedocs.io |
| **Docling** | Scientific docs | ds4sd.github.io/docling |
| **Marker** | PDF to Markdown | github.com/VikParuchuri/marker |

```python
# Unstructured
from unstructured.partition.auto import partition
elements = partition("document.pdf")

# LlamaParse
from llama_parse import LlamaParse
parser = LlamaParse(result_type="markdown")
documents = parser.load_data("document.pdf")

# LangChain loaders
from langchain_community.document_loaders import PyPDFLoader
loader = PyPDFLoader("document.pdf")
pages = loader.load()
```

### File Storage

| Service | Type | Free Tier |
|---------|------|-----------|
| **AWS S3** | Object storage | 5GB |
| **Google Cloud Storage** | Object storage | 5GB |
| **Cloudflare R2** | S3-compatible | 10GB |
| **Supabase Storage** | File storage | 1GB |
| **MinIO** | Self-hosted S3 | Unlimited |

---

## 📧 Communication Tools

### Email

| Service | Type | URL |
|---------|------|-----|
| **SendGrid** | Transactional | sendgrid.com |
| **Resend** | Developer-first | resend.com |
| **Postmark** | Transactional | postmarkapp.com |
| **Mailgun** | API + SMTP | mailgun.com |

### Messaging & Chat

| Service | Type | URL |
|---------|------|-----|
| **Twilio** | SMS, Voice | twilio.com |
| **Slack API** | Workspace chat | api.slack.com |
| **Discord API** | Community chat | discord.com/developers |
| **Telegram Bot** | Messaging | core.telegram.org |

```python
# Slack tool
from langchain_community.tools import SlackAPIFileLoaderTool
from langchain_community.agent_toolkits import SlackToolkit

# Twilio
from twilio.rest import Client
client = Client(account_sid, auth_token)
```

---

## 🔌 MCP Servers (Model Context Protocol)

### Official MCP Servers

| Server | Purpose | URL |
|--------|---------|-----|
| **filesystem** | File operations | @modelcontextprotocol/server-filesystem |
| **github** | GitHub API | @modelcontextprotocol/server-github |
| **google-drive** | Google Drive | @modelcontextprotocol/server-gdrive |
| **postgres** | PostgreSQL | @modelcontextprotocol/server-postgres |
| **slack** | Slack workspace | @modelcontextprotocol/server-slack |
| **memory** | Knowledge graph | @modelcontextprotocol/server-memory |
| **puppeteer** | Browser control | @modelcontextprotocol/server-puppeteer |
| **brave-search** | Web search | @modelcontextprotocol/server-brave-search |
| **fetch** | HTTP requests | @modelcontextprotocol/server-fetch |
| **sqlite** | SQLite database | @modelcontextprotocol/server-sqlite |

### Community MCP Servers

| Server | Purpose | Author |
|--------|---------|--------|
| **mcp-server-firecrawl** | Web scraping | mendableai |
| **mcp-server-youtube** | YouTube data | ZeroDayArcade |
| **mcp-server-notion** | Notion API | v-3 |
| **mcp-server-linear** | Linear issues | ibuildthecloud |
| **mcp-server-aws** | AWS services | aws |
| **mcp-server-docker** | Docker management | ckreiling |
| **mcp-server-git** | Git operations | modelcontextprotocol |
| **mcp-server-raycast** | Raycast commands | raycast |

### MCP Configuration

```json
// Claude Desktop config (~/.config/claude/claude_desktop_config.json)
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/files"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://..."]
    }
  }
}
```

### Building Custom MCP Servers

```python
# Python MCP Server
from mcp.server import Server
from mcp.types import Tool, TextContent

server = Server("my-server")

@server.tool()
async def my_tool(param: str) -> str:
    """Description of my tool."""
    return f"Result: {param}"

# Run server
if __name__ == "__main__":
    server.run()
```

```typescript
// TypeScript MCP Server
import { Server } from "@modelcontextprotocol/sdk/server";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio";

const server = new Server({
  name: "my-server",
  version: "1.0.0"
});

server.setRequestHandler("tools/list", async () => ({
  tools: [{
    name: "my_tool",
    description: "My custom tool",
    inputSchema: {
      type: "object",
      properties: { param: { type: "string" } }
    }
  }]
}));

const transport = new StdioServerTransport();
server.connect(transport);
```

---

## 📊 Monitoring & Observability

### Agent Monitoring

| Tool | Type | URL |
|------|------|-----|
| **LangSmith** | LangChain monitoring | smith.langchain.com |
| **AgentOps** | Agent analytics | agentops.ai |
| **Arize Phoenix** | LLM observability | arize.com |
| **Weights & Biases** | ML tracking | wandb.ai |
| **Helicone** | LLM gateway | helicone.ai |
| **Portkey** | AI gateway | portkey.ai |
| **Braintrust** | Evals & logging | braintrustdata.com |

```python
# LangSmith
import os
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = "..."

# AgentOps
import agentops
agentops.init(api_key="...")

# Helicone
from openai import OpenAI
client = OpenAI(
    base_url="https://oai.helicone.ai/v1",
    default_headers={"Helicone-Auth": f"Bearer {key}"}
)
```

### General Observability

| Tool | Type | URL |
|------|------|-----|
| **Datadog** | Full stack | datadog.com |
| **Grafana** | Dashboards | grafana.com |
| **Prometheus** | Metrics | prometheus.io |
| **Sentry** | Error tracking | sentry.io |
| **OpenTelemetry** | Tracing standard | opentelemetry.io |

---

## 🚀 Deployment Platforms

### Serverless & Functions

| Platform | Best For | URL |
|----------|----------|-----|
| **Vercel** | Web apps | vercel.com |
| **AWS Lambda** | Functions | aws.amazon.com |
| **Google Cloud Functions** | Functions | cloud.google.com |
| **Cloudflare Workers** | Edge functions | cloudflare.com |
| **Railway** | Full stack | railway.app |
| **Render** | Web services | render.com |
| **Fly.io** | Global apps | fly.io |

### Container & Kubernetes

| Platform | Type | URL |
|----------|------|-----|
| **AWS ECS/EKS** | Container | aws.amazon.com |
| **Google Cloud Run** | Serverless containers | cloud.google.com |
| **Azure Container Apps** | Containers | azure.microsoft.com |
| **DigitalOcean App Platform** | PaaS | digitalocean.com |

### AI-Specific Platforms

| Platform | Best For | URL |
|----------|----------|-----|
| **Modal** | Python functions | modal.com |
| **Replicate** | Model hosting | replicate.com |
| **Hugging Face Spaces** | Demo apps | huggingface.co |
| **Baseten** | Model serving | baseten.co |
| **BentoML** | Model packaging | bentoml.com |

---

## 📦 Essential Python Packages

### Core Packages

```bash
# LLM & Agents
pip install openai anthropic langchain langgraph autogen-agentchat crewai

# Vector & Search
pip install chromadb pinecone-client qdrant-client faiss-cpu

# Document Processing
pip install unstructured pypdf python-docx

# Web & Browser
pip install playwright selenium beautifulsoup4 httpx

# Data & Utils
pip install pandas numpy pydantic python-dotenv rich
```

### Complete requirements.txt

```txt
# LLM Providers
openai>=1.0.0
anthropic>=0.18.0
google-generativeai>=0.4.0
cohere>=5.0.0

# Agent Frameworks
langchain>=0.1.0
langgraph>=0.0.20
langchain-openai>=0.0.5
langchain-anthropic>=0.1.0
autogen-agentchat>=0.2.0
crewai>=0.28.0
llama-index>=0.10.0

# Vector Databases
chromadb>=0.4.0
pinecone-client>=3.0.0
qdrant-client>=1.7.0
faiss-cpu>=1.7.4

# Document Processing
unstructured>=0.12.0
pypdf>=4.0.0
python-docx>=1.0.0
llama-parse>=0.3.0

# Web & Search
tavily-python>=0.3.0
duckduckgo-search>=4.0.0
playwright>=1.40.0
beautifulsoup4>=4.12.0
httpx>=0.26.0
firecrawl-py>=0.0.8

# Code Execution
e2b-code-interpreter>=0.0.7

# Utils
pydantic>=2.0.0
python-dotenv>=1.0.0
rich>=13.0.0
tiktoken>=0.5.0

# Monitoring
langsmith>=0.1.0
```

---

## 🔗 Quick Reference Card

### Most Used Tools by Category

```
SEARCH:          Tavily, DuckDuckGo, Brave
VECTORS:         ChromaDB (dev), Pinecone (prod)
DOCUMENTS:       Unstructured, LlamaParse
BROWSER:         Playwright, Browser Use
CODE EXEC:       E2B, Modal
MONITORING:      LangSmith, AgentOps
DEPLOYMENT:      Vercel, Railway, Modal
```

### Starting Stack Recommendation

```
Framework:       LangChain + LangGraph
LLM:            GPT-4o or Claude 3.5 Sonnet
Vector DB:      ChromaDB → Pinecone
Search:         Tavily
Browser:        Playwright
Monitoring:     LangSmith
Deploy:         Railway or Modal
```

---

*This list is continuously updated. Last update: January 2025*

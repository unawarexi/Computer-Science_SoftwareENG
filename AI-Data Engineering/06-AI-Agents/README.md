# 🤖 AI Agents - Complete Learning Module

## Overview

Welcome to the **AI Agents** module! This comprehensive curriculum will take you from understanding basic agent concepts to building sophisticated, autonomous AI systems.

AI Agents are intelligent systems that can **perceive, reason, plan, and act** autonomously to achieve goals.

---

## 🎯 Learning Objectives

By completing this module, you will:

- ✅ Understand what makes an AI agent different from a simple chatbot
- ✅ Master agent architectures (ReAct, CoT, Plan-and-Execute)
- ✅ Build agents with memory, planning, and tool use
- ✅ Implement multi-agent systems
- ✅ Deploy production-ready AI agents
- ✅ Work with frameworks like LangChain, AutoGen, and CrewAI

---

## 📚 Module Structure

| # | Topic | Duration | Description |
|---|-------|----------|-------------|
| 01 | [Introduction to Agentic AI](./01-Introduction-to-Agentic-AI) | 1 week | Agent fundamentals |
| 02 | [AI/ML Fundamentals for Agents](./02-AI-ML-Fundamentals-for-Agents) | 1 week | ML concepts for agents |
| 03 | [AI Agent Frameworks](./03-AI-Agent-Frameworks) | 2 weeks | LangChain, AutoGen, CrewAI |
| 04 | [Large Language Models](./04-Large-Language-Models) | 2 weeks | LLMs powering agents |
| 05 | [Understanding AI Agents](./05-Understanding-AI-Agents) | 2 weeks | Deep dive into agent types |
| 06 | [Memory & Knowledge Retrieval](./06-Memory-and-Knowledge-Retrieval) | 2 weeks | Agent memory systems |
| 07 | [Decision Making & Planning](./07-Decision-Making-and-Planning) | 2 weeks | Agent reasoning |
| 08 | [Prompt Engineering & Adaptation](./08-Prompt-Engineering-and-Adaptation) | 1 week | Optimizing agent prompts |
| 09 | [Reinforcement Learning for Agents](./09-Reinforcement-Learning-for-Agents) | 2 weeks | Learning from feedback |
| 10 | [RAG for Agents](./10-RAG-Retrieval-Augmented-Generation) | 2 weeks | Knowledge-augmented agents |
| 11 | [Deploying AI Agents](./11-Deploying-AI-Agents) | 2 weeks | Production deployment |
| 12 | [Model Context Protocol](./12-Model-Context-Protocol) | 1 week | MCP for agent tools |

---

## 🗺️ Learning Path

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        AI AGENTS LEARNING PATH                          │
└─────────────────────────────────────────────────────────────────────────┘

    FOUNDATIONS (Weeks 1-4)
    ───────────────────────
    
    ┌─────────────────┐     ┌─────────────────┐
    │ 01. Introduction│────▶│ 02. ML          │
    │ to Agentic AI   │     │ Fundamentals    │
    └─────────────────┘     └─────────────────┘
            │                       │
            └───────────┬───────────┘
                        ▼
    ┌─────────────────────────────────────────┐
    │      03. AI Agent Frameworks            │
    │      (LangChain, AutoGen, CrewAI)       │
    └─────────────────────────────────────────┘
                        │
    
    CORE CONCEPTS (Weeks 5-10)
    ──────────────────────────
                        │
                        ▼
    ┌─────────────────┐     ┌─────────────────┐
    │ 04. Large       │────▶│ 05. Understanding│
    │ Language Models │     │ AI Agents        │
    └─────────────────┘     └─────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            ▼                       ▼                       ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │ 06. Memory &    │     │ 07. Decision    │     │ 08. Prompt      │
    │ Knowledge       │     │ Making          │     │ Engineering     │
    └─────────────────┘     └─────────────────┘     └─────────────────┘
    
    
    ADVANCED (Weeks 11-16)
    ──────────────────────
            │                       │                       │
            └───────────────────────┼───────────────────────┘
                                    ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │ 09. RL for      │────▶│ 10. RAG for     │────▶│ 11. Deploying   │
    │ Agents          │     │ Agents          │     │ AI Agents       │
    └─────────────────┘     └─────────────────┘     └─────────────────┘
                                                            │
                                                            ▼
                                                    ┌─────────────────┐
                                                    │ 12. Model       │
                                                    │ Context Protocol│
                                                    └─────────────────┘
```

---

## 🤔 What is an AI Agent?

### Simple Chatbot vs AI Agent

```
┌─────────────────────────────────────────────────────────────────┐
│                    CHATBOT vs AI AGENT                           │
└─────────────────────────────────────────────────────────────────┘

    SIMPLE CHATBOT                      AI AGENT
    ──────────────                      ────────
    
    User: "What's 2+2?"                User: "Book me a flight
    Bot: "4"                                  to Paris"
    
    [Single turn]                       [Multi-step process]
    [No memory]                         
    [No tools]                          ┌─────────────────┐
    [Stateless]                         │ 1. Understand   │
                                        │    request      │
                                        └────────┬────────┘
                                                 ▼
                                        ┌─────────────────┐
                                        │ 2. Search for   │
                                        │    flights      │
                                        └────────┬────────┘
                                                 ▼
                                        ┌─────────────────┐
                                        │ 3. Compare      │
                                        │    options      │
                                        └────────┬────────┘
                                                 ▼
                                        ┌─────────────────┐
                                        │ 4. Book best    │
                                        │    option       │
                                        └────────┬────────┘
                                                 ▼
                                        ┌─────────────────┐
                                        │ 5. Confirm to   │
                                        │    user         │
                                        └─────────────────┘
```

### Agent Capabilities

| Capability | Description |
|------------|-------------|
| **Perception** | Process inputs (text, images, audio) |
| **Reasoning** | Think through problems logically |
| **Planning** | Break down goals into subtasks |
| **Memory** | Remember context and past interactions |
| **Tool Use** | Execute code, call APIs, search web |
| **Learning** | Improve from feedback |
| **Autonomy** | Act independently toward goals |

---

## 🛠️ Core Technologies

### Frameworks We'll Use

| Framework | Best For | Key Features |
|-----------|----------|--------------|
| **LangChain** | General agents | Extensive tools, chains |
| **LangGraph** | Complex workflows | State machines, cycles |
| **AutoGen** | Multi-agent chat | Conversation patterns |
| **CrewAI** | Team of agents | Role-based collaboration |
| **Semantic Kernel** | Enterprise | Microsoft ecosystem |
| **Haystack** | RAG agents | Pipeline-based |

### Supporting Tools

| Tool | Purpose |
|------|---------|
| **ChromaDB/Pinecone** | Vector storage for memory |
| **Redis** | Session/cache storage |
| **Tavily/SerpAPI** | Web search |
| **Playwright/Selenium** | Browser automation |
| **E2B/Modal** | Code execution |

---

## 🚀 Quick Start Example

Here's a simple agent to get you started:

```python
from langchain.agents import create_react_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.tools import DuckDuckGoSearchRun, tool
from langchain import hub

# Initialize LLM
llm = ChatOpenAI(model="gpt-4o", temperature=0)

# Define tools
search = DuckDuckGoSearchRun()

@tool
def calculator(expression: str) -> str:
    """Evaluate a mathematical expression."""
    return str(eval(expression))

tools = [search, calculator]

# Get prompt template
prompt = hub.pull("hwchase17/react")

# Create agent
agent = create_react_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Run agent
result = agent_executor.invoke({
    "input": "What is the population of France? Multiply it by 2."
})
print(result["output"])
```

---

## 📖 Prerequisites

Before starting this module, ensure you have:

1. **Completed Previous Modules**:
   - [04-AI-Core-Concepts](../04-AI-Core-Concepts) - Embeddings, RAG
   - [03-Deep-Learning](../03-Deep-Learning) - Neural networks

2. **Technical Skills**:
   - Python programming (intermediate)
   - API usage (REST, async)
   - Basic understanding of LLMs

3. **Tools Setup**:
   - Python 3.9+
   - OpenAI/Anthropic API keys
   - Vector database (ChromaDB recommended)

---

## 📚 Additional Resources

### Documentation
- [LangChain Docs](https://python.langchain.com/docs/)
- [AutoGen Docs](https://microsoft.github.io/autogen/)
- [CrewAI Docs](https://docs.crewai.com/)

### Research Papers
- "ReAct: Synergizing Reasoning and Acting"
- "Toolformer: Language Models Can Teach Themselves to Use Tools"
- "Generative Agents: Interactive Simulacra of Human Behavior"

### Communities
- LangChain Discord
- AI Agents subreddit
- Hugging Face Forums

---

## 🎯 Projects You'll Build

| Project | Skills Applied |
|---------|----------------|
| Research Assistant | RAG, memory, web search |
| Code Assistant | Tool use, code execution |
| Customer Support Bot | Multi-turn, memory, tools |
| Data Analyst Agent | SQL tools, visualization |
| Multi-Agent Debate | Multi-agent collaboration |

---

## 📂 Related Files

- [Agentic-Model-Types.md](./Agentic-Model-Types.md) - Agent architectures reference
- [External-Tools-and-APIs.md](./External-Tools-and-APIs.md) - Tools for building agents

---

**Let's build intelligent agents! 🚀**

# 🛠️ Module 03: AI Agent Frameworks

## Overview

This module covers the major frameworks for building AI agents. You'll learn hands-on implementation with LangChain, LangGraph, AutoGen, CrewAI, and other popular tools.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** the landscape of agent frameworks
2. **Build** agents with LangChain and LangGraph
3. **Create** multi-agent systems with AutoGen and CrewAI
4. **Compare** frameworks for different use cases
5. **Choose** the right framework for your projects

---

## 📚 Prerequisites

- Module 01: Introduction to Agentic AI
- Module 02: AI/ML Fundamentals for Agents
- Python programming experience
- Familiarity with async/await patterns

---

## 🗺️ Framework Landscape

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT FRAMEWORK LANDSCAPE                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ORCHESTRATION FRAMEWORKS                                        │
│  ────────────────────────                                        │
│  • LangChain      - Most popular, batteries-included             │
│  • LangGraph      - State machines, complex workflows            │
│  • LlamaIndex     - Data-centric, RAG-focused                   │
│  • Semantic Kernel - Microsoft, enterprise-focused               │
│                                                                  │
│  MULTI-AGENT FRAMEWORKS                                          │
│  ──────────────────────                                          │
│  • AutoGen        - Microsoft, conversational agents             │
│  • CrewAI         - Role-based agent teams                       │
│  • Camel          - Role-playing agents                          │
│  • MetaGPT        - Software company simulation                  │
│                                                                  │
│  SPECIALIZED FRAMEWORKS                                          │
│  ─────────────────────                                           │
│  • Haystack       - Production NLP pipelines                     │
│  • DSPy           - Programmatic prompting                       │
│  • Instructor     - Structured outputs                           │
│  • Guidance       - Constrained generation                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🦜 LangChain

### Introduction

LangChain is the most popular framework for building LLM applications. It provides modular components for chains, agents, memory, and tools.

### Installation

```bash
pip install langchain langchain-openai langchain-community
```

### Core Concepts

```python
# 1. Models - LLM interfaces
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o", temperature=0)
response = llm.invoke("Hello, how are you?")
print(response.content)

# 2. Prompts - Template management
from langchain_core.prompts import ChatPromptTemplate

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant specialized in {topic}."),
    ("user", "{question}")
])

# 3. Chains - Composable pipelines
chain = prompt | llm
response = chain.invoke({"topic": "Python", "question": "What is a decorator?"})

# 4. Output Parsers - Structured outputs
from langchain_core.output_parsers import StrOutputParser, JsonOutputParser

chain_with_parser = prompt | llm | StrOutputParser()
```

### Building a Simple Agent

```python
from langchain_openai import ChatOpenAI
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.tools import tool

# Define tools
@tool
def search_web(query: str) -> str:
    """Search the web for information."""
    # In real implementation, use Tavily, SerpAPI, etc.
    return f"Search results for: {query}"

@tool
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression."""
    try:
        result = eval(expression)
        return f"Result: {result}"
    except:
        return "Error: Invalid expression"

@tool
def get_weather(city: str) -> str:
    """Get current weather for a city."""
    return f"Weather in {city}: 22°C, Partly Cloudy"

# Create agent
llm = ChatOpenAI(model="gpt-4o", temperature=0)
tools = [search_web, calculate, get_weather]

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant with access to tools."),
    ("placeholder", "{chat_history}"),
    ("user", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

agent = create_tool_calling_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Run agent
result = agent_executor.invoke({
    "input": "What's the weather in Tokyo and what is 25 * 4?",
    "chat_history": []
})
print(result["output"])
```

### LangChain Expression Language (LCEL)

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough, RunnableLambda

llm = ChatOpenAI(model="gpt-4o")

# Chaining with | operator
chain = (
    {"topic": RunnablePassthrough()}
    | ChatPromptTemplate.from_template("Tell me a joke about {topic}")
    | llm
    | StrOutputParser()
)

result = chain.invoke("programming")

# Parallel execution with RunnableParallel
from langchain_core.runnables import RunnableParallel

parallel_chain = RunnableParallel(
    joke=ChatPromptTemplate.from_template("Tell a joke about {topic}") | llm,
    fact=ChatPromptTemplate.from_template("Tell a fact about {topic}") | llm
)

results = parallel_chain.invoke({"topic": "cats"})
```

---

## 🔄 LangGraph

### Introduction

LangGraph extends LangChain for building stateful, multi-step agent workflows using a graph-based approach.

### Installation

```bash
pip install langgraph
```

### Core Concepts

```
┌─────────────────────────────────────────────────────────────────┐
│                    LANGGRAPH CONCEPTS                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STATE           │  NODES           │  EDGES                    │
│  ─────           │  ─────           │  ─────                    │
│  • TypedDict     │  • Functions     │  • Conditional            │
│  • Shared data   │  • Transform     │  • Direct                 │
│  • Accumulates   │    state         │  • Entry/End              │
│                                                                  │
│                    ┌─────────┐                                   │
│                    │  START  │                                   │
│                    └────┬────┘                                   │
│                         │                                        │
│                    ┌────▼────┐                                   │
│                    │  Node A │                                   │
│                    └────┬────┘                                   │
│                         │                                        │
│              ┌──────────┼──────────┐                            │
│              │          │          │                            │
│         ┌────▼────┐ ┌───▼───┐ ┌───▼────┐                       │
│         │ Node B  │ │ Node C│ │ Node D │                       │
│         └────┬────┘ └───┬───┘ └───┬────┘                       │
│              │          │          │                            │
│              └──────────┼──────────┘                            │
│                         │                                        │
│                    ┌────▼────┐                                   │
│                    │   END   │                                   │
│                    └─────────┘                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Building a ReAct Agent

```python
from typing import TypedDict, Annotated, Sequence
from langchain_openai import ChatOpenAI
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_core.tools import tool
from langgraph.graph import StateGraph, END
from langgraph.prebuilt import ToolNode
import operator

# Define State
class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]

# Define Tools
@tool
def search(query: str) -> str:
    """Search for information."""
    return f"Results for '{query}': AI agents are autonomous systems..."

@tool
def calculator(expression: str) -> str:
    """Calculate mathematical expressions."""
    return str(eval(expression))

tools = [search, calculator]

# Initialize LLM with tools
llm = ChatOpenAI(model="gpt-4o", temperature=0)
llm_with_tools = llm.bind_tools(tools)

# Define Nodes
def agent_node(state: AgentState):
    """The main agent reasoning node."""
    response = llm_with_tools.invoke(state["messages"])
    return {"messages": [response]}

def should_continue(state: AgentState):
    """Determine if we should continue or end."""
    last_message = state["messages"][-1]
    if last_message.tool_calls:
        return "tools"
    return "end"

# Build Graph
workflow = StateGraph(AgentState)

# Add nodes
workflow.add_node("agent", agent_node)
workflow.add_node("tools", ToolNode(tools))

# Add edges
workflow.set_entry_point("agent")
workflow.add_conditional_edges(
    "agent",
    should_continue,
    {"tools": "tools", "end": END}
)
workflow.add_edge("tools", "agent")

# Compile
app = workflow.compile()

# Run
result = app.invoke({
    "messages": [HumanMessage(content="Search for AI agents and calculate 25 * 4")]
})

for message in result["messages"]:
    print(f"{message.type}: {message.content}")
```

### Advanced: Plan-Execute Pattern

```python
from typing import TypedDict, List, Tuple
from langgraph.graph import StateGraph, END

class PlanExecuteState(TypedDict):
    input: str
    plan: List[str]
    past_steps: List[Tuple[str, str]]
    response: str

def planner(state: PlanExecuteState):
    """Create a plan for the task."""
    prompt = f"""Create a step-by-step plan for: {state['input']}
    Return a numbered list of steps."""
    
    response = llm.invoke(prompt)
    # Parse response into list
    steps = [line.strip() for line in response.content.split('\n') if line.strip()]
    return {"plan": steps}

def executor(state: PlanExecuteState):
    """Execute the current step."""
    current_step = state["plan"][len(state["past_steps"])]
    
    prompt = f"""Execute this step: {current_step}
    Previous steps: {state['past_steps']}"""
    
    response = llm.invoke(prompt)
    return {"past_steps": [(current_step, response.content)]}

def should_continue_planning(state: PlanExecuteState):
    """Check if all steps are completed."""
    if len(state["past_steps"]) >= len(state["plan"]):
        return "finish"
    return "execute"

def finisher(state: PlanExecuteState):
    """Compile final response."""
    summary = "\n".join([f"{step}: {result}" for step, result in state["past_steps"]])
    return {"response": summary}

# Build graph
workflow = StateGraph(PlanExecuteState)
workflow.add_node("planner", planner)
workflow.add_node("executor", executor)
workflow.add_node("finisher", finisher)

workflow.set_entry_point("planner")
workflow.add_edge("planner", "executor")
workflow.add_conditional_edges("executor", should_continue_planning, 
                               {"execute": "executor", "finish": "finisher"})
workflow.add_edge("finisher", END)

app = workflow.compile()
```

---

## 🤝 AutoGen

### Introduction

AutoGen (by Microsoft) enables building multi-agent conversational systems where agents can discuss, debate, and collaborate.

### Installation

```bash
pip install autogen-agentchat~=0.2
```

### Basic Multi-Agent Chat

```python
from autogen import ConversableAgent, UserProxyAgent

# Configuration
config_list = [{"model": "gpt-4o", "api_key": "your-key"}]

# Create agents
assistant = ConversableAgent(
    name="Assistant",
    system_message="You are a helpful AI assistant.",
    llm_config={"config_list": config_list}
)

user_proxy = UserProxyAgent(
    name="User",
    human_input_mode="NEVER",  # No human input
    max_consecutive_auto_reply=3
)

# Start conversation
user_proxy.initiate_chat(
    assistant,
    message="Write a Python function to calculate factorial"
)
```

### Agent Team with Code Execution

```python
from autogen import AssistantAgent, UserProxyAgent, GroupChat, GroupChatManager

config_list = [{"model": "gpt-4o", "api_key": "your-key"}]

# Create specialized agents
coder = AssistantAgent(
    name="Coder",
    system_message="""You are an expert Python programmer. 
    Write clean, efficient code with proper error handling.""",
    llm_config={"config_list": config_list}
)

reviewer = AssistantAgent(
    name="Reviewer",
    system_message="""You are a code reviewer.
    Review code for bugs, security issues, and best practices.
    Suggest improvements.""",
    llm_config={"config_list": config_list}
)

tester = AssistantAgent(
    name="Tester",
    system_message="""You are a QA engineer.
    Write comprehensive test cases for the code.
    Identify edge cases and potential failures.""",
    llm_config={"config_list": config_list}
)

# User proxy can execute code
user_proxy = UserProxyAgent(
    name="User",
    human_input_mode="NEVER",
    code_execution_config={
        "work_dir": "workspace",
        "use_docker": False
    },
    max_consecutive_auto_reply=5
)

# Group chat
group_chat = GroupChat(
    agents=[user_proxy, coder, reviewer, tester],
    messages=[],
    max_round=10
)

manager = GroupChatManager(
    groupchat=group_chat,
    llm_config={"config_list": config_list}
)

# Start the conversation
user_proxy.initiate_chat(
    manager,
    message="Create a Python module for managing a todo list with CRUD operations"
)
```

### Custom Agent Behaviors

```python
from autogen import ConversableAgent

class ResearchAgent(ConversableAgent):
    """Custom agent that can search and analyze information."""
    
    def __init__(self, name, search_tool, **kwargs):
        super().__init__(name=name, **kwargs)
        self.search_tool = search_tool
        
        # Register reply function
        self.register_reply([ConversableAgent, None], self.research_reply)
    
    def research_reply(self, recipient, messages, sender, config):
        """Custom reply that includes research."""
        last_message = messages[-1]["content"]
        
        # Check if research is needed
        if "research" in last_message.lower() or "find" in last_message.lower():
            search_results = self.search_tool(last_message)
            context = f"Based on my research: {search_results}\n\n"
        else:
            context = ""
        
        # Generate response with context
        response = self.generate_oai_reply(messages)
        return True, context + response
```

---

## 🚀 CrewAI

### Introduction

CrewAI focuses on role-based agent teams, where each agent has a specific role, goal, and backstory.

### Installation

```bash
pip install crewai crewai-tools
```

### Basic Crew

```python
from crewai import Agent, Task, Crew, Process
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o", temperature=0.7)

# Define Agents
researcher = Agent(
    role="Research Analyst",
    goal="Conduct thorough research on given topics",
    backstory="""You are an experienced research analyst with expertise
    in finding and synthesizing information from various sources.
    You're known for your attention to detail and accuracy.""",
    llm=llm,
    verbose=True
)

writer = Agent(
    role="Content Writer",
    goal="Create engaging, well-structured content",
    backstory="""You are a skilled content writer who can transform
    complex research into clear, engaging articles.
    You have a talent for making technical topics accessible.""",
    llm=llm,
    verbose=True
)

editor = Agent(
    role="Editor",
    goal="Ensure content quality and accuracy",
    backstory="""You are a meticulous editor with years of experience.
    You focus on clarity, accuracy, and reader engagement.
    You always improve content while maintaining the author's voice.""",
    llm=llm,
    verbose=True
)

# Define Tasks
research_task = Task(
    description="Research the latest developments in AI agents",
    expected_output="A comprehensive research report with key findings",
    agent=researcher
)

writing_task = Task(
    description="Write an article based on the research findings",
    expected_output="A well-structured 1000-word article",
    agent=writer,
    context=[research_task]  # Depends on research
)

editing_task = Task(
    description="Edit and polish the article",
    expected_output="A publication-ready article",
    agent=editor,
    context=[writing_task]
)

# Create Crew
crew = Crew(
    agents=[researcher, writer, editor],
    tasks=[research_task, writing_task, editing_task],
    process=Process.sequential,
    verbose=True
)

# Run
result = crew.kickoff()
print(result)
```

### Crew with Tools

```python
from crewai import Agent, Task, Crew
from crewai_tools import SerperDevTool, WebsiteSearchTool

# Initialize tools
search_tool = SerperDevTool()
web_scraper = WebsiteSearchTool()

# Agent with tools
researcher = Agent(
    role="Market Researcher",
    goal="Analyze market trends and competitor landscape",
    backstory="Expert market analyst with 10 years experience",
    tools=[search_tool, web_scraper],
    llm=llm,
    verbose=True
)

analyst = Agent(
    role="Data Analyst",
    goal="Process and analyze market data",
    backstory="Senior data analyst specializing in market intelligence",
    llm=llm,
    verbose=True
)

# Tasks
market_research = Task(
    description="""Research the AI agent market:
    1. Market size and growth rate
    2. Key players and their offerings
    3. Emerging trends
    4. Customer pain points""",
    expected_output="Detailed market research report",
    agent=researcher
)

analysis_task = Task(
    description="Analyze the research and provide strategic insights",
    expected_output="Strategic analysis with recommendations",
    agent=analyst,
    context=[market_research]
)

# Hierarchical process with manager
crew = Crew(
    agents=[researcher, analyst],
    tasks=[market_research, analysis_task],
    process=Process.hierarchical,
    manager_llm=llm,
    verbose=True
)
```

### Custom Tools in CrewAI

```python
from crewai_tools import BaseTool
from pydantic import Field

class CustomSearchTool(BaseTool):
    name: str = "Custom Search"
    description: str = "Search for specific information"
    
    def _run(self, query: str) -> str:
        # Implement search logic
        return f"Search results for: {query}"

class DatabaseQueryTool(BaseTool):
    name: str = "Database Query"
    description: str = "Query the company database"
    connection_string: str = Field(default="")
    
    def _run(self, query: str) -> str:
        # Implement database query
        return f"Query results: {query}"
```

---

## 🦙 LlamaIndex

### Introduction

LlamaIndex excels at connecting LLMs to data sources, making it ideal for RAG-based agents.

### Installation

```bash
pip install llama-index llama-index-llms-openai llama-index-embeddings-openai
```

### Data-Centric Agent

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.core.tools import QueryEngineTool, ToolMetadata
from llama_index.core.agent import ReActAgent
from llama_index.llms.openai import OpenAI

# Load documents
documents = SimpleDirectoryReader("./data").load_data()

# Create index
index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()

# Create tool from query engine
query_tool = QueryEngineTool(
    query_engine=query_engine,
    metadata=ToolMetadata(
        name="knowledge_base",
        description="Search the knowledge base for information"
    )
)

# Create agent
llm = OpenAI(model="gpt-4o", temperature=0)
agent = ReActAgent.from_tools(
    tools=[query_tool],
    llm=llm,
    verbose=True
)

# Query
response = agent.chat("What information do we have about AI agents?")
print(response)
```

---

## 📊 Framework Comparison

| Feature | LangChain | LangGraph | AutoGen | CrewAI | LlamaIndex |
|---------|-----------|-----------|---------|--------|------------|
| **Focus** | General | Workflows | Multi-agent | Role-based | Data |
| **Complexity** | Medium | Medium-High | Medium | Low | Medium |
| **Flexibility** | High | Very High | Medium | Medium | High |
| **Multi-agent** | Limited | Good | Excellent | Excellent | Limited |
| **Memory** | Good | Excellent | Good | Basic | Good |
| **Tools** | Extensive | Good | Good | Good | Good |
| **Learning Curve** | Medium | Steep | Medium | Easy | Medium |
| **Production Ready** | Yes | Yes | Growing | Growing | Yes |

### When to Use What

```
LangChain:
├── General-purpose agents
├── Quick prototypes
└── Extensive tool integration

LangGraph:
├── Complex, stateful workflows
├── Cyclic agent behaviors
└── Fine-grained control

AutoGen:
├── Conversational multi-agent systems
├── Code generation and execution
└── Debate/discussion patterns

CrewAI:
├── Role-based agent teams
├── Business workflows
└── Easy multi-agent setup

LlamaIndex:
├── RAG-focused applications
├── Data-intensive tasks
└── Document Q&A
```

---

## 🛠️ Practical Project: Research Assistant

Let's build a complete research assistant combining multiple concepts:

```python
# research_assistant.py
from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool
from langchain_openai import ChatOpenAI

class ResearchAssistant:
    def __init__(self, api_key: str):
        self.llm = ChatOpenAI(
            model="gpt-4o",
            temperature=0.7,
            api_key=api_key
        )
        self.search_tool = SerperDevTool()
        self._setup_agents()
    
    def _setup_agents(self):
        self.researcher = Agent(
            role="Senior Research Analyst",
            goal="Find comprehensive, accurate information",
            backstory="Expert researcher with academic background",
            tools=[self.search_tool],
            llm=self.llm,
            verbose=True
        )
        
        self.analyst = Agent(
            role="Information Analyst",
            goal="Analyze and synthesize research findings",
            backstory="Data analyst specializing in qualitative analysis",
            llm=self.llm,
            verbose=True
        )
        
        self.writer = Agent(
            role="Technical Writer",
            goal="Create clear, comprehensive reports",
            backstory="Experienced writer of technical documentation",
            llm=self.llm,
            verbose=True
        )
    
    def research(self, topic: str) -> str:
        research_task = Task(
            description=f"Research thoroughly: {topic}",
            expected_output="Detailed research findings with sources",
            agent=self.researcher
        )
        
        analysis_task = Task(
            description="Analyze the research and identify key insights",
            expected_output="Analytical summary with conclusions",
            agent=self.analyst,
            context=[research_task]
        )
        
        report_task = Task(
            description="Write a comprehensive research report",
            expected_output="Well-structured research report",
            agent=self.writer,
            context=[research_task, analysis_task]
        )
        
        crew = Crew(
            agents=[self.researcher, self.analyst, self.writer],
            tasks=[research_task, analysis_task, report_task],
            process=Process.sequential,
            verbose=True
        )
        
        return crew.kickoff()

# Usage
if __name__ == "__main__":
    import os
    assistant = ResearchAssistant(api_key=os.getenv("OPENAI_API_KEY"))
    report = assistant.research("Current state of AI agent frameworks in 2024")
    print(report)
```

---

## 📝 Key Takeaways

1. **LangChain** is the go-to for general agent development
2. **LangGraph** excels at complex, stateful workflows
3. **AutoGen** shines for multi-agent conversations
4. **CrewAI** makes role-based teams easy
5. **LlamaIndex** is best for data-centric applications
6. Choose based on your specific use case

---

## 🔗 What's Next?

Module 4: **Large Language Models** - Deep dive into the LLMs that power agents

---

## 📚 Resources

### Documentation
- [LangChain Docs](https://python.langchain.com)
- [LangGraph Docs](https://langchain-ai.github.io/langgraph/)
- [AutoGen Docs](https://microsoft.github.io/autogen/)
- [CrewAI Docs](https://docs.crewai.com)
- [LlamaIndex Docs](https://docs.llamaindex.ai)

### Tutorials
- [LangChain Academy](https://academy.langchain.com)
- [LangGraph Tutorial Series](https://www.youtube.com/playlist?list=PLfaIDFEXuae2LXbO1_PKyVJiQ23ZztA0x)

---

*Module 3 Complete. Continue to Module 4: Large Language Models →*

# 🏗️ Agentic Model Types & Architectures

## Overview

This reference covers all major agent architectures, patterns, and models used in building AI agents. Use this guide to understand and choose the right approach for your use case.

---

## 📊 Agent Architecture Taxonomy

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      AGENT ARCHITECTURES                                 │
└─────────────────────────────────────────────────────────────────────────┘

                           ┌─────────────────┐
                           │   AI AGENTS     │
                           └────────┬────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│   REASONING   │         │   PLANNING    │         │ MULTI-AGENT   │
│   PATTERNS    │         │   PATTERNS    │         │   PATTERNS    │
└───────────────┘         └───────────────┘         └───────────────┘
        │                           │                           │
    ┌───┴───┐                 ┌─────┴─────┐               ┌─────┴─────┐
    │       │                 │           │               │           │
    ▼       ▼                 ▼           ▼               ▼           ▼
  ReAct   CoT            Plan-and    Hierarchical    Supervisor   Debate
                         Execute      Planning
```

---

## 🧠 Reasoning-Based Architectures

### 1. ReAct (Reasoning + Acting)

**The most popular agent architecture**. Interleaves reasoning (thought) with action (tool use).

```
Loop:
1. THOUGHT: Analyze the current situation
2. ACTION: Choose and execute a tool
3. OBSERVATION: Process the result
4. Repeat until task complete
```

```python
# ReAct Pattern
REACT_PROMPT = """Answer the question using the following format:

Question: {question}

Thought: I need to think about what to do...
Action: tool_name[tool_input]
Observation: result from tool
Thought: Based on the observation...
Action: another_tool[input]
Observation: another result
...
Thought: I now know the final answer
Final Answer: the answer to the question
"""

# LangChain Implementation
from langchain.agents import create_react_agent, AgentExecutor
from langchain import hub

prompt = hub.pull("hwchase17/react")
agent = create_react_agent(llm, tools, prompt)
executor = AgentExecutor(agent=agent, tools=tools)
```

**Best For**: General-purpose agents, web search, multi-step reasoning

### 2. Chain-of-Thought (CoT)

Explicit step-by-step reasoning before acting.

```
Process:
1. Break down the problem into steps
2. Think through each step explicitly
3. Show reasoning process
4. Arrive at answer
```

```python
COT_PROMPT = """Let's think step by step:

Question: {question}

Step 1: First, I need to understand what's being asked...
Step 2: The key components of this problem are...
Step 3: To solve this, I should...
Step 4: Applying the approach...
Step 5: Therefore, the answer is...

Final Answer: {answer}
"""

# Zero-shot CoT
response = llm.invoke("What is 17 * 24? Let's think step by step.")

# Few-shot CoT (with examples)
few_shot_cot = """
Example:
Q: What is 15 * 12?
Let's think step by step:
- 15 * 12 = 15 * 10 + 15 * 2
- 15 * 10 = 150
- 15 * 2 = 30
- 150 + 30 = 180
Answer: 180

Q: {question}
Let's think step by step:
"""
```

**Best For**: Math problems, logic puzzles, complex reasoning

### 3. Tree of Thoughts (ToT)

Explores multiple reasoning paths simultaneously.

```
              [Problem]
                  │
    ┌─────────────┼─────────────┐
    │             │             │
    ▼             ▼             ▼
[Thought 1]  [Thought 2]  [Thought 3]
    │             │             │
    ▼             ▼             ▼
[Evaluate]   [Evaluate]   [Evaluate]
    │             │
    ▼             ▼
 [Expand]    [Expand]
    │
    ▼
[Solution]
```

```python
from langchain_experimental.tot import TreeOfThought

tot = TreeOfThought(
    llm=llm,
    num_thoughts=3,  # Generate 3 thoughts per step
    max_depth=5,     # Maximum reasoning depth
    evaluation_strategy="vote"  # or "score"
)

result = tot.run("Solve this complex puzzle...")
```

**Best For**: Creative problem solving, game playing, complex optimization

### 4. Reflexion

Self-reflection and learning from mistakes.

```
Loop:
1. Attempt task
2. Evaluate performance
3. Reflect on what went wrong
4. Generate improved strategy
5. Retry with new strategy
```

```python
REFLEXION_PROMPT = """
Previous Attempt: {previous_attempt}
Outcome: {outcome}
Feedback: {feedback}

Reflection:
- What went wrong: {analysis}
- What I learned: {lessons}
- Improved strategy: {new_strategy}

New Attempt:
{new_attempt}
"""

class ReflexionAgent:
    def __init__(self, llm, max_iterations=3):
        self.llm = llm
        self.max_iterations = max_iterations
        self.memory = []
    
    def run(self, task):
        for i in range(self.max_iterations):
            attempt = self.attempt(task)
            success, feedback = self.evaluate(attempt)
            
            if success:
                return attempt
            
            reflection = self.reflect(attempt, feedback)
            self.memory.append(reflection)
        
        return self.best_attempt()
```

**Best For**: Complex tasks with feedback, learning systems, iterative improvement

---

## 📋 Planning-Based Architectures

### 1. Plan-and-Execute

First create a plan, then execute each step.

```
1. PLAN: Create full plan for task
   - Step 1: Do X
   - Step 2: Do Y
   - Step 3: Do Z

2. EXECUTE: Run each step sequentially
   - Execute Step 1 → Result 1
   - Execute Step 2 → Result 2
   - Execute Step 3 → Result 3

3. REPLAN: Adjust if needed
```

```python
from langchain.agents import PlanAndExecute, load_agent_executor
from langchain_experimental.plan_and_execute import PlanAndExecute, load_chat_planner

# Create planner and executor
planner = load_chat_planner(llm)
executor = load_agent_executor(llm, tools, verbose=True)

# Create Plan-and-Execute agent
agent = PlanAndExecute(planner=planner, executor=executor)
result = agent.run("Research and summarize the latest AI developments")
```

**Best For**: Long-horizon tasks, research tasks, multi-step workflows

### 2. Hierarchical Planning

Break down tasks into subtasks, recursively.

```
┌─────────────────────────────────────┐
│         HIGH-LEVEL GOAL             │
│    "Build a web application"        │
└─────────────────┬───────────────────┘
                  │
    ┌─────────────┼─────────────┐
    │             │             │
    ▼             ▼             ▼
┌────────┐  ┌────────┐  ┌────────┐
│Frontend│  │Backend │  │Database│
└────┬───┘  └────┬───┘  └────┬───┘
     │           │           │
  ┌──┴──┐     ┌──┴──┐     ┌──┴──┐
  │     │     │     │     │     │
  ▼     ▼     ▼     ▼     ▼     ▼
[Sub]  [Sub] [Sub] [Sub] [Sub] [Sub]
tasks  tasks tasks tasks tasks tasks
```

```python
class HierarchicalAgent:
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = tools
    
    def decompose(self, goal, depth=0, max_depth=3):
        if depth >= max_depth:
            return [{"task": goal, "atomic": True}]
        
        # Ask LLM to decompose
        subtasks = self.llm.invoke(f"""
        Break down this task into 2-4 subtasks:
        Task: {goal}
        
        Subtasks:
        """)
        
        # Recursively decompose subtasks
        all_tasks = []
        for subtask in subtasks:
            all_tasks.extend(self.decompose(subtask, depth + 1))
        
        return all_tasks
    
    def execute(self, goal):
        tasks = self.decompose(goal)
        results = []
        for task in tasks:
            if task["atomic"]:
                result = self.execute_atomic(task["task"])
                results.append(result)
        return self.synthesize(results)
```

**Best For**: Complex projects, software development, research papers

### 3. LLM Compiler

Parallel planning and execution for efficiency.

```
┌─────────────────────────────────────┐
│           TASK INPUT                │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│         PLANNER (creates DAG)       │
└─────────────────┬───────────────────┘
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
    [Task A]  [Task B]  [Task C]  ← Parallel
        │         │         │
        └────┬────┴────┬────┘
             │         │
             ▼         ▼
         [Task D]  [Task E]  ← Dependencies resolved
             │         │
             └────┬────┘
                  │
                  ▼
            [Final Result]
```

**Best For**: Optimizing complex workflows, parallel execution

---

## 👥 Multi-Agent Architectures

### 1. Supervisor Pattern

A supervisor agent delegates to specialized workers.

```
                    ┌────────────────┐
                    │   SUPERVISOR   │
                    │   (Orchestrator)│
                    └────────┬───────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
    ┌────────────┐   ┌────────────┐   ┌────────────┐
    │  RESEARCH  │   │   WRITER   │   │  REVIEWER  │
    │   AGENT    │   │   AGENT    │   │   AGENT    │
    └────────────┘   └────────────┘   └────────────┘
```

```python
from langgraph.graph import StateGraph, END

# Define agent state
class AgentState(TypedDict):
    messages: list
    next_agent: str

# Define supervisor
def supervisor(state):
    # Decide which agent to call next
    response = llm.invoke(f"""
    Based on the current state, which agent should handle this?
    Options: researcher, writer, reviewer, FINISH
    
    Messages: {state['messages']}
    """)
    return {"next_agent": response.content}

# Build graph
workflow = StateGraph(AgentState)
workflow.add_node("supervisor", supervisor)
workflow.add_node("researcher", research_agent)
workflow.add_node("writer", writer_agent)
workflow.add_node("reviewer", reviewer_agent)

# Add routing
workflow.add_conditional_edges(
    "supervisor",
    lambda x: x["next_agent"],
    {
        "researcher": "researcher",
        "writer": "writer",
        "reviewer": "reviewer",
        "FINISH": END
    }
)
```

**Best For**: Complex workflows, specialized expertise, quality control

### 2. Debate / Adversarial Pattern

Multiple agents debate to reach better conclusions.

```
┌───────────────┐         ┌───────────────┐
│   AGENT A     │◄───────►│   AGENT B     │
│  (Proponent)  │  Debate │  (Opponent)   │
└───────────────┘         └───────────────┘
        │                         │
        └────────────┬────────────┘
                     │
                     ▼
              ┌────────────┐
              │   JUDGE    │
              │   AGENT    │
              └────────────┘
                     │
                     ▼
              [Final Decision]
```

```python
class DebateSystem:
    def __init__(self, llm):
        self.proponent = Agent(llm, role="Argue FOR the position")
        self.opponent = Agent(llm, role="Argue AGAINST the position")
        self.judge = Agent(llm, role="Evaluate arguments fairly")
    
    def debate(self, topic, rounds=3):
        arguments = []
        
        for round in range(rounds):
            # Proponent argues
            pro_arg = self.proponent.argue(topic, arguments)
            arguments.append(("PRO", pro_arg))
            
            # Opponent counters
            con_arg = self.opponent.argue(topic, arguments)
            arguments.append(("CON", con_arg))
        
        # Judge decides
        verdict = self.judge.evaluate(topic, arguments)
        return verdict
```

**Best For**: Decision making, fact-checking, exploring complex topics

### 3. Collaborative Team (CrewAI Style)

Specialized agents working together with defined roles.

```python
from crewai import Agent, Task, Crew

# Define agents with roles
researcher = Agent(
    role="Senior Research Analyst",
    goal="Find comprehensive information on topics",
    backstory="Expert researcher with 10 years experience",
    tools=[search_tool, scrape_tool],
    llm=llm
)

writer = Agent(
    role="Content Writer",
    goal="Create engaging, accurate content",
    backstory="Award-winning journalist",
    tools=[],
    llm=llm
)

editor = Agent(
    role="Editor",
    goal="Ensure quality and accuracy",
    backstory="Senior editor with attention to detail",
    tools=[],
    llm=llm
)

# Define tasks
research_task = Task(
    description="Research {topic} thoroughly",
    agent=researcher,
    expected_output="Comprehensive research notes"
)

writing_task = Task(
    description="Write article based on research",
    agent=writer,
    expected_output="Draft article"
)

editing_task = Task(
    description="Edit and polish the article",
    agent=editor,
    expected_output="Final polished article"
)

# Create crew
crew = Crew(
    agents=[researcher, writer, editor],
    tasks=[research_task, writing_task, editing_task],
    process="sequential"  # or "hierarchical"
)

result = crew.kickoff(inputs={"topic": "AI Agents"})
```

**Best For**: Content creation, software development teams, complex projects

### 4. AutoGen Conversation Pattern

Agents communicate through natural conversation.

```python
from autogen import AssistantAgent, UserProxyAgent

# Create agents
assistant = AssistantAgent(
    name="assistant",
    llm_config={"model": "gpt-4o"},
    system_message="You are a helpful AI assistant."
)

user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    code_execution_config={"work_dir": "workspace"}
)

coder = AssistantAgent(
    name="coder",
    llm_config={"model": "gpt-4o"},
    system_message="You are a Python expert. Write clean code."
)

critic = AssistantAgent(
    name="critic",
    llm_config={"model": "gpt-4o"},
    system_message="You review code for bugs and improvements."
)

# Group chat
from autogen import GroupChat, GroupChatManager

group_chat = GroupChat(
    agents=[user_proxy, coder, critic],
    messages=[],
    max_round=10
)

manager = GroupChatManager(groupchat=group_chat)

# Start conversation
user_proxy.initiate_chat(
    manager,
    message="Create a Python function to sort a list"
)
```

**Best For**: Coding tasks, collaborative problem solving, iterative refinement

---

## 🔄 Hybrid Architectures

### 1. Adaptive Agent

Switches between strategies based on task.

```python
class AdaptiveAgent:
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = tools
        
        # Different strategies
        self.react_agent = create_react_agent(llm, tools)
        self.planner = PlanAndExecute(llm, tools)
        self.cot_chain = create_cot_chain(llm)
    
    def classify_task(self, task):
        response = self.llm.invoke(f"""
        Classify this task:
        - "simple": Direct answer, no tools needed
        - "tool": Needs tool use, single step
        - "multi_step": Requires planning
        - "reasoning": Complex reasoning needed
        
        Task: {task}
        Classification:
        """)
        return response.content.strip()
    
    def run(self, task):
        task_type = self.classify_task(task)
        
        if task_type == "simple":
            return self.llm.invoke(task)
        elif task_type == "tool":
            return self.react_agent.invoke(task)
        elif task_type == "multi_step":
            return self.planner.run(task)
        elif task_type == "reasoning":
            return self.cot_chain.invoke(task)
```

### 2. Memory-Augmented Agent

Combines working memory, episodic memory, and semantic memory.

```python
class MemoryAugmentedAgent:
    def __init__(self, llm, vectorstore):
        self.llm = llm
        
        # Different memory types
        self.working_memory = []  # Current context
        self.episodic_memory = []  # Past interactions
        self.semantic_memory = vectorstore  # Knowledge base
    
    def think(self, query):
        # Retrieve relevant knowledge
        knowledge = self.semantic_memory.similarity_search(query)
        
        # Get relevant past episodes
        episodes = self.retrieve_episodes(query)
        
        # Combine with working memory
        context = self.build_context(
            working=self.working_memory,
            episodes=episodes,
            knowledge=knowledge
        )
        
        # Generate response
        response = self.llm.invoke(f"""
        Context: {context}
        Query: {query}
        Response:
        """)
        
        # Update memories
        self.update_memories(query, response)
        
        return response
```

---

## 📊 Architecture Comparison

| Architecture | Complexity | Best For | Limitations |
|-------------|------------|----------|-------------|
| **ReAct** | Low | General tasks | Can get stuck in loops |
| **CoT** | Low | Reasoning | No tool use |
| **Plan-Execute** | Medium | Long tasks | Rigid plans |
| **Hierarchical** | High | Complex projects | Overhead |
| **Supervisor** | Medium | Team coordination | Single point of failure |
| **Debate** | Medium | Decision making | Slow |
| **CrewAI Team** | High | Specialized tasks | Setup complexity |

---

## 🎯 Choosing an Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│               ARCHITECTURE SELECTION GUIDE                       │
└─────────────────────────────────────────────────────────────────┘

Simple tool use needed?
    └── YES → ReAct
    └── NO → Continue...

Complex reasoning required?
    └── YES → Chain-of-Thought or Tree-of-Thought
    └── NO → Continue...

Long multi-step task?
    └── YES → Plan-and-Execute
    └── NO → Continue...

Need multiple specialists?
    └── YES → Multi-Agent (Supervisor or CrewAI)
    └── NO → Continue...

Quality through debate?
    └── YES → Debate Pattern
    └── NO → ReAct (default)
```

---

## 📚 Key Takeaways

1. **ReAct is the default** - Start here for most tasks
2. **Planning for long tasks** - Use Plan-and-Execute for multi-step work
3. **Multi-agent for specialization** - When you need different expertise
4. **Combine architectures** - Hybrid approaches often work best
5. **Match to your task** - No one-size-fits-all solution

---

## 🔗 Related Resources

- [External-Tools-and-APIs.md](./External-Tools-and-APIs.md) - Tools for agents
- [05-Understanding-AI-Agents](./05-Understanding-AI-Agents) - Deep dive into agents

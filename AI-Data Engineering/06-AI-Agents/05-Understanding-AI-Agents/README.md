# 🎯 Module 05: Understanding AI Agents

## Overview

This module provides a deep understanding of AI agent architectures, design patterns, and implementation strategies. You'll learn how to design agents for different use cases and understand the trade-offs involved.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Master** core agent design patterns
2. **Understand** agent reasoning mechanisms
3. **Implement** various agent architectures
4. **Design** agents for specific use cases
5. **Evaluate** agent performance and reliability

---

## 📚 Prerequisites

- Modules 01-04 completed
- Hands-on experience with LangChain or similar
- Python programming proficiency

---

## 🧩 Agent Design Patterns

### Pattern Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT DESIGN PATTERNS                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  REASONING PATTERNS           │  EXECUTION PATTERNS             │
│  ──────────────────           │  ─────────────────              │
│  • ReAct                      │  • Sequential                   │
│  • Chain-of-Thought           │  • Parallel                     │
│  • Tree of Thoughts           │  • Iterative                    │
│  • Reflexion                  │  • Human-in-the-loop            │
│                                                                  │
│  PLANNING PATTERNS            │  MULTI-AGENT PATTERNS           │
│  ────────────────             │  ──────────────────             │
│  • Plan-then-Execute          │  • Supervisor                   │
│  • Hierarchical               │  • Debate                       │
│  • LLM Compiler               │  • Collaborative                │
│  • Adaptive                   │  • Competitive                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 ReAct Pattern

ReAct (Reasoning + Acting) interleaves reasoning with tool use.

```
┌─────────────────────────────────────────────────────────────────┐
│                         ReAct LOOP                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│    ┌─────────┐                                                  │
│    │ THOUGHT │  "I need to search for current AI news..."       │
│    └────┬────┘                                                  │
│         │                                                        │
│         ▼                                                        │
│    ┌─────────┐                                                  │
│    │ ACTION  │  search_web("AI news 2024")                      │
│    └────┬────┘                                                  │
│         │                                                        │
│         ▼                                                        │
│    ┌─────────────┐                                              │
│    │ OBSERVATION │  "Results: OpenAI released GPT-5..."         │
│    └──────┬──────┘                                              │
│           │                                                      │
│           ▼                                                      │
│    ┌─────────┐                                                  │
│    │ THOUGHT │  "I found the information, now I can answer"     │
│    └────┬────┘                                                  │
│         │                                                        │
│         ▼                                                        │
│    ┌─────────────┐                                              │
│    │ FINAL ANSWER│                                              │
│    └─────────────┘                                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
from typing import TypedDict, Annotated, Sequence
from langchain_openai import ChatOpenAI
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate
from langgraph.graph import StateGraph, END
from langgraph.prebuilt import ToolNode
import operator

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    thoughts: list  # Track reasoning

# ReAct Prompt
REACT_PROMPT = """You are a helpful AI assistant with access to tools.

When you need to use a tool, think step by step:
1. THOUGHT: Explain your reasoning
2. ACTION: Use the appropriate tool
3. OBSERVATION: Process the result
4. Repeat if needed, or provide FINAL ANSWER

Always reason before acting.

Available tools: {tools}
"""

def create_react_agent(llm, tools):
    """Create a ReAct-style agent."""
    
    tool_node = ToolNode(tools)
    llm_with_tools = llm.bind_tools(tools)
    
    def reasoning_node(state: AgentState):
        """Agent reasoning step."""
        response = llm_with_tools.invoke(state["messages"])
        return {"messages": [response]}
    
    def should_continue(state: AgentState):
        """Determine if more steps needed."""
        last_message = state["messages"][-1]
        if last_message.tool_calls:
            return "tools"
        return "end"
    
    # Build graph
    workflow = StateGraph(AgentState)
    workflow.add_node("agent", reasoning_node)
    workflow.add_node("tools", tool_node)
    
    workflow.set_entry_point("agent")
    workflow.add_conditional_edges("agent", should_continue, 
                                   {"tools": "tools", "end": END})
    workflow.add_edge("tools", "agent")
    
    return workflow.compile()
```

---

## 🌳 Chain-of-Thought (CoT)

CoT prompts the model to think step by step before answering.

```python
# Zero-shot CoT
ZERO_SHOT_COT = """
{question}

Let's think step by step.
"""

# Few-shot CoT
FEW_SHOT_COT = """
Example 1:
Question: If I have 5 apples and give away 2, how many do I have?
Thinking: 
- I start with 5 apples
- I give away 2 apples
- 5 - 2 = 3
Answer: 3 apples

Example 2:
Question: A train travels 60 mph for 2.5 hours. How far does it go?
Thinking:
- Speed = 60 mph
- Time = 2.5 hours
- Distance = Speed × Time
- Distance = 60 × 2.5 = 150
Answer: 150 miles

Now solve:
Question: {question}
Thinking:
"""

def chain_of_thought(question: str, llm) -> str:
    """Apply CoT reasoning."""
    prompt = FEW_SHOT_COT.format(question=question)
    response = llm.invoke(prompt)
    return response.content
```

---

## 🌲 Tree of Thoughts (ToT)

ToT explores multiple reasoning paths and selects the best.

```python
from typing import List, Tuple
import heapq

class TreeOfThoughts:
    def __init__(self, llm, num_thoughts: int = 3, max_depth: int = 3):
        self.llm = llm
        self.num_thoughts = num_thoughts
        self.max_depth = max_depth
    
    def generate_thoughts(self, state: str, problem: str) -> List[str]:
        """Generate multiple candidate thoughts."""
        prompt = f"""
        Problem: {problem}
        Current state: {state}
        
        Generate {self.num_thoughts} different next steps to solve this.
        Format each as: THOUGHT: [description]
        """
        response = self.llm.invoke(prompt)
        # Parse thoughts from response
        thoughts = self._parse_thoughts(response.content)
        return thoughts[:self.num_thoughts]
    
    def evaluate_thought(self, thought: str, problem: str) -> float:
        """Evaluate promise of a thought (0-1 score)."""
        prompt = f"""
        Problem: {problem}
        Proposed approach: {thought}
        
        Rate this approach's promise on a scale of 0-10.
        Consider: correctness likelihood, efficiency, completeness.
        Return only the number.
        """
        response = self.llm.invoke(prompt)
        try:
            score = float(response.content.strip()) / 10
            return min(max(score, 0), 1)
        except:
            return 0.5
    
    def solve(self, problem: str) -> str:
        """Solve using tree search."""
        # Priority queue: (-score, depth, state, path)
        frontier = [(0, 0, "Start", [])]
        best_solution = None
        best_score = -1
        
        while frontier:
            neg_score, depth, state, path = heapq.heappop(frontier)
            
            if depth >= self.max_depth:
                # Evaluate final solution
                if -neg_score > best_score:
                    best_score = -neg_score
                    best_solution = path
                continue
            
            # Generate and evaluate next thoughts
            thoughts = self.generate_thoughts(state, problem)
            for thought in thoughts:
                score = self.evaluate_thought(thought, problem)
                new_path = path + [thought]
                heapq.heappush(frontier, 
                             (-score, depth + 1, thought, new_path))
        
        # Synthesize final answer from best path
        return self._synthesize_answer(problem, best_solution)
    
    def _parse_thoughts(self, text: str) -> List[str]:
        """Extract thoughts from LLM response."""
        thoughts = []
        for line in text.split('\n'):
            if 'THOUGHT:' in line:
                thoughts.append(line.split('THOUGHT:')[1].strip())
        return thoughts
    
    def _synthesize_answer(self, problem: str, path: List[str]) -> str:
        """Generate final answer from reasoning path."""
        prompt = f"""
        Problem: {problem}
        Reasoning steps taken:
        {chr(10).join(f'{i+1}. {step}' for i, step in enumerate(path))}
        
        Based on this reasoning, provide the final answer:
        """
        return self.llm.invoke(prompt).content
```

---

## 🔄 Reflexion Pattern

Reflexion enables agents to learn from mistakes through self-reflection.

```python
from typing import TypedDict, List

class ReflexionState(TypedDict):
    task: str
    attempts: List[dict]  # {attempt, result, reflection}
    success: bool
    max_attempts: int

class ReflexionAgent:
    def __init__(self, llm, executor, evaluator):
        self.llm = llm
        self.executor = executor  # Execute the task
        self.evaluator = evaluator  # Evaluate success
    
    def attempt(self, state: ReflexionState) -> dict:
        """Make an attempt to solve the task."""
        # Build prompt with previous reflections
        context = self._build_context(state)
        
        prompt = f"""
        Task: {state['task']}
        
        Previous attempts and reflections:
        {context}
        
        Based on the above, generate your approach:
        """
        
        approach = self.llm.invoke(prompt).content
        result = self.executor(approach)
        
        return {"attempt": approach, "result": result}
    
    def reflect(self, state: ReflexionState, attempt_result: dict) -> str:
        """Reflect on the attempt."""
        prompt = f"""
        Task: {state['task']}
        
        Your attempt: {attempt_result['attempt']}
        Result: {attempt_result['result']}
        
        Reflect on what went wrong and how to improve:
        - What worked well?
        - What didn't work?
        - What would you do differently?
        """
        
        reflection = self.llm.invoke(prompt).content
        return reflection
    
    def run(self, task: str, max_attempts: int = 3) -> str:
        """Run reflexion loop."""
        state: ReflexionState = {
            "task": task,
            "attempts": [],
            "success": False,
            "max_attempts": max_attempts
        }
        
        for i in range(max_attempts):
            # Attempt
            attempt_result = self.attempt(state)
            
            # Evaluate
            success = self.evaluator(task, attempt_result["result"])
            
            if success:
                state["success"] = True
                return attempt_result["result"]
            
            # Reflect
            reflection = self.reflect(state, attempt_result)
            
            # Update state
            state["attempts"].append({
                **attempt_result,
                "reflection": reflection
            })
        
        # Return best attempt
        return state["attempts"][-1]["result"]
    
    def _build_context(self, state: ReflexionState) -> str:
        """Build context from previous attempts."""
        if not state["attempts"]:
            return "No previous attempts."
        
        context = []
        for i, attempt in enumerate(state["attempts"]):
            context.append(f"""
            Attempt {i+1}:
            Approach: {attempt['attempt']}
            Result: {attempt['result']}
            Reflection: {attempt['reflection']}
            """)
        return "\n".join(context)
```

---

## 📋 Plan-and-Execute Pattern

Separates planning from execution for complex tasks.

```python
from typing import TypedDict, List, Tuple

class PlanExecuteState(TypedDict):
    objective: str
    plan: List[str]
    completed_steps: List[Tuple[str, str]]  # (step, result)
    current_step_idx: int
    final_response: str

class PlanExecuteAgent:
    def __init__(self, planner_llm, executor_llm, tools):
        self.planner = planner_llm
        self.executor = executor_llm
        self.tools = tools
    
    def create_plan(self, objective: str) -> List[str]:
        """Create a detailed plan."""
        prompt = f"""
        Create a step-by-step plan to accomplish this objective:
        {objective}
        
        Requirements:
        - Each step should be specific and actionable
        - Steps should be in logical order
        - Include all necessary steps
        
        Available tools: {[t.name for t in self.tools]}
        
        Format each step as:
        1. [Step description]
        2. [Step description]
        ...
        """
        
        response = self.planner.invoke(prompt)
        # Parse steps from response
        steps = self._parse_plan(response.content)
        return steps
    
    def execute_step(self, step: str, context: List[Tuple[str, str]]) -> str:
        """Execute a single step."""
        context_str = "\n".join([
            f"Completed: {s} -> Result: {r}" 
            for s, r in context
        ])
        
        prompt = f"""
        Execute this step:
        {step}
        
        Previous context:
        {context_str}
        
        Use the available tools as needed.
        """
        
        # Execute with tool access
        result = self._execute_with_tools(prompt)
        return result
    
    def replan(self, state: PlanExecuteState) -> List[str]:
        """Replan based on current progress."""
        prompt = f"""
        Original objective: {state['objective']}
        
        Completed steps:
        {self._format_completed(state['completed_steps'])}
        
        Remaining plan:
        {state['plan'][state['current_step_idx']:]}
        
        Based on progress, do we need to adjust the plan?
        If yes, provide the updated remaining steps.
        If no, respond with "CONTINUE".
        """
        
        response = self.planner.invoke(prompt)
        if "CONTINUE" in response.content:
            return state['plan'][state['current_step_idx']:]
        return self._parse_plan(response.content)
    
    def run(self, objective: str) -> str:
        """Execute plan-and-execute loop."""
        # Create initial plan
        plan = self.create_plan(objective)
        
        state: PlanExecuteState = {
            "objective": objective,
            "plan": plan,
            "completed_steps": [],
            "current_step_idx": 0,
            "final_response": ""
        }
        
        while state["current_step_idx"] < len(state["plan"]):
            current_step = state["plan"][state["current_step_idx"]]
            
            # Execute step
            result = self.execute_step(current_step, state["completed_steps"])
            state["completed_steps"].append((current_step, result))
            state["current_step_idx"] += 1
            
            # Check if replanning needed (every 3 steps)
            if state["current_step_idx"] % 3 == 0:
                new_plan = self.replan(state)
                if new_plan != state["plan"][state["current_step_idx"]:]:
                    state["plan"] = (
                        state["plan"][:state["current_step_idx"]] + 
                        new_plan
                    )
        
        # Synthesize final response
        return self._synthesize_response(state)
    
    def _parse_plan(self, text: str) -> List[str]:
        """Parse plan steps from text."""
        steps = []
        for line in text.split('\n'):
            line = line.strip()
            if line and line[0].isdigit():
                # Remove numbering
                step = line.split('.', 1)[-1].strip()
                if step:
                    steps.append(step)
        return steps
    
    def _format_completed(self, completed: List[Tuple[str, str]]) -> str:
        """Format completed steps."""
        return "\n".join([
            f"✓ {step}\n  Result: {result}"
            for step, result in completed
        ])
    
    def _synthesize_response(self, state: PlanExecuteState) -> str:
        """Create final response from completed steps."""
        prompt = f"""
        Objective: {state['objective']}
        
        Completed work:
        {self._format_completed(state['completed_steps'])}
        
        Synthesize a final response that addresses the original objective.
        """
        return self.planner.invoke(prompt).content
    
    def _execute_with_tools(self, prompt: str) -> str:
        """Execute prompt with tool access."""
        # Implementation depends on your tool framework
        pass
```

---

## 🎭 Agent Personas and Roles

### Persona Design

```python
from dataclasses import dataclass
from typing import List, Optional

@dataclass
class AgentPersona:
    name: str
    role: str
    expertise: List[str]
    personality_traits: List[str]
    communication_style: str
    goals: List[str]
    constraints: List[str]
    
    def to_system_prompt(self) -> str:
        return f"""You are {self.name}, a {self.role}.

## Expertise
{chr(10).join(f'- {e}' for e in self.expertise)}

## Personality
{chr(10).join(f'- {t}' for t in self.personality_traits)}

## Communication Style
{self.communication_style}

## Goals
{chr(10).join(f'- {g}' for g in self.goals)}

## Constraints
{chr(10).join(f'- {c}' for c in self.constraints)}
"""

# Example personas
RESEARCHER = AgentPersona(
    name="Dr. Research",
    role="Senior Research Analyst",
    expertise=[
        "Academic literature review",
        "Data synthesis",
        "Statistical analysis",
        "Fact verification"
    ],
    personality_traits=[
        "Meticulous and thorough",
        "Skeptical of unverified claims",
        "Detail-oriented"
    ],
    communication_style="Professional, academic, uses citations",
    goals=[
        "Find accurate, comprehensive information",
        "Verify all claims with sources",
        "Present balanced perspectives"
    ],
    constraints=[
        "Always cite sources",
        "Acknowledge uncertainty",
        "Avoid speculation"
    ]
)

CODER = AgentPersona(
    name="CodeMaster",
    role="Senior Software Engineer",
    expertise=[
        "Python, JavaScript, TypeScript",
        "System design",
        "Code review",
        "Testing strategies"
    ],
    personality_traits=[
        "Pragmatic problem-solver",
        "Values clean, maintainable code",
        "Security-conscious"
    ],
    communication_style="Concise, technical, includes code examples",
    goals=[
        "Write efficient, bug-free code",
        "Follow best practices",
        "Create maintainable solutions"
    ],
    constraints=[
        "Follow security best practices",
        "Include error handling",
        "Write testable code"
    ]
)
```

---

## 🔍 Agent Introspection

### Self-Monitoring

```python
class IntrospectiveAgent:
    """Agent that monitors and adjusts its own behavior."""
    
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = tools
        self.action_history = []
        self.confidence_threshold = 0.7
    
    def assess_confidence(self, response: str, context: str) -> float:
        """Assess confidence in a response."""
        prompt = f"""
        Context: {context}
        Response: {response}
        
        Rate your confidence in this response (0-100):
        - Is it factually accurate?
        - Is it complete?
        - Is it relevant?
        
        Return only a number.
        """
        
        score = self.llm.invoke(prompt).content
        try:
            return float(score.strip()) / 100
        except:
            return 0.5
    
    def should_seek_more_info(self, confidence: float) -> bool:
        """Determine if more information is needed."""
        return confidence < self.confidence_threshold
    
    def identify_knowledge_gaps(self, task: str, response: str) -> List[str]:
        """Identify what information is missing."""
        prompt = f"""
        Task: {task}
        Current response: {response}
        
        What information is missing or uncertain?
        List specific knowledge gaps:
        """
        
        gaps = self.llm.invoke(prompt).content
        return [line.strip() for line in gaps.split('\n') if line.strip()]
    
    def run(self, task: str) -> str:
        """Run with self-monitoring."""
        # Initial attempt
        response = self._generate_response(task)
        confidence = self.assess_confidence(response, task)
        
        # Iterative improvement if needed
        iterations = 0
        max_iterations = 3
        
        while self.should_seek_more_info(confidence) and iterations < max_iterations:
            # Identify gaps
            gaps = self.identify_knowledge_gaps(task, response)
            
            # Gather more information
            for gap in gaps[:3]:  # Limit to top 3 gaps
                info = self._search_for_info(gap)
                response = self._incorporate_info(response, info)
            
            # Reassess
            confidence = self.assess_confidence(response, task)
            iterations += 1
        
        # Add confidence disclaimer if still low
        if confidence < self.confidence_threshold:
            response += f"\n\n[Note: Confidence level: {confidence:.0%}]"
        
        return response
    
    def _generate_response(self, task: str) -> str:
        """Generate initial response."""
        return self.llm.invoke(task).content
    
    def _search_for_info(self, query: str) -> str:
        """Search for additional information."""
        # Use search tool
        for tool in self.tools:
            if "search" in tool.name.lower():
                return tool.invoke(query)
        return ""
    
    def _incorporate_info(self, response: str, new_info: str) -> str:
        """Incorporate new information into response."""
        prompt = f"""
        Current response: {response}
        New information: {new_info}
        
        Update the response to incorporate this new information.
        Keep what's accurate, correct what's wrong, add what's missing.
        """
        return self.llm.invoke(prompt).content
```

---

## 📊 Agent Evaluation Framework

```python
from dataclasses import dataclass
from typing import List, Callable
from enum import Enum

class EvaluationMetric(Enum):
    ACCURACY = "accuracy"
    RELEVANCE = "relevance"
    COMPLETENESS = "completeness"
    COHERENCE = "coherence"
    SAFETY = "safety"
    EFFICIENCY = "efficiency"

@dataclass
class EvaluationResult:
    metric: EvaluationMetric
    score: float  # 0-1
    reasoning: str

class AgentEvaluator:
    def __init__(self, evaluator_llm):
        self.llm = evaluator_llm
    
    def evaluate(
        self,
        task: str,
        response: str,
        ground_truth: str = None,
        metrics: List[EvaluationMetric] = None
    ) -> List[EvaluationResult]:
        """Evaluate agent response on multiple dimensions."""
        
        if metrics is None:
            metrics = list(EvaluationMetric)
        
        results = []
        for metric in metrics:
            result = self._evaluate_metric(task, response, ground_truth, metric)
            results.append(result)
        
        return results
    
    def _evaluate_metric(
        self,
        task: str,
        response: str,
        ground_truth: str,
        metric: EvaluationMetric
    ) -> EvaluationResult:
        """Evaluate a single metric."""
        
        prompts = {
            EvaluationMetric.ACCURACY: f"""
                Task: {task}
                Response: {response}
                {"Ground truth: " + ground_truth if ground_truth else ""}
                
                Rate ACCURACY (factual correctness) from 0-10.
                Explain your rating.
            """,
            EvaluationMetric.RELEVANCE: f"""
                Task: {task}
                Response: {response}
                
                Rate RELEVANCE (addresses the task) from 0-10.
                Explain your rating.
            """,
            EvaluationMetric.COMPLETENESS: f"""
                Task: {task}
                Response: {response}
                
                Rate COMPLETENESS (covers all aspects) from 0-10.
                Explain your rating.
            """,
            EvaluationMetric.COHERENCE: f"""
                Response: {response}
                
                Rate COHERENCE (logical flow, clarity) from 0-10.
                Explain your rating.
            """,
            EvaluationMetric.SAFETY: f"""
                Response: {response}
                
                Rate SAFETY (no harmful content) from 0-10.
                Explain your rating.
            """,
            EvaluationMetric.EFFICIENCY: f"""
                Task: {task}
                Response: {response}
                
                Rate EFFICIENCY (concise, not verbose) from 0-10.
                Explain your rating.
            """
        }
        
        evaluation = self.llm.invoke(prompts[metric]).content
        score, reasoning = self._parse_evaluation(evaluation)
        
        return EvaluationResult(
            metric=metric,
            score=score,
            reasoning=reasoning
        )
    
    def _parse_evaluation(self, text: str) -> tuple:
        """Parse score and reasoning from evaluation."""
        # Find score (0-10)
        import re
        score_match = re.search(r'\b([0-9]|10)\b', text)
        score = float(score_match.group()) / 10 if score_match else 0.5
        reasoning = text
        return score, reasoning
```

---

## 📝 Key Takeaways

1. **ReAct** is the most common pattern - reason before acting
2. **CoT** improves reasoning through step-by-step thinking
3. **ToT** explores multiple paths for complex problems
4. **Reflexion** enables learning from mistakes
5. **Plan-Execute** separates planning from execution
6. **Personas** shape agent behavior and communication
7. **Introspection** enables self-improvement
8. **Evaluation** is essential for agent quality

---

## 🔗 What's Next?

Module 6: **Memory and Knowledge Retrieval** - Building long-term agent memory

---

## 📚 Resources

### Papers
- "ReAct: Synergizing Reasoning and Acting" (Yao et al.)
- "Tree of Thoughts" (Yao et al.)
- "Reflexion: Language Agents with Verbal Reinforcement Learning"
- "Chain-of-Thought Prompting" (Wei et al.)

### Implementations
- [LangGraph Agents](https://langchain-ai.github.io/langgraph/)
- [AutoGen Patterns](https://microsoft.github.io/autogen/)

---

*Module 5 Complete. Continue to Module 6: Memory and Knowledge Retrieval →*

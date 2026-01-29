# 🌐 Module 10: Multi-Agent Systems

## Overview

This module covers the design and implementation of systems where multiple AI agents collaborate, compete, or coordinate to solve complex problems.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** multi-agent architectures and patterns
2. **Design** agent communication protocols
3. **Implement** collaborative agent systems
4. **Build** hierarchical agent organizations
5. **Handle** conflict resolution and consensus

---

## 📚 Prerequisites

- Module 05: Understanding AI Agents
- Module 07: Decision Making and Planning
- Understanding of async programming

---

## 🏗️ Multi-Agent Architectures

```
┌─────────────────────────────────────────────────────────────────┐
│              MULTI-AGENT ARCHITECTURE PATTERNS                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. HIERARCHICAL              2. PEER-TO-PEER                   │
│  ──────────────               ─────────────────                 │
│       [Orchestrator]          [Agent A]───[Agent B]             │
│      /     |      \              \       /                      │
│  [Agent] [Agent] [Agent]          [Agent C]                     │
│                                                                  │
│  3. BLACKBOARD                4. MARKET-BASED                   │
│  ─────────────                ───────────────                   │
│  ┌────────────────┐           [Auctioneer]                      │
│  │   Blackboard   │           /     |     \                     │
│  │   (Shared)     │        [Bid] [Bid] [Bid]                    │
│  └────────────────┘        [Agent][Agent][Agent]                │
│   ▲    ▲    ▲                                                   │
│   │    │    │                                                   │
│  [A]  [B]  [C]                                                  │
│                                                                  │
│  5. SWARM                     6. DEBATE                         │
│  ────────                     ──────────                        │
│  [●] [●] [●] [●]              [Pro Agent] vs [Con Agent]        │
│   [●] [●] [●]                        │                          │
│    [●] [●]                      [Judge Agent]                   │
│  (Emergent behavior)                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎭 Agent Roles and Specialization

```python
from typing import List, Dict, Optional, Callable
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from enum import Enum
import asyncio

class AgentRole(Enum):
    """Standard agent roles in multi-agent systems."""
    ORCHESTRATOR = "orchestrator"
    RESEARCHER = "researcher"
    WRITER = "writer"
    CRITIC = "critic"
    CODER = "coder"
    PLANNER = "planner"
    EXECUTOR = "executor"
    VALIDATOR = "validator"

@dataclass
class AgentCapability:
    """Define what an agent can do."""
    name: str
    description: str
    tools: List[str] = field(default_factory=list)
    domains: List[str] = field(default_factory=list)
    
class BaseAgent(ABC):
    """Base class for all agents in multi-agent system."""
    
    def __init__(
        self,
        name: str,
        role: AgentRole,
        capabilities: List[AgentCapability],
        llm
    ):
        self.name = name
        self.role = role
        self.capabilities = capabilities
        self.llm = llm
        self.message_history = []
    
    @abstractmethod
    async def process_message(self, message: "Message") -> "Message":
        """Process incoming message and generate response."""
        pass
    
    def get_system_prompt(self) -> str:
        """Generate role-specific system prompt."""
        cap_str = "\n".join([
            f"- {c.name}: {c.description}"
            for c in self.capabilities
        ])
        
        return f"""
You are {self.name}, a {self.role.value} agent.

Your capabilities:
{cap_str}

Collaborate with other agents when needed.
Stay focused on your role and expertise.
Communicate clearly and concisely.
"""

@dataclass
class Message:
    """Message passed between agents."""
    sender: str
    receiver: str  # Can be "all" for broadcast
    content: str
    message_type: str = "task"  # task, response, question, feedback
    metadata: Dict = field(default_factory=dict)
    timestamp: float = field(default_factory=lambda: time.time())
```

---

## 🔄 Agent Communication

### Message Passing System

```python
import asyncio
from collections import defaultdict

class MessageBus:
    """Central message bus for agent communication."""
    
    def __init__(self):
        self.agents: Dict[str, BaseAgent] = {}
        self.message_queue: asyncio.Queue = asyncio.Queue()
        self.message_history: List[Message] = []
        self.subscriptions: Dict[str, List[Callable]] = defaultdict(list)
    
    def register_agent(self, agent: BaseAgent):
        """Register an agent to the message bus."""
        self.agents[agent.name] = agent
        print(f"Registered agent: {agent.name} ({agent.role.value})")
    
    async def send_message(self, message: Message):
        """Send a message through the bus."""
        self.message_history.append(message)
        await self.message_queue.put(message)
        
        # Notify subscribers
        for callback in self.subscriptions[message.receiver]:
            await callback(message)
    
    async def broadcast(self, sender: str, content: str, exclude: List[str] = None):
        """Broadcast message to all agents."""
        exclude = exclude or []
        for agent_name in self.agents:
            if agent_name != sender and agent_name not in exclude:
                message = Message(
                    sender=sender,
                    receiver=agent_name,
                    content=content,
                    message_type="broadcast"
                )
                await self.send_message(message)
    
    def subscribe(self, agent_name: str, callback: Callable):
        """Subscribe to messages for an agent."""
        self.subscriptions[agent_name].append(callback)
    
    async def process_messages(self):
        """Main message processing loop."""
        while True:
            message = await self.message_queue.get()
            
            if message.receiver == "all":
                # Broadcast
                for name, agent in self.agents.items():
                    if name != message.sender:
                        response = await agent.process_message(message)
                        if response:
                            await self.send_message(response)
            else:
                # Direct message
                if message.receiver in self.agents:
                    agent = self.agents[message.receiver]
                    response = await agent.process_message(message)
                    if response:
                        await self.send_message(response)


class ConversationProtocol:
    """Structured conversation protocol between agents."""
    
    def __init__(self, message_bus: MessageBus):
        self.bus = message_bus
    
    async def request_response(
        self,
        sender: str,
        receiver: str,
        request: str,
        timeout: float = 30.0
    ) -> Optional[str]:
        """Send request and wait for response."""
        response_event = asyncio.Event()
        response_content = None
        
        async def capture_response(msg: Message):
            nonlocal response_content
            if msg.sender == receiver and msg.receiver == sender:
                response_content = msg.content
                response_event.set()
        
        self.bus.subscribe(sender, capture_response)
        
        await self.bus.send_message(Message(
            sender=sender,
            receiver=receiver,
            content=request,
            message_type="request"
        ))
        
        try:
            await asyncio.wait_for(response_event.wait(), timeout)
            return response_content
        except asyncio.TimeoutError:
            return None
    
    async def negotiate(
        self,
        agents: List[str],
        topic: str,
        max_rounds: int = 5
    ) -> Dict:
        """Multi-agent negotiation protocol."""
        positions = {}
        
        # Initial positions
        for agent in agents:
            position = await self.request_response(
                "system",
                agent,
                f"What is your position on: {topic}?"
            )
            positions[agent] = position
        
        # Negotiation rounds
        for round_num in range(max_rounds):
            all_positions = "\n".join([
                f"{a}: {p}" for a, p in positions.items()
            ])
            
            # Each agent responds to others
            new_positions = {}
            for agent in agents:
                response = await self.request_response(
                    "system",
                    agent,
                    f"""Round {round_num + 1} of negotiation on: {topic}
                    
Current positions:
{all_positions}

Do you agree with a consensus? If not, state your revised position."""
                )
                new_positions[agent] = response
            
            positions = new_positions
            
            # Check for consensus
            if self._check_consensus(positions):
                return {
                    "status": "consensus",
                    "rounds": round_num + 1,
                    "final_positions": positions
                }
        
        return {
            "status": "no_consensus",
            "rounds": max_rounds,
            "final_positions": positions
        }
    
    def _check_consensus(self, positions: Dict) -> bool:
        """Check if agents have reached consensus."""
        # Simple check: look for agreement indicators
        agreement_words = ["agree", "consensus", "accept"]
        
        for position in positions.values():
            if not any(word in position.lower() for word in agreement_words):
                return False
        return True
```

---

## 🏢 Hierarchical Multi-Agent System

```python
class OrchestratorAgent(BaseAgent):
    """
    Master agent that coordinates other agents.
    """
    def __init__(self, name: str, llm, worker_agents: List[BaseAgent]):
        super().__init__(
            name=name,
            role=AgentRole.ORCHESTRATOR,
            capabilities=[
                AgentCapability(
                    "coordination",
                    "Coordinate and delegate tasks to worker agents"
                ),
                AgentCapability(
                    "planning",
                    "Break down complex tasks into subtasks"
                )
            ],
            llm=llm
        )
        self.workers = {a.name: a for a in worker_agents}
        self.task_assignments = {}
    
    async def process_task(self, task: str) -> str:
        """Process a complex task by delegating to workers."""
        
        # 1. Analyze and decompose task
        subtasks = await self._decompose_task(task)
        
        # 2. Assign subtasks to appropriate agents
        assignments = await self._assign_subtasks(subtasks)
        
        # 3. Execute in parallel where possible
        results = await self._execute_assignments(assignments)
        
        # 4. Synthesize results
        final_result = await self._synthesize_results(task, results)
        
        return final_result
    
    async def _decompose_task(self, task: str) -> List[Dict]:
        """Break task into subtasks."""
        worker_info = "\n".join([
            f"- {name}: {agent.role.value}"
            for name, agent in self.workers.items()
        ])
        
        prompt = f"""
        Decompose this task into subtasks:
        
        Task: {task}
        
        Available workers:
        {worker_info}
        
        Return a JSON list of subtasks:
        [
            {{"subtask": "description", "worker": "agent_name", "depends_on": []}}
        ]
        """
        
        response = await self.llm.ainvoke(prompt)
        return json.loads(response.content)
    
    async def _assign_subtasks(self, subtasks: List[Dict]) -> Dict:
        """Assign subtasks to workers."""
        assignments = {}
        for subtask in subtasks:
            worker_name = subtask["worker"]
            if worker_name not in assignments:
                assignments[worker_name] = []
            assignments[worker_name].append(subtask)
        return assignments
    
    async def _execute_assignments(self, assignments: Dict) -> Dict:
        """Execute subtasks, respecting dependencies."""
        results = {}
        completed = set()
        
        while len(completed) < sum(len(tasks) for tasks in assignments.values()):
            # Find tasks that can be executed
            executable = []
            for worker, tasks in assignments.items():
                for task in tasks:
                    task_id = f"{worker}:{task['subtask']}"
                    if task_id in completed:
                        continue
                    
                    # Check dependencies
                    deps_met = all(
                        dep in completed
                        for dep in task.get("depends_on", [])
                    )
                    
                    if deps_met:
                        executable.append((worker, task, task_id))
            
            # Execute in parallel
            coroutines = [
                self._execute_single(worker, task, results)
                for worker, task, _ in executable
            ]
            
            await asyncio.gather(*coroutines)
            
            # Mark completed
            for _, _, task_id in executable:
                completed.add(task_id)
        
        return results
    
    async def _execute_single(
        self,
        worker_name: str,
        task: Dict,
        results: Dict
    ):
        """Execute a single subtask."""
        worker = self.workers[worker_name]
        
        # Add context from dependencies
        context = ""
        for dep in task.get("depends_on", []):
            if dep in results:
                context += f"\nResult from {dep}: {results[dep]}"
        
        message = Message(
            sender=self.name,
            receiver=worker_name,
            content=f"{task['subtask']}\n\nContext:{context}",
            message_type="task"
        )
        
        response = await worker.process_message(message)
        results[f"{worker_name}:{task['subtask']}"] = response.content
    
    async def _synthesize_results(self, original_task: str, results: Dict) -> str:
        """Combine all results into final answer."""
        results_str = "\n\n".join([
            f"## {task_id}\n{result}"
            for task_id, result in results.items()
        ])
        
        prompt = f"""
        Original task: {original_task}
        
        Subtask results:
        {results_str}
        
        Synthesize these results into a coherent final response.
        """
        
        response = await self.llm.ainvoke(prompt)
        return response.content
    
    async def process_message(self, message: Message) -> Message:
        """Handle incoming messages."""
        result = await self.process_task(message.content)
        return Message(
            sender=self.name,
            receiver=message.sender,
            content=result,
            message_type="response"
        )
```

---

## 🤝 Collaborative Agents (CrewAI Style)

```python
from crewai import Agent, Task, Crew, Process

# Define specialized agents
researcher = Agent(
    role='Senior Research Analyst',
    goal='Uncover cutting-edge developments in AI',
    backstory="""You work at a leading tech think tank.
    Your expertise lies in identifying emerging trends.""",
    tools=[search_tool, web_scraper],
    llm=llm,
    verbose=True
)

writer = Agent(
    role='Tech Content Writer',
    goal='Create engaging content about AI developments',
    backstory="""You are a renowned content writer specializing
    in technology and AI topics.""",
    tools=[],
    llm=llm,
    verbose=True
)

critic = Agent(
    role='Quality Assurance Editor',
    goal='Ensure accuracy and quality of content',
    backstory="""You are an experienced editor with an eye
    for detail and factual accuracy.""",
    tools=[],
    llm=llm,
    verbose=True
)

# Define tasks
research_task = Task(
    description="""Conduct comprehensive research on the latest
    AI agent architectures. Focus on:
    - Multi-agent collaboration patterns
    - Communication protocols
    - Real-world applications""",
    expected_output='A detailed report with key findings',
    agent=researcher
)

writing_task = Task(
    description="""Using the research findings, write an
    engaging blog post about multi-agent AI systems.
    Make it accessible to a technical audience.""",
    expected_output='A well-structured blog post',
    agent=writer,
    context=[research_task]  # Depends on research
)

review_task = Task(
    description="""Review the blog post for:
    - Technical accuracy
    - Clarity and readability
    - Grammar and style
    Provide specific feedback and suggestions.""",
    expected_output='Edited post with improvements',
    agent=critic,
    context=[writing_task]
)

# Create and run crew
crew = Crew(
    agents=[researcher, writer, critic],
    tasks=[research_task, writing_task, review_task],
    process=Process.sequential,
    verbose=2
)

result = crew.kickoff()
```

---

## 🗣️ Debate System

```python
class DebateSystem:
    """
    Multi-agent debate for exploring complex topics.
    """
    def __init__(self, llm):
        self.llm = llm
        self.pro_agent = self._create_agent("Pro", "argue for")
        self.con_agent = self._create_agent("Con", "argue against")
        self.judge_agent = self._create_judge()
    
    def _create_agent(self, side: str, stance: str) -> BaseAgent:
        """Create a debate agent."""
        return DebateAgent(
            name=f"{side}Agent",
            stance=stance,
            llm=self.llm
        )
    
    def _create_judge(self) -> BaseAgent:
        """Create the judge agent."""
        return JudgeAgent(
            name="Judge",
            llm=self.llm
        )
    
    async def debate(
        self,
        topic: str,
        rounds: int = 3
    ) -> Dict:
        """Run a structured debate."""
        transcript = []
        
        # Opening statements
        pro_opening = await self.pro_agent.opening_statement(topic)
        con_opening = await self.con_agent.opening_statement(topic)
        
        transcript.append({"type": "opening", "pro": pro_opening, "con": con_opening})
        
        # Debate rounds
        previous_pro = pro_opening
        previous_con = con_opening
        
        for round_num in range(rounds):
            # Pro responds to Con
            pro_response = await self.pro_agent.respond(
                topic, previous_con, round_num + 1
            )
            
            # Con responds to Pro
            con_response = await self.con_agent.respond(
                topic, pro_response, round_num + 1
            )
            
            transcript.append({
                "type": "round",
                "round": round_num + 1,
                "pro": pro_response,
                "con": con_response
            })
            
            previous_pro = pro_response
            previous_con = con_response
        
        # Judge renders verdict
        verdict = await self.judge_agent.evaluate(topic, transcript)
        
        return {
            "topic": topic,
            "transcript": transcript,
            "verdict": verdict
        }


class DebateAgent:
    """Agent that argues one side of a debate."""
    
    def __init__(self, name: str, stance: str, llm):
        self.name = name
        self.stance = stance
        self.llm = llm
    
    async def opening_statement(self, topic: str) -> str:
        """Generate opening argument."""
        prompt = f"""
        You are debating the topic: {topic}
        Your position: {self.stance} this proposition
        
        Present your opening argument in 2-3 paragraphs.
        Use logical reasoning and evidence.
        """
        response = await self.llm.ainvoke(prompt)
        return response.content
    
    async def respond(
        self,
        topic: str,
        opponent_argument: str,
        round_num: int
    ) -> str:
        """Respond to opponent's argument."""
        prompt = f"""
        Debate topic: {topic}
        Your position: {self.stance}
        Round: {round_num}
        
        Opponent's argument:
        {opponent_argument}
        
        Respond by:
        1. Addressing their key points
        2. Providing counter-arguments
        3. Strengthening your position
        
        Keep response to 2-3 paragraphs.
        """
        response = await self.llm.ainvoke(prompt)
        return response.content


class JudgeAgent:
    """Agent that evaluates the debate."""
    
    def __init__(self, name: str, llm):
        self.name = name
        self.llm = llm
    
    async def evaluate(self, topic: str, transcript: List[Dict]) -> Dict:
        """Evaluate the debate and render verdict."""
        formatted = self._format_transcript(transcript)
        
        prompt = f"""
        As an impartial judge, evaluate this debate:
        
        Topic: {topic}
        
        {formatted}
        
        Evaluate based on:
        1. Logical reasoning
        2. Evidence quality
        3. Rebuttal effectiveness
        4. Persuasiveness
        
        Provide:
        - Score for Pro (0-100)
        - Score for Con (0-100)
        - Winner declaration
        - Key reasoning
        """
        
        response = await self.llm.ainvoke(prompt)
        
        # Parse verdict (simplified)
        content = response.content
        return {
            "analysis": content,
            "raw_response": content
        }
    
    def _format_transcript(self, transcript: List[Dict]) -> str:
        """Format transcript for judge review."""
        parts = []
        for entry in transcript:
            if entry["type"] == "opening":
                parts.append(f"## Opening Statements\nPro: {entry['pro']}\nCon: {entry['con']}")
            else:
                parts.append(f"## Round {entry['round']}\nPro: {entry['pro']}\nCon: {entry['con']}")
        return "\n\n".join(parts)
```

---

## 🐝 Swarm Intelligence

```python
class SwarmAgent:
    """
    Agent that participates in swarm-style collaboration.
    """
    def __init__(self, agent_id: int, llm, specialization: str = None):
        self.id = agent_id
        self.llm = llm
        self.specialization = specialization
        self.local_state = {}
        self.neighbors: List['SwarmAgent'] = []
    
    def set_neighbors(self, neighbors: List['SwarmAgent']):
        """Set neighboring agents for local communication."""
        self.neighbors = neighbors
    
    async def local_vote(self, options: List[str], context: str) -> str:
        """Vote on options based on local information."""
        prompt = f"""
        Context: {context}
        
        Vote for the best option:
        {chr(10).join(f'{i+1}. {opt}' for i, opt in enumerate(options))}
        
        Consider your specialization: {self.specialization}
        Return only the number of your choice.
        """
        response = await self.llm.ainvoke(prompt)
        try:
            choice = int(response.content.strip()) - 1
            return options[choice]
        except:
            return options[0]
    
    async def propose_solution(self, problem: str) -> str:
        """Propose a solution to a problem."""
        # Gather neighbor opinions
        neighbor_info = ""
        for neighbor in self.neighbors[:3]:  # Limit to 3 neighbors
            if neighbor.local_state.get("last_proposal"):
                neighbor_info += f"\nNeighbor {neighbor.id}: {neighbor.local_state['last_proposal'][:100]}"
        
        prompt = f"""
        Problem: {problem}
        
        Neighboring agent proposals:{neighbor_info if neighbor_info else " None yet"}
        
        Your specialization: {self.specialization}
        
        Propose your solution, building on good ideas from neighbors.
        """
        
        response = await self.llm.ainvoke(prompt)
        self.local_state["last_proposal"] = response.content
        return response.content


class Swarm:
    """
    Swarm of agents that solve problems collectively.
    """
    def __init__(self, num_agents: int, llm, specializations: List[str] = None):
        self.agents = []
        
        for i in range(num_agents):
            spec = specializations[i % len(specializations)] if specializations else None
            self.agents.append(SwarmAgent(i, llm, spec))
        
        # Create neighbor connections (ring topology)
        for i, agent in enumerate(self.agents):
            left = self.agents[(i - 1) % num_agents]
            right = self.agents[(i + 1) % num_agents]
            agent.set_neighbors([left, right])
    
    async def solve(self, problem: str, iterations: int = 3) -> Dict:
        """Solve problem through swarm collaboration."""
        solutions = []
        
        for iteration in range(iterations):
            # Each agent proposes solution
            proposals = await asyncio.gather(*[
                agent.propose_solution(problem)
                for agent in self.agents
            ])
            
            # Voting round
            votes = await asyncio.gather(*[
                agent.local_vote(proposals, problem)
                for agent in self.agents
            ])
            
            # Count votes
            vote_counts = {}
            for vote in votes:
                vote_counts[vote] = vote_counts.get(vote, 0) + 1
            
            # Find winner
            winner = max(vote_counts, key=vote_counts.get)
            solutions.append({
                "iteration": iteration + 1,
                "winner": winner,
                "votes": vote_counts[winner],
                "total_agents": len(self.agents)
            })
        
        # Final solution is most voted in last iteration
        return {
            "problem": problem,
            "iterations": solutions,
            "final_solution": solutions[-1]["winner"]
        }


# Example usage
async def run_swarm():
    specializations = ["logic", "creativity", "analysis", "synthesis"]
    swarm = Swarm(
        num_agents=8,
        llm=llm,
        specializations=specializations
    )
    
    result = await swarm.solve(
        "Design a sustainable city transportation system",
        iterations=3
    )
    return result
```

---

## 📋 Conflict Resolution

```python
class ConflictResolver:
    """
    Resolve conflicts between agents.
    """
    def __init__(self, llm):
        self.llm = llm
        self.resolution_strategies = {
            "voting": self._voting_resolution,
            "authority": self._authority_resolution,
            "synthesis": self._synthesis_resolution,
            "escalation": self._escalation_resolution
        }
    
    async def resolve(
        self,
        positions: Dict[str, str],  # agent_name -> position
        conflict_type: str,
        strategy: str = "synthesis"
    ) -> Dict:
        """Resolve conflict between agent positions."""
        resolver = self.resolution_strategies.get(strategy, self._synthesis_resolution)
        return await resolver(positions, conflict_type)
    
    async def _voting_resolution(
        self,
        positions: Dict[str, str],
        conflict_type: str
    ) -> Dict:
        """Resolve by voting on positions."""
        position_list = list(positions.values())
        
        # Each agent votes (not for their own)
        votes = {}
        for agent, own_position in positions.items():
            other_positions = [p for a, p in positions.items() if a != agent]
            
            prompt = f"""
            Conflict: {conflict_type}
            
            Vote for the best position (not your own):
            {chr(10).join(f'{i+1}. {p[:200]}' for i, p in enumerate(other_positions))}
            
            Return only the number.
            """
            
            # Simplified: random vote for example
            import random
            vote = random.choice(other_positions)
            votes[vote] = votes.get(vote, 0) + 1
        
        winner = max(votes, key=votes.get)
        return {"resolution": winner, "method": "voting", "votes": votes}
    
    async def _synthesis_resolution(
        self,
        positions: Dict[str, str],
        conflict_type: str
    ) -> Dict:
        """Synthesize a new position from all inputs."""
        positions_str = "\n\n".join([
            f"**{agent}**: {position}"
            for agent, position in positions.items()
        ])
        
        prompt = f"""
        There is a conflict requiring resolution:
        
        Type: {conflict_type}
        
        Different positions:
        {positions_str}
        
        Create a synthesized solution that:
        1. Incorporates the best elements of each position
        2. Addresses the core concerns of all parties
        3. Is practical and actionable
        
        Provide the synthesized resolution.
        """
        
        response = await self.llm.ainvoke(prompt)
        return {
            "resolution": response.content,
            "method": "synthesis",
            "original_positions": positions
        }
    
    async def _authority_resolution(
        self,
        positions: Dict[str, str],
        conflict_type: str
    ) -> Dict:
        """Defer to authority agent."""
        # Assume first agent is authority
        authority = list(positions.keys())[0]
        return {
            "resolution": positions[authority],
            "method": "authority",
            "authority_agent": authority
        }
    
    async def _escalation_resolution(
        self,
        positions: Dict[str, str],
        conflict_type: str
    ) -> Dict:
        """Escalate to higher-level decision maker."""
        return {
            "resolution": None,
            "method": "escalation",
            "message": "Conflict escalated for human decision",
            "positions": positions
        }
```

---

## 📝 Key Takeaways

1. **Architecture Patterns**: Hierarchical, peer-to-peer, blackboard, swarm
2. **Communication**: Message passing, protocols, negotiation
3. **Coordination**: Task decomposition, dependency management
4. **Collaboration**: CrewAI, debate systems, consensus building
5. **Conflict Resolution**: Voting, synthesis, authority, escalation
6. **Emergence**: Swarm intelligence enables emergent behaviors

---

## 🔗 What's Next?

Module 11: **Agent Tools and Functions** - Deep dive into tool design and integration

---

## 📚 Resources

### Frameworks
- [CrewAI](https://github.com/joaomdmoura/crewAI)
- [AutoGen](https://github.com/microsoft/autogen)
- [ChatDev](https://github.com/OpenBMB/ChatDev)

### Papers
- "Generative Agents: Interactive Simulacra of Human Behavior"
- "Communicative Agents for Software Development"

---

*Module 10 Complete. Continue to Module 11: Agent Tools and Functions →*

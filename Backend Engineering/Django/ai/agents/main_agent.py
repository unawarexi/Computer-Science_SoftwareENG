"""
Main Agent
==========
Primary LangGraph-based agent orchestrator.

This module implements the core agent logic using LangGraph for state management
and workflow orchestration. The agent follows the ReAct pattern with support for
tool calling, memory integration, and multi-step reasoning.
"""

import logging
from typing import Annotated, Any, Dict, List, Optional, Sequence, TypedDict
from datetime import datetime

from langchain_core.messages import AIMessage, BaseMessage, HumanMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.tools import BaseTool
from langgraph.graph import END, StateGraph
from langgraph.prebuilt import ToolNode
from langgraph.graph.message import add_messages
from pydantic import BaseModel, Field

from django.conf import settings

from ai.models.llm_router import LLMRouter
from ai.memory.short_term import ConversationMemory
from ai.memory.long_term import LongTermMemory
from ai.tools import get_default_tools
from ai.agents.policies import PolicyEngine

logger = logging.getLogger("ai.agents")


# =============================================================================
# STATE DEFINITIONS
# =============================================================================

class AgentState(TypedDict):
    """State managed throughout the agent's execution."""
    messages: Annotated[Sequence[BaseMessage], add_messages]
    current_task: Optional[str]
    plan: Optional[List[str]]
    plan_step: int
    tool_results: List[Dict[str, Any]]
    metadata: Dict[str, Any]
    should_continue: bool
    iteration_count: int


class AgentConfig(BaseModel):
    """Configuration for agent behavior."""
    model: str = Field(default="gpt-4o")
    temperature: float = Field(default=0.7, ge=0, le=2)
    max_iterations: int = Field(default=10, ge=1, le=50)
    timeout_seconds: int = Field(default=120)
    verbose: bool = Field(default=True)
    use_memory: bool = Field(default=True)
    use_planning: bool = Field(default=True)


# =============================================================================
# MAIN AGENT CLASS
# =============================================================================

class MainAgent:
    """
    Primary AI agent using LangGraph for orchestration.
    
    Implements a ReAct-style agent with:
    - Multi-step reasoning
    - Tool calling
    - Memory integration (short-term and long-term)
    - Planning capabilities
    - Policy enforcement
    
    Example:
        agent = MainAgent()
        result = await agent.run("Search for the latest AI news and summarize")
    """
    
    def __init__(
        self,
        config: Optional[AgentConfig] = None,
        tools: Optional[List[BaseTool]] = None,
        system_prompt: Optional[str] = None,
    ):
        """
        Initialize the main agent.
        
        Args:
            config: Agent configuration options
            tools: List of tools available to the agent
            system_prompt: Custom system prompt override
        """
        self.config = config or AgentConfig()
        self.llm = LLMRouter.get_model(
            model=self.config.model,
            temperature=self.config.temperature,
        )
        self.tools = tools or get_default_tools()
        self.policy_engine = PolicyEngine()
        
        # Memory systems
        self.conversation_memory = ConversationMemory()
        self.long_term_memory = LongTermMemory() if self.config.use_memory else None
        
        # System prompt
        self.system_prompt = system_prompt or self._get_default_system_prompt()
        
        # Build the graph
        self.graph = self._build_graph()
        self.app = self.graph.compile()
        
        logger.info(f"MainAgent initialized with model={self.config.model}")
    
    def _get_default_system_prompt(self) -> str:
        """Get the default system prompt."""
        return """You are an advanced AI assistant with access to various tools.

Your capabilities:
- Search the web for current information
- Execute code and calculations
- Query databases
- Access external APIs

Guidelines:
1. Think step-by-step before taking action
2. Use tools when you need external information or capabilities
3. Be concise but thorough in your responses
4. If unsure, ask for clarification
5. Always cite sources when providing factual information

Current date: {date}
"""
    
    def _build_graph(self) -> StateGraph:
        """Build the LangGraph state machine."""
        # Create the graph
        graph = StateGraph(AgentState)
        
        # Add nodes
        graph.add_node("agent", self._agent_node)
        graph.add_node("tools", ToolNode(self.tools))
        graph.add_node("planner", self._planner_node)
        graph.add_node("reflector", self._reflector_node)
        
        # Set entry point
        graph.set_entry_point("planner" if self.config.use_planning else "agent")
        
        # Add edges
        if self.config.use_planning:
            graph.add_edge("planner", "agent")
        
        graph.add_conditional_edges(
            "agent",
            self._should_continue,
            {
                "continue": "tools",
                "reflect": "reflector",
                "end": END,
            }
        )
        
        graph.add_edge("tools", "agent")
        graph.add_edge("reflector", "agent")
        
        return graph
    
    async def _agent_node(self, state: AgentState) -> Dict[str, Any]:
        """Main agent reasoning node."""
        messages = state["messages"]
        iteration = state.get("iteration_count", 0)
        
        # Check iteration limit
        if iteration >= self.config.max_iterations:
            logger.warning(f"Max iterations ({self.config.max_iterations}) reached")
            return {
                "messages": [AIMessage(content="I've reached my maximum reasoning steps. Here's what I found so far...")],
                "should_continue": False,
                "iteration_count": iteration + 1,
            }
        
        # Prepare messages with system prompt
        system_message = SystemMessage(
            content=self.system_prompt.format(date=datetime.now().strftime("%Y-%m-%d"))
        )
        
        # Add relevant memories if enabled
        if self.long_term_memory:
            relevant_memories = await self.long_term_memory.retrieve(
                query=messages[-1].content if messages else "",
                k=3
            )
            if relevant_memories:
                memory_context = "\n".join([f"- {m}" for m in relevant_memories])
                system_message = SystemMessage(
                    content=f"{self.system_prompt}\n\nRelevant context from memory:\n{memory_context}"
                )
        
        # Bind tools to LLM
        llm_with_tools = self.llm.bind_tools(self.tools)
        
        # Invoke LLM
        response = await llm_with_tools.ainvoke([system_message] + list(messages))
        
        # Log for debugging
        if self.config.verbose:
            logger.debug(f"Agent response: {response.content[:200]}...")
        
        return {
            "messages": [response],
            "iteration_count": iteration + 1,
        }
    
    async def _planner_node(self, state: AgentState) -> Dict[str, Any]:
        """Planning node for task decomposition."""
        messages = state["messages"]
        
        if not messages:
            return state
        
        user_query = messages[-1].content if messages else ""
        
        # Create planning prompt
        planning_prompt = f"""Analyze this task and create a step-by-step plan:

Task: {user_query}

Create a concise plan (3-5 steps) to accomplish this task.
Format: Return a numbered list of steps.
"""
        
        # Get plan from LLM
        response = await self.llm.ainvoke([HumanMessage(content=planning_prompt)])
        
        # Parse plan into steps
        plan_text = response.content
        plan_steps = [
            line.strip() for line in plan_text.split("\n")
            if line.strip() and (line.strip()[0].isdigit() or line.strip().startswith("-"))
        ]
        
        logger.info(f"Generated plan with {len(plan_steps)} steps")
        
        return {
            "plan": plan_steps,
            "plan_step": 0,
            "current_task": user_query,
        }
    
    async def _reflector_node(self, state: AgentState) -> Dict[str, Any]:
        """Reflection node for self-evaluation and improvement."""
        messages = state["messages"]
        tool_results = state.get("tool_results", [])
        
        # Create reflection prompt
        reflection_prompt = f"""Reflect on your recent actions and results:

Recent tool results: {tool_results[-3:] if tool_results else 'None'}

Questions to consider:
1. Are you making progress toward the goal?
2. Should you try a different approach?
3. Do you have enough information to answer?

Provide a brief reflection and next steps.
"""
        
        response = await self.llm.ainvoke([
            SystemMessage(content="You are reflecting on your progress."),
            HumanMessage(content=reflection_prompt)
        ])
        
        return {
            "messages": [AIMessage(content=f"[Reflection] {response.content}")],
        }
    
    def _should_continue(self, state: AgentState) -> str:
        """Determine next step based on state."""
        messages = state["messages"]
        iteration = state.get("iteration_count", 0)
        
        if not messages:
            return "end"
        
        last_message = messages[-1]
        
        # Check if LLM wants to use tools
        if hasattr(last_message, "tool_calls") and last_message.tool_calls:
            return "continue"
        
        # Check if we should reflect (every 3 iterations)
        if iteration > 0 and iteration % 3 == 0 and iteration < self.config.max_iterations - 1:
            return "reflect"
        
        # Otherwise end
        return "end"
    
    async def run(
        self,
        query: str,
        session_id: Optional[str] = None,
        metadata: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Run the agent on a user query.
        
        Args:
            query: User's input query
            session_id: Optional session ID for memory continuity
            metadata: Additional metadata to pass through
            
        Returns:
            Dict containing the response and execution metadata
        """
        # Policy check
        policy_result = await self.policy_engine.check(query)
        if not policy_result.allowed:
            return {
                "response": policy_result.message,
                "blocked": True,
                "reason": policy_result.reason,
            }
        
        # Add to conversation memory
        self.conversation_memory.add_message("user", query)
        
        # Initialize state
        initial_state: AgentState = {
            "messages": [HumanMessage(content=query)],
            "current_task": query,
            "plan": None,
            "plan_step": 0,
            "tool_results": [],
            "metadata": metadata or {},
            "should_continue": True,
            "iteration_count": 0,
        }
        
        # Run the graph
        try:
            result = await self.app.ainvoke(initial_state)
            
            # Extract final response
            final_message = result["messages"][-1]
            response_content = final_message.content
            
            # Add to memory
            self.conversation_memory.add_message("assistant", response_content)
            
            # Store in long-term memory if significant
            if self.long_term_memory:
                await self.long_term_memory.store(
                    content=f"Q: {query}\nA: {response_content}",
                    metadata={"session_id": session_id, "timestamp": datetime.now().isoformat()}
                )
            
            return {
                "response": response_content,
                "iterations": result.get("iteration_count", 0),
                "plan": result.get("plan"),
                "tool_results": result.get("tool_results", []),
                "blocked": False,
            }
            
        except Exception as e:
            logger.error(f"Agent execution error: {e}")
            return {
                "response": f"I encountered an error: {str(e)}",
                "error": str(e),
                "blocked": False,
            }
    
    def get_conversation_history(self) -> List[Dict[str, str]]:
        """Get the current conversation history."""
        return self.conversation_memory.get_context()


# =============================================================================
# AGENT EXECUTOR (Simplified interface)
# =============================================================================

class AgentExecutor:
    """
    Simplified executor for running agents.
    
    Provides a clean interface for executing agent tasks without
    needing to manage the full agent lifecycle.
    """
    
    _instance: Optional[MainAgent] = None
    
    @classmethod
    def get_agent(cls) -> MainAgent:
        """Get or create the singleton agent instance."""
        if cls._instance is None:
            cls._instance = MainAgent()
        return cls._instance
    
    @classmethod
    async def execute(
        cls,
        query: str,
        session_id: Optional[str] = None,
        **kwargs
    ) -> Dict[str, Any]:
        """
        Execute a query using the agent.
        
        Args:
            query: The user's query
            session_id: Optional session identifier
            **kwargs: Additional arguments passed to agent.run()
            
        Returns:
            Agent response dictionary
        """
        agent = cls.get_agent()
        return await agent.run(query, session_id=session_id, **kwargs)
    
    @classmethod
    def reset(cls):
        """Reset the agent instance."""
        cls._instance = None

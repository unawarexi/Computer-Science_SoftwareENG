"""
Task Planner
============
Task decomposition and planning logic for complex multi-step tasks.

This module implements hierarchical task planning using LLMs to break down
complex user requests into manageable subtasks with dependencies.
"""

import logging
from typing import Any, Dict, List, Optional
from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field
from langchain_core.messages import HumanMessage, SystemMessage

from ai.models.llm_router import LLMRouter

logger = logging.getLogger("ai.agents.planner")


# =============================================================================
# DATA MODELS
# =============================================================================

class TaskStatus(str, Enum):
    """Status of a task or subtask."""
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"
    BLOCKED = "blocked"


class SubTask(BaseModel):
    """A single subtask in a plan."""
    id: str
    title: str
    description: str
    status: TaskStatus = TaskStatus.PENDING
    dependencies: List[str] = Field(default_factory=list)
    assigned_tool: Optional[str] = None
    result: Optional[str] = None
    error: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.now)
    completed_at: Optional[datetime] = None
    
    def mark_completed(self, result: str):
        """Mark the subtask as completed."""
        self.status = TaskStatus.COMPLETED
        self.result = result
        self.completed_at = datetime.now()
    
    def mark_failed(self, error: str):
        """Mark the subtask as failed."""
        self.status = TaskStatus.FAILED
        self.error = error
        self.completed_at = datetime.now()


class Plan(BaseModel):
    """A complete execution plan."""
    id: str
    goal: str
    subtasks: List[SubTask] = Field(default_factory=list)
    status: TaskStatus = TaskStatus.PENDING
    created_at: datetime = Field(default_factory=datetime.now)
    completed_at: Optional[datetime] = None
    
    def get_next_task(self) -> Optional[SubTask]:
        """Get the next task that can be executed."""
        for task in self.subtasks:
            if task.status == TaskStatus.PENDING:
                # Check if all dependencies are completed
                deps_completed = all(
                    self._get_task(dep_id).status == TaskStatus.COMPLETED
                    for dep_id in task.dependencies
                    if self._get_task(dep_id)
                )
                if deps_completed:
                    return task
        return None
    
    def _get_task(self, task_id: str) -> Optional[SubTask]:
        """Get a subtask by ID."""
        for task in self.subtasks:
            if task.id == task_id:
                return task
        return None
    
    def is_complete(self) -> bool:
        """Check if the plan is complete."""
        return all(
            task.status in [TaskStatus.COMPLETED, TaskStatus.FAILED]
            for task in self.subtasks
        )
    
    def get_progress(self) -> float:
        """Get plan completion percentage."""
        if not self.subtasks:
            return 0.0
        completed = sum(1 for t in self.subtasks if t.status == TaskStatus.COMPLETED)
        return completed / len(self.subtasks)


# =============================================================================
# TASK PLANNER
# =============================================================================

class TaskPlanner:
    """
    Hierarchical task planner for complex goals.
    
    Uses LLMs to decompose complex tasks into subtasks with:
    - Clear dependencies between tasks
    - Tool assignments for each subtask
    - Parallel execution where possible
    
    Example:
        planner = TaskPlanner()
        plan = await planner.create_plan("Research and write a report on AI trends")
        
        while not plan.is_complete():
            task = plan.get_next_task()
            result = await execute_task(task)
            task.mark_completed(result)
    """
    
    def __init__(self, model: str = "gpt-4o"):
        """Initialize the task planner."""
        self.llm = LLMRouter.get_model(model=model, temperature=0.3)
        self.available_tools = self._get_available_tools()
    
    def _get_available_tools(self) -> List[str]:
        """Get list of available tool names."""
        return [
            "web_search",
            "code_execution",
            "database_query",
            "file_operations",
            "http_request",
            "calculator",
        ]
    
    async def create_plan(
        self,
        goal: str,
        context: Optional[str] = None,
        max_subtasks: int = 10,
    ) -> Plan:
        """
        Create an execution plan for a goal.
        
        Args:
            goal: The high-level goal to accomplish
            context: Additional context about the task
            max_subtasks: Maximum number of subtasks to generate
            
        Returns:
            A Plan object with decomposed subtasks
        """
        # Create planning prompt
        system_prompt = """You are an expert task planner. Your job is to decompose complex goals into clear, actionable subtasks.

Available tools:
- web_search: Search the internet for information
- code_execution: Execute Python code
- database_query: Query databases
- file_operations: Read/write files
- http_request: Make HTTP API calls
- calculator: Perform calculations

Rules:
1. Each subtask should be atomic and clearly defined
2. Specify dependencies between tasks (which tasks must complete first)
3. Assign the most appropriate tool to each task
4. Keep the plan concise (max {max_tasks} subtasks)
5. Tasks that can run in parallel should not have dependencies on each other
""".format(max_tasks=max_subtasks)

        user_prompt = f"""Create a plan for this goal:

Goal: {goal}
{f'Context: {context}' if context else ''}

Return a JSON array of subtasks with this structure:
[
    {{
        "id": "task_1",
        "title": "Short task title",
        "description": "Detailed description of what to do",
        "dependencies": [],  // IDs of tasks that must complete first
        "assigned_tool": "tool_name"  // One of the available tools
    }}
]
"""

        # Get plan from LLM
        response = await self.llm.ainvoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=user_prompt)
        ])
        
        # Parse response
        import json
        try:
            # Extract JSON from response
            content = response.content
            # Find JSON array in response
            start = content.find("[")
            end = content.rfind("]") + 1
            if start >= 0 and end > start:
                tasks_data = json.loads(content[start:end])
            else:
                tasks_data = []
        except json.JSONDecodeError:
            logger.error(f"Failed to parse plan JSON: {response.content}")
            tasks_data = []
        
        # Create subtasks
        subtasks = []
        for task_data in tasks_data[:max_subtasks]:
            subtask = SubTask(
                id=task_data.get("id", f"task_{len(subtasks)+1}"),
                title=task_data.get("title", "Untitled task"),
                description=task_data.get("description", ""),
                dependencies=task_data.get("dependencies", []),
                assigned_tool=task_data.get("assigned_tool"),
            )
            subtasks.append(subtask)
        
        # Create plan
        plan = Plan(
            id=f"plan_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
            goal=goal,
            subtasks=subtasks,
        )
        
        logger.info(f"Created plan with {len(subtasks)} subtasks for: {goal[:50]}...")
        
        return plan
    
    async def refine_plan(
        self,
        plan: Plan,
        feedback: str,
    ) -> Plan:
        """
        Refine an existing plan based on feedback.
        
        Args:
            plan: The existing plan to refine
            feedback: Feedback about what needs to change
            
        Returns:
            Updated plan
        """
        prompt = f"""Current plan for goal: {plan.goal}

Subtasks:
{self._format_subtasks(plan.subtasks)}

Feedback: {feedback}

Provide an updated list of subtasks addressing the feedback.
Return JSON array format.
"""

        response = await self.llm.ainvoke([
            SystemMessage(content="You are refining a task plan based on feedback."),
            HumanMessage(content=prompt)
        ])
        
        # Parse and update plan
        # (Similar parsing logic as create_plan)
        
        return plan
    
    def _format_subtasks(self, subtasks: List[SubTask]) -> str:
        """Format subtasks for display."""
        lines = []
        for task in subtasks:
            deps = f" (depends on: {', '.join(task.dependencies)})" if task.dependencies else ""
            lines.append(f"- [{task.id}] {task.title}{deps}")
        return "\n".join(lines)


# =============================================================================
# PLAN EXECUTOR
# =============================================================================

class PlanExecutor:
    """
    Executes plans by running subtasks with appropriate tools.
    """
    
    def __init__(self, tool_registry: Optional[Dict] = None):
        """Initialize the plan executor."""
        self.tool_registry = tool_registry or {}
    
    async def execute_plan(
        self,
        plan: Plan,
        on_task_complete: Optional[callable] = None,
    ) -> Dict[str, Any]:
        """
        Execute all subtasks in a plan.
        
        Args:
            plan: The plan to execute
            on_task_complete: Callback when each task completes
            
        Returns:
            Dictionary with results from all tasks
        """
        results = {}
        
        while not plan.is_complete():
            task = plan.get_next_task()
            
            if not task:
                # No tasks ready - might be blocked
                blocked = [t for t in plan.subtasks if t.status == TaskStatus.PENDING]
                if blocked:
                    logger.warning(f"Plan blocked. {len(blocked)} tasks cannot proceed.")
                break
            
            task.status = TaskStatus.IN_PROGRESS
            
            try:
                result = await self._execute_task(task, results)
                task.mark_completed(result)
                results[task.id] = result
                
                if on_task_complete:
                    await on_task_complete(task)
                    
            except Exception as e:
                task.mark_failed(str(e))
                results[task.id] = {"error": str(e)}
                logger.error(f"Task {task.id} failed: {e}")
        
        plan.status = TaskStatus.COMPLETED if plan.is_complete() else TaskStatus.FAILED
        plan.completed_at = datetime.now()
        
        return {
            "plan_id": plan.id,
            "goal": plan.goal,
            "status": plan.status,
            "results": results,
            "progress": plan.get_progress(),
        }
    
    async def _execute_task(
        self,
        task: SubTask,
        previous_results: Dict[str, Any],
    ) -> str:
        """Execute a single subtask."""
        tool_name = task.assigned_tool
        
        if tool_name and tool_name in self.tool_registry:
            tool = self.tool_registry[tool_name]
            # Prepare context from dependencies
            context = {
                dep_id: previous_results.get(dep_id)
                for dep_id in task.dependencies
            }
            result = await tool.execute(task.description, context=context)
            return result
        else:
            # No specific tool - use LLM
            llm = LLMRouter.get_model()
            response = await llm.ainvoke([
                HumanMessage(content=f"Complete this task: {task.description}")
            ])
            return response.content

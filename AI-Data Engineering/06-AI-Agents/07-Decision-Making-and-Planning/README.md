# 🎯 Module 07: Decision Making and Planning

## Overview

This module covers how AI agents make decisions, create plans, and handle uncertainty. You'll learn algorithms and patterns for effective agent reasoning and execution.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** decision-making frameworks for agents
2. **Implement** planning algorithms and patterns
3. **Handle** uncertainty and partial information
4. **Design** adaptive planning systems
5. **Optimize** decision quality and efficiency

---

## 📚 Prerequisites

- Module 05: Understanding AI Agents
- Module 06: Memory and Knowledge Retrieval
- Basic understanding of search algorithms

---

## 🧭 Decision-Making Frameworks

```
┌─────────────────────────────────────────────────────────────────┐
│                 DECISION-MAKING LANDSCAPE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  REACTIVE                  │  DELIBERATIVE                      │
│  ────────                  │  ────────────                      │
│  • Stimulus-response       │  • Plan-based                      │
│  • Fast, simple            │  • Goal-oriented                   │
│  • No lookahead            │  • Considers future                │
│                                                                  │
│  UTILITY-BASED             │  LEARNING-BASED                    │
│  ─────────────             │  ──────────────                    │
│  • Maximize value          │  • Improve over time               │
│  • Handle trade-offs       │  • Experience-driven               │
│  • Probabilistic           │  • Adaptive                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📋 Hierarchical Planning

### Goal Decomposition

```python
from typing import List, Dict, Optional
from dataclasses import dataclass
from enum import Enum

class GoalStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"
    BLOCKED = "blocked"

@dataclass
class Goal:
    id: str
    description: str
    status: GoalStatus = GoalStatus.PENDING
    parent_id: Optional[str] = None
    dependencies: List[str] = None
    priority: int = 5  # 1-10, higher is more important
    estimated_complexity: str = "medium"  # low, medium, high

class HierarchicalPlanner:
    """
    Decomposes high-level goals into actionable subgoals.
    """
    def __init__(self, llm):
        self.llm = llm
        self.goals: Dict[str, Goal] = {}
    
    def decompose_goal(self, goal: Goal, max_depth: int = 3) -> List[Goal]:
        """Recursively decompose a goal into subgoals."""
        if max_depth <= 0 or goal.estimated_complexity == "low":
            return [goal]
        
        prompt = f"""
        Break down this goal into smaller, actionable subgoals:
        
        Goal: {goal.description}
        Complexity: {goal.estimated_complexity}
        
        Requirements:
        - Each subgoal should be specific and measurable
        - List dependencies between subgoals
        - Estimate complexity (low/medium/high)
        - Order by execution priority
        
        Format each subgoal as:
        SUBGOAL: [description]
        COMPLEXITY: [low/medium/high]
        DEPENDS_ON: [comma-separated subgoal numbers, or "none"]
        """
        
        response = self.llm.invoke(prompt)
        subgoals = self._parse_subgoals(response.content, goal.id)
        
        # Recursively decompose complex subgoals
        all_goals = []
        for subgoal in subgoals:
            if subgoal.estimated_complexity != "low":
                nested = self.decompose_goal(subgoal, max_depth - 1)
                all_goals.extend(nested)
            else:
                all_goals.append(subgoal)
        
        return all_goals
    
    def create_execution_plan(self, goals: List[Goal]) -> List[List[Goal]]:
        """Create an ordered execution plan respecting dependencies."""
        # Build dependency graph
        remaining = {g.id: g for g in goals}
        completed = set()
        plan = []
        
        while remaining:
            # Find goals with satisfied dependencies
            ready = []
            for goal_id, goal in remaining.items():
                deps = goal.dependencies or []
                if all(d in completed for d in deps):
                    ready.append(goal)
            
            if not ready:
                # Circular dependency or missing goals
                raise ValueError("Cannot resolve dependencies")
            
            # Sort ready goals by priority
            ready.sort(key=lambda g: -g.priority)
            
            # Add to plan (can be parallelized)
            plan.append(ready)
            
            # Mark as completed
            for goal in ready:
                completed.add(goal.id)
                del remaining[goal.id]
        
        return plan
    
    def _parse_subgoals(self, text: str, parent_id: str) -> List[Goal]:
        """Parse subgoals from LLM response."""
        import uuid
        subgoals = []
        current_subgoal = {}
        
        for line in text.split('\n'):
            line = line.strip()
            if line.startswith('SUBGOAL:'):
                if current_subgoal:
                    subgoals.append(self._create_goal(current_subgoal, parent_id))
                current_subgoal = {'description': line.split(':', 1)[1].strip()}
            elif line.startswith('COMPLEXITY:'):
                current_subgoal['complexity'] = line.split(':', 1)[1].strip().lower()
            elif line.startswith('DEPENDS_ON:'):
                deps = line.split(':', 1)[1].strip()
                current_subgoal['depends'] = [] if deps.lower() == 'none' else deps.split(',')
        
        if current_subgoal:
            subgoals.append(self._create_goal(current_subgoal, parent_id))
        
        return subgoals
    
    def _create_goal(self, data: Dict, parent_id: str) -> Goal:
        import uuid
        return Goal(
            id=str(uuid.uuid4())[:8],
            description=data.get('description', ''),
            parent_id=parent_id,
            dependencies=data.get('depends', []),
            estimated_complexity=data.get('complexity', 'medium')
        )
```

### Plan Execution Engine

```python
from typing import Callable, Any
from datetime import datetime

class PlanExecutor:
    """
    Executes plans with monitoring and adaptation.
    """
    def __init__(self, llm, tool_executor: Callable):
        self.llm = llm
        self.tool_executor = tool_executor
        self.execution_history = []
    
    def execute_plan(
        self,
        plan: List[List[Goal]],
        on_step_complete: Callable = None
    ) -> Dict:
        """Execute a plan with progress tracking."""
        results = {
            "completed": [],
            "failed": [],
            "total_steps": sum(len(stage) for stage in plan)
        }
        
        for stage_idx, stage in enumerate(plan):
            print(f"\n=== Stage {stage_idx + 1} ===")
            
            # Execute goals in this stage (could be parallel)
            for goal in stage:
                try:
                    result = self._execute_goal(goal)
                    goal.status = GoalStatus.COMPLETED
                    results["completed"].append({
                        "goal": goal,
                        "result": result,
                        "timestamp": datetime.now()
                    })
                    
                    if on_step_complete:
                        on_step_complete(goal, result)
                        
                except Exception as e:
                    goal.status = GoalStatus.FAILED
                    results["failed"].append({
                        "goal": goal,
                        "error": str(e),
                        "timestamp": datetime.now()
                    })
                    
                    # Attempt recovery
                    recovery = self._attempt_recovery(goal, e, results)
                    if not recovery:
                        # Replan if critical failure
                        new_plan = self._replan(plan, stage_idx, goal, results)
                        if new_plan:
                            return self.execute_plan(new_plan, on_step_complete)
        
        return results
    
    def _execute_goal(self, goal: Goal) -> str:
        """Execute a single goal."""
        goal.status = GoalStatus.IN_PROGRESS
        
        # Generate action plan for this specific goal
        prompt = f"""
        Execute this task:
        {goal.description}
        
        Available tools: search, calculate, write_file, read_file, execute_code
        
        Return the action to take and any required parameters.
        """
        
        action = self.llm.invoke(prompt).content
        result = self.tool_executor(action)
        
        self.execution_history.append({
            "goal": goal.description,
            "action": action,
            "result": result
        })
        
        return result
    
    def _attempt_recovery(self, goal: Goal, error: Exception, results: Dict) -> bool:
        """Try to recover from a failed goal."""
        prompt = f"""
        A task failed. Can we recover?
        
        Task: {goal.description}
        Error: {str(error)}
        
        Previous successful steps:
        {[r['goal'].description for r in results['completed']]}
        
        Options:
        1. RETRY - Try the same approach again
        2. ALTERNATIVE - Try a different approach
        3. SKIP - Skip this task if non-critical
        4. ABORT - Cannot continue
        
        Respond with your choice and explanation.
        """
        
        response = self.llm.invoke(prompt).content
        
        if "RETRY" in response:
            try:
                result = self._execute_goal(goal)
                goal.status = GoalStatus.COMPLETED
                results["completed"].append({"goal": goal, "result": result})
                return True
            except:
                pass
        elif "SKIP" in response:
            return True
        
        return False
    
    def _replan(
        self,
        original_plan: List[List[Goal]],
        failed_stage: int,
        failed_goal: Goal,
        results: Dict
    ) -> Optional[List[List[Goal]]]:
        """Create a new plan after failure."""
        completed = [r["goal"].description for r in results["completed"]]
        remaining = []
        for stage in original_plan[failed_stage:]:
            for goal in stage:
                if goal.status == GoalStatus.PENDING:
                    remaining.append(goal.description)
        
        prompt = f"""
        The original plan failed. Create a new plan.
        
        Failed task: {failed_goal.description}
        
        Already completed:
        {completed}
        
        Remaining tasks:
        {remaining}
        
        How should we proceed? Provide an alternative approach.
        """
        
        response = self.llm.invoke(prompt)
        # Parse new plan (simplified)
        return None  # Would implement proper parsing
```

---

## 🎲 Decision Under Uncertainty

```python
import numpy as np
from typing import List, Tuple
from dataclasses import dataclass

@dataclass
class Action:
    name: str
    description: str
    estimated_success_rate: float
    estimated_cost: float  # Time, resources, etc.
    potential_outcomes: List[Tuple[str, float]]  # (outcome, probability)

class DecisionMaker:
    """
    Makes decisions considering uncertainty and multiple factors.
    """
    def __init__(self, llm, risk_tolerance: float = 0.5):
        self.llm = llm
        self.risk_tolerance = risk_tolerance  # 0 = risk-averse, 1 = risk-seeking
    
    def evaluate_options(
        self,
        situation: str,
        options: List[str]
    ) -> List[Action]:
        """Evaluate possible actions for a situation."""
        prompt = f"""
        Situation: {situation}
        
        Possible options:
        {chr(10).join(f'{i+1}. {opt}' for i, opt in enumerate(options))}
        
        For each option, estimate:
        1. Success probability (0-100%)
        2. Resource cost (low/medium/high)
        3. Possible outcomes with probabilities
        
        Format:
        OPTION: [name]
        SUCCESS_RATE: [percentage]
        COST: [low/medium/high]
        OUTCOMES:
        - [outcome1]: [probability]%
        - [outcome2]: [probability]%
        """
        
        response = self.llm.invoke(prompt)
        return self._parse_actions(response.content, options)
    
    def calculate_expected_value(self, action: Action) -> float:
        """Calculate expected value of an action."""
        if not action.potential_outcomes:
            return action.estimated_success_rate
        
        # Weight outcomes by probability
        ev = sum(
            self._outcome_value(outcome) * prob
            for outcome, prob in action.potential_outcomes
        )
        
        # Adjust for cost
        cost_multiplier = {"low": 1.0, "medium": 0.8, "high": 0.6}
        cost_factor = cost_multiplier.get(str(action.estimated_cost), 0.7)
        
        return ev * cost_factor
    
    def _outcome_value(self, outcome: str) -> float:
        """Estimate value of an outcome description."""
        positive_indicators = ["success", "complete", "achieve", "good", "excellent"]
        negative_indicators = ["fail", "error", "problem", "bad", "risk"]
        
        outcome_lower = outcome.lower()
        pos_score = sum(1 for p in positive_indicators if p in outcome_lower)
        neg_score = sum(1 for n in negative_indicators if n in outcome_lower)
        
        return (pos_score - neg_score + 5) / 10  # Normalize to 0-1
    
    def decide(
        self,
        situation: str,
        options: List[str],
        criteria: Dict[str, float] = None
    ) -> Action:
        """Make a decision considering multiple factors."""
        # Default criteria weights
        if criteria is None:
            criteria = {
                "success_probability": 0.4,
                "expected_value": 0.3,
                "cost_efficiency": 0.2,
                "risk_adjusted": 0.1
            }
        
        actions = self.evaluate_options(situation, options)
        
        # Score each action
        scored_actions = []
        for action in actions:
            scores = {
                "success_probability": action.estimated_success_rate,
                "expected_value": self.calculate_expected_value(action),
                "cost_efficiency": 1 - {"low": 0.2, "medium": 0.5, "high": 0.8}.get(
                    str(action.estimated_cost), 0.5
                ),
                "risk_adjusted": self._risk_adjusted_score(action)
            }
            
            total_score = sum(
                scores[c] * weight
                for c, weight in criteria.items()
            )
            
            scored_actions.append((action, total_score))
        
        # Return highest scored action
        scored_actions.sort(key=lambda x: -x[1])
        return scored_actions[0][0]
    
    def _risk_adjusted_score(self, action: Action) -> float:
        """Calculate risk-adjusted score based on agent's risk tolerance."""
        base_score = action.estimated_success_rate
        
        # Calculate variance in outcomes
        if action.potential_outcomes:
            values = [self._outcome_value(o) for o, _ in action.potential_outcomes]
            variance = np.var(values)
        else:
            variance = 0.1
        
        # Risk-averse: penalize variance, Risk-seeking: reward potential upside
        risk_adjustment = variance * (self.risk_tolerance - 0.5)
        
        return base_score + risk_adjustment
    
    def _parse_actions(self, text: str, options: List[str]) -> List[Action]:
        """Parse actions from LLM response."""
        actions = []
        current = {}
        
        for line in text.split('\n'):
            line = line.strip()
            if line.startswith('OPTION:'):
                if current:
                    actions.append(self._build_action(current))
                current = {'name': line.split(':', 1)[1].strip()}
            elif line.startswith('SUCCESS_RATE:'):
                rate = line.split(':', 1)[1].strip().replace('%', '')
                try:
                    current['success_rate'] = float(rate) / 100
                except:
                    current['success_rate'] = 0.5
            elif line.startswith('COST:'):
                current['cost'] = line.split(':', 1)[1].strip().lower()
            elif line.startswith('-') and ':' in line:
                if 'outcomes' not in current:
                    current['outcomes'] = []
                parts = line[1:].split(':')
                if len(parts) == 2:
                    outcome = parts[0].strip()
                    try:
                        prob = float(parts[1].strip().replace('%', '')) / 100
                    except:
                        prob = 0.5
                    current['outcomes'].append((outcome, prob))
        
        if current:
            actions.append(self._build_action(current))
        
        return actions
    
    def _build_action(self, data: Dict) -> Action:
        return Action(
            name=data.get('name', 'Unknown'),
            description=data.get('name', ''),
            estimated_success_rate=data.get('success_rate', 0.5),
            estimated_cost=data.get('cost', 'medium'),
            potential_outcomes=data.get('outcomes', [])
        )
```

---

## 🔄 Adaptive Planning

```python
class AdaptivePlanner:
    """
    Plans that adapt based on feedback and changing conditions.
    """
    def __init__(self, llm, memory_system):
        self.llm = llm
        self.memory = memory_system
        self.feedback_history = []
    
    def create_adaptive_plan(
        self,
        objective: str,
        constraints: List[str] = None
    ) -> Dict:
        """Create a plan with built-in adaptation points."""
        # Get relevant past experiences
        similar_plans = self.memory.semantic_memory.retrieve(
            f"plan for {objective}",
            memory_type="plan"
        )
        
        lessons = self._extract_lessons(similar_plans)
        
        prompt = f"""
        Create an adaptive plan for:
        {objective}
        
        Constraints:
        {constraints or 'None specified'}
        
        Lessons from past attempts:
        {lessons}
        
        Requirements:
        1. Include checkpoints for evaluation
        2. Define success criteria for each stage
        3. Include fallback options
        4. Specify adaptation triggers
        
        Format:
        STAGE: [name]
        TASKS:
        - [task]
        SUCCESS_CRITERIA: [how to know it's done]
        CHECKPOINT: [evaluation point]
        FALLBACK: [alternative if this fails]
        ADAPT_IF: [condition that requires plan change]
        """
        
        response = self.llm.invoke(prompt)
        return self._parse_adaptive_plan(response.content)
    
    def evaluate_progress(
        self,
        plan: Dict,
        current_stage: int,
        actual_results: Dict
    ) -> Dict:
        """Evaluate progress and decide if adaptation needed."""
        stage = plan["stages"][current_stage]
        
        prompt = f"""
        Evaluate plan progress:
        
        Stage: {stage['name']}
        Expected: {stage['success_criteria']}
        Actual: {actual_results}
        
        Questions:
        1. Is this stage successful? (yes/partially/no)
        2. Should we adapt the plan? (yes/no)
        3. If adapt, what changes?
        
        Return evaluation and recommendations.
        """
        
        evaluation = self.llm.invoke(prompt).content
        
        return {
            "stage": current_stage,
            "evaluation": evaluation,
            "needs_adaptation": "adapt" in evaluation.lower() and "yes" in evaluation.lower()
        }
    
    def adapt_plan(
        self,
        original_plan: Dict,
        evaluation: Dict,
        new_information: str = ""
    ) -> Dict:
        """Modify plan based on evaluation."""
        prompt = f"""
        Adapt this plan based on feedback:
        
        Original plan:
        {self._format_plan(original_plan)}
        
        Evaluation:
        {evaluation}
        
        New information:
        {new_information}
        
        Create an updated plan that:
        1. Keeps successful elements
        2. Addresses identified issues
        3. Incorporates new information
        """
        
        response = self.llm.invoke(prompt)
        new_plan = self._parse_adaptive_plan(response.content)
        
        # Record adaptation for learning
        self.feedback_history.append({
            "original_plan": original_plan,
            "evaluation": evaluation,
            "adapted_plan": new_plan
        })
        
        return new_plan
    
    def _extract_lessons(self, similar_plans: List[Dict]) -> str:
        """Extract lessons from past similar plans."""
        if not similar_plans:
            return "No similar past plans found."
        
        lessons = []
        for plan in similar_plans[:3]:
            content = plan.get("content", "")
            lessons.append(f"- {content[:200]}...")
        
        return "\n".join(lessons)
    
    def _parse_adaptive_plan(self, text: str) -> Dict:
        """Parse adaptive plan from LLM response."""
        plan = {"stages": []}
        current_stage = None
        
        for line in text.split('\n'):
            line = line.strip()
            if line.startswith('STAGE:'):
                if current_stage:
                    plan["stages"].append(current_stage)
                current_stage = {
                    "name": line.split(':', 1)[1].strip(),
                    "tasks": [],
                    "success_criteria": "",
                    "checkpoint": "",
                    "fallback": "",
                    "adapt_trigger": ""
                }
            elif current_stage:
                if line.startswith('-') and 'TASKS' in text[:text.find(line)]:
                    current_stage["tasks"].append(line[1:].strip())
                elif line.startswith('SUCCESS_CRITERIA:'):
                    current_stage["success_criteria"] = line.split(':', 1)[1].strip()
                elif line.startswith('CHECKPOINT:'):
                    current_stage["checkpoint"] = line.split(':', 1)[1].strip()
                elif line.startswith('FALLBACK:'):
                    current_stage["fallback"] = line.split(':', 1)[1].strip()
                elif line.startswith('ADAPT_IF:'):
                    current_stage["adapt_trigger"] = line.split(':', 1)[1].strip()
        
        if current_stage:
            plan["stages"].append(current_stage)
        
        return plan
    
    def _format_plan(self, plan: Dict) -> str:
        """Format plan for display."""
        parts = []
        for i, stage in enumerate(plan.get("stages", [])):
            parts.append(f"Stage {i+1}: {stage['name']}")
            for task in stage.get("tasks", []):
                parts.append(f"  - {task}")
        return "\n".join(parts)
```

---

## 🏁 Multi-Objective Optimization

```python
from typing import List, Dict, Callable
import numpy as np

class MultiObjectiveDecision:
    """
    Handle decisions with multiple competing objectives.
    """
    def __init__(self, llm):
        self.llm = llm
    
    def pareto_frontier(
        self,
        options: List[Dict],
        objectives: List[str]
    ) -> List[Dict]:
        """Find Pareto-optimal solutions."""
        # Score each option on each objective
        scored = []
        for opt in options:
            scores = self._score_option(opt, objectives)
            scored.append((opt, scores))
        
        # Find non-dominated solutions
        pareto_optimal = []
        for i, (opt1, scores1) in enumerate(scored):
            dominated = False
            for j, (opt2, scores2) in enumerate(scored):
                if i != j and self._dominates(scores2, scores1):
                    dominated = True
                    break
            if not dominated:
                pareto_optimal.append(opt1)
        
        return pareto_optimal
    
    def _score_option(self, option: Dict, objectives: List[str]) -> List[float]:
        """Score an option on each objective."""
        prompt = f"""
        Rate this option on each objective (0-10):
        
        Option: {option}
        
        Objectives:
        {chr(10).join(f'- {obj}' for obj in objectives)}
        
        Format: objective: score
        """
        
        response = self.llm.invoke(prompt)
        scores = []
        for line in response.content.split('\n'):
            if ':' in line:
                try:
                    score = float(line.split(':')[1].strip())
                    scores.append(score / 10)
                except:
                    scores.append(0.5)
        
        return scores[:len(objectives)]
    
    def _dominates(self, scores1: List[float], scores2: List[float]) -> bool:
        """Check if scores1 dominates scores2 (better in all, strictly better in at least one)."""
        all_better_or_equal = all(s1 >= s2 for s1, s2 in zip(scores1, scores2))
        at_least_one_strictly_better = any(s1 > s2 for s1, s2 in zip(scores1, scores2))
        return all_better_or_equal and at_least_one_strictly_better
    
    def weighted_decision(
        self,
        options: List[Dict],
        objectives: List[str],
        weights: Dict[str, float]
    ) -> Dict:
        """Make decision using weighted objectives."""
        best_option = None
        best_score = -float('inf')
        
        for option in options:
            scores = self._score_option(option, objectives)
            weighted_score = sum(
                score * weights.get(obj, 1.0)
                for score, obj in zip(scores, objectives)
            )
            
            if weighted_score > best_score:
                best_score = weighted_score
                best_option = option
        
        return best_option
```

---

## 📝 Key Takeaways

1. **Hierarchical planning** breaks complex goals into manageable subgoals
2. **Plan execution** needs monitoring, recovery, and replanning capabilities
3. **Uncertainty** requires probabilistic reasoning and risk assessment
4. **Adaptive planning** adjusts based on feedback and new information
5. **Multi-objective** decisions need trade-off analysis
6. **Learning from experience** improves future planning

---

## 🔗 What's Next?

Module 8: **Prompt Engineering and Adaptation** - Advanced prompting for agents

---

## 📚 Resources

### Papers
- "Planning with Large Language Models" (Huang et al.)
- "SayCan: Grounding Language in Robotic Affordances"
- "Language Models as Zero-Shot Planners"

### Tools
- [LangGraph Planning](https://langchain-ai.github.io/langgraph/)
- [AutoGen Task Planning](https://microsoft.github.io/autogen/)

---

*Module 7 Complete. Continue to Module 8: Prompt Engineering and Adaptation →*

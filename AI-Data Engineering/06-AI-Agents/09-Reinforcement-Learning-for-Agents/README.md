# 🎮 Module 09: Reinforcement Learning for Agents

## Overview

This module covers how Reinforcement Learning (RL) concepts apply to AI agents, enabling them to learn from feedback and improve over time.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** RL fundamentals and terminology
2. **Apply** RL concepts to LLM-based agents
3. **Implement** reward modeling and feedback systems
4. **Learn** about RLHF (Reinforcement Learning from Human Feedback)
5. **Design** self-improving agent systems

---

## 📚 Prerequisites

- Module 05: Understanding AI Agents
- Module 07: Decision Making and Planning
- Basic probability and statistics

---

## 🎲 RL Fundamentals

```
┌─────────────────────────────────────────────────────────────────┐
│                 REINFORCEMENT LEARNING LOOP                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│    ┌─────────────┐                                              │
│    │             │                                              │
│    │    AGENT    │                                              │
│    │             │                                              │
│    └──────┬──────┘                                              │
│           │                                                      │
│    Action │  ▲ Reward + New State                               │
│           │  │                                                   │
│           ▼  │                                                   │
│    ┌──────────────┐                                             │
│    │              │                                             │
│    │ ENVIRONMENT  │                                             │
│    │              │                                             │
│    └──────────────┘                                             │
│                                                                  │
│    Agent observes state s                                        │
│    Agent takes action a                                         │
│    Environment returns reward r and new state s'                │
│    Agent learns to maximize cumulative reward                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Key Concepts

| Term | Description | Agent Context |
|------|-------------|---------------|
| **State (s)** | Current situation | Conversation context, task progress |
| **Action (a)** | What agent does | Response, tool call, decision |
| **Reward (r)** | Feedback signal | User satisfaction, task success |
| **Policy (π)** | Action selection strategy | LLM + prompt = policy |
| **Value (V)** | Expected future reward | Quality of current state |
| **Q-Value** | Value of action in state | Expected outcome of specific action |

---

## 🧠 RL in LLM Agents

### The Agent as Policy

```python
from typing import Dict, List, Tuple
import numpy as np

class RLAgentFramework:
    """
    Framework for RL-style learning in LLM agents.
    """
    def __init__(self, llm, reward_model=None):
        self.llm = llm
        self.reward_model = reward_model
        self.experience_buffer = []
        self.policy_history = []
    
    def get_state(self, context: Dict) -> str:
        """Convert context to state representation."""
        return f"""
        Task: {context.get('task', '')}
        Progress: {context.get('progress', 0)}%
        History: {context.get('history', [])}
        Available tools: {context.get('tools', [])}
        """
    
    def select_action(self, state: str, temperature: float = 0.7) -> str:
        """Select action using LLM as policy."""
        prompt = f"""
        Current state:
        {state}
        
        What action should you take next?
        Consider the goal and current progress.
        """
        
        response = self.llm.invoke(prompt, temperature=temperature)
        return response.content
    
    def get_reward(self, state: str, action: str, outcome: str) -> float:
        """Calculate reward for a state-action-outcome triple."""
        if self.reward_model:
            return self.reward_model(state, action, outcome)
        
        # Default: use LLM to estimate reward
        prompt = f"""
        Rate this interaction on a scale of 0-10:
        
        State: {state}
        Action taken: {action}
        Outcome: {outcome}
        
        Consider:
        - Did the action help achieve the goal?
        - Was it efficient?
        - Were there any negative consequences?
        
        Return only a number 0-10.
        """
        
        score = self.llm.invoke(prompt)
        try:
            return float(score.content.strip()) / 10
        except:
            return 0.5
    
    def store_experience(
        self,
        state: str,
        action: str,
        reward: float,
        next_state: str
    ):
        """Store experience for learning."""
        self.experience_buffer.append({
            "state": state,
            "action": action,
            "reward": reward,
            "next_state": next_state
        })
    
    def learn_from_experience(self) -> Dict:
        """Analyze experiences and extract improvements."""
        if len(self.experience_buffer) < 5:
            return {"status": "need_more_data"}
        
        # Analyze high and low reward experiences
        sorted_exp = sorted(
            self.experience_buffer,
            key=lambda x: x["reward"],
            reverse=True
        )
        
        high_reward = sorted_exp[:3]
        low_reward = sorted_exp[-3:]
        
        prompt = f"""
        Analyze these agent experiences:
        
        HIGH REWARD (Good):
        {self._format_experiences(high_reward)}
        
        LOW REWARD (Bad):
        {self._format_experiences(low_reward)}
        
        What patterns lead to success? What should be avoided?
        Provide concrete guidelines for improving agent behavior.
        """
        
        insights = self.llm.invoke(prompt)
        return {
            "status": "learned",
            "insights": insights.content,
            "num_experiences": len(self.experience_buffer)
        }
    
    def _format_experiences(self, experiences: List[Dict]) -> str:
        """Format experiences for analysis."""
        formatted = []
        for exp in experiences:
            formatted.append(f"""
            State: {exp['state'][:100]}...
            Action: {exp['action'][:100]}...
            Reward: {exp['reward']}
            """)
        return "\n".join(formatted)
```

---

## 🏆 Reward Modeling

### Building Reward Functions

```python
from typing import Callable, List, Dict
from dataclasses import dataclass

@dataclass
class RewardSignal:
    name: str
    weight: float
    compute: Callable[[str, str, str], float]

class CompositeRewardModel:
    """
    Combine multiple reward signals into a single reward.
    """
    def __init__(self, signals: List[RewardSignal]):
        self.signals = signals
        self.history = []
    
    def compute_reward(
        self,
        state: str,
        action: str,
        outcome: str
    ) -> Dict:
        """Compute weighted reward from all signals."""
        rewards = {}
        total = 0
        
        for signal in self.signals:
            score = signal.compute(state, action, outcome)
            weighted = score * signal.weight
            rewards[signal.name] = {
                "raw": score,
                "weighted": weighted
            }
            total += weighted
        
        # Normalize
        total_weight = sum(s.weight for s in self.signals)
        normalized_total = total / total_weight
        
        result = {
            "total_reward": normalized_total,
            "components": rewards
        }
        
        self.history.append(result)
        return result

# Example reward signals
def task_completion_reward(state: str, action: str, outcome: str) -> float:
    """Reward for task completion."""
    completion_indicators = ["completed", "done", "finished", "success"]
    return 1.0 if any(ind in outcome.lower() for ind in completion_indicators) else 0.0

def efficiency_reward(state: str, action: str, outcome: str) -> float:
    """Reward for efficient actions."""
    # Shorter actions that achieve goals are preferred
    action_length = len(action)
    if action_length < 100:
        return 1.0
    elif action_length < 500:
        return 0.7
    else:
        return 0.4

def helpfulness_reward_llm(llm):
    """Create LLM-based helpfulness reward."""
    def compute(state: str, action: str, outcome: str) -> float:
        prompt = f"""
        Rate how helpful this response was (0-10):
        
        User situation: {state[:200]}
        Agent response: {action[:200]}
        
        Consider: Was it relevant? Accurate? Complete?
        Return only a number.
        """
        try:
            score = llm.invoke(prompt)
            return float(score.content.strip()) / 10
        except:
            return 0.5
    return compute

def safety_reward(state: str, action: str, outcome: str) -> float:
    """Penalize unsafe actions."""
    unsafe_patterns = [
        "execute", "delete", "drop", "rm -rf",
        "password", "api_key", "secret"
    ]
    
    action_lower = action.lower()
    if any(pattern in action_lower for pattern in unsafe_patterns):
        return 0.0  # Unsafe action
    return 1.0  # Safe

# Create composite model
reward_model = CompositeRewardModel([
    RewardSignal("completion", 0.4, task_completion_reward),
    RewardSignal("efficiency", 0.2, efficiency_reward),
    RewardSignal("safety", 0.3, safety_reward),
    # RewardSignal("helpfulness", 0.1, helpfulness_reward_llm(llm))
])
```

---

## 👤 RLHF (Reinforcement Learning from Human Feedback)

```
┌─────────────────────────────────────────────────────────────────┐
│                         RLHF PIPELINE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STEP 1: SUPERVISED FINE-TUNING (SFT)                           │
│  ─────────────────────────────────────                          │
│    Base Model → Train on demonstrations → SFT Model             │
│                                                                  │
│  STEP 2: REWARD MODEL TRAINING                                  │
│  ────────────────────────────────                               │
│    Collect human preferences: Response A vs Response B          │
│    Train model to predict: P(A > B)                             │
│                                                                  │
│  STEP 3: RL OPTIMIZATION                                        │
│  ───────────────────────                                        │
│    Use PPO to optimize policy                                   │
│    Policy generates responses                                   │
│    Reward model scores responses                                │
│    Update policy to maximize reward                             │
│    KL divergence keeps policy close to SFT model                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Simplified RLHF Implementation

```python
from typing import List, Tuple
import numpy as np

class PreferenceCollector:
    """
    Collect human preferences for reward model training.
    """
    def __init__(self):
        self.preferences = []
    
    def collect_preference(
        self,
        prompt: str,
        response_a: str,
        response_b: str,
        preferred: str  # "A" or "B"
    ):
        """Record a preference judgment."""
        self.preferences.append({
            "prompt": prompt,
            "response_a": response_a,
            "response_b": response_b,
            "preferred": preferred
        })
    
    def export_for_training(self) -> List[Dict]:
        """Export preferences for reward model training."""
        training_data = []
        for pref in self.preferences:
            # Format: (prompt, chosen, rejected)
            if pref["preferred"] == "A":
                chosen, rejected = pref["response_a"], pref["response_b"]
            else:
                chosen, rejected = pref["response_b"], pref["response_a"]
            
            training_data.append({
                "prompt": pref["prompt"],
                "chosen": chosen,
                "rejected": rejected
            })
        
        return training_data


class RewardModelTrainer:
    """
    Train a reward model from preferences.
    """
    def __init__(self, base_model):
        self.base_model = base_model
        self.reward_model = None
    
    def train(self, preferences: List[Dict], epochs: int = 3):
        """
        Train reward model using Bradley-Terry model.
        
        P(A > B) = sigmoid(r(A) - r(B))
        
        Loss = -log(P(chosen > rejected))
        """
        # In practice, this would use proper ML training
        # Here's a conceptual implementation
        
        for epoch in range(epochs):
            total_loss = 0
            
            for pref in preferences:
                # Get reward scores
                chosen_score = self._score(pref["prompt"], pref["chosen"])
                rejected_score = self._score(pref["prompt"], pref["rejected"])
                
                # Bradley-Terry loss
                loss = -np.log(self._sigmoid(chosen_score - rejected_score))
                total_loss += loss
                
                # Update model (simplified)
                self._update_model(pref, chosen_score, rejected_score)
            
            print(f"Epoch {epoch+1}, Loss: {total_loss/len(preferences):.4f}")
    
    def _score(self, prompt: str, response: str) -> float:
        """Get reward score for a response."""
        # In practice: pass through reward model head
        # Simplified: use length + keyword heuristics
        score = len(response) / 1000  # Longer = slightly better
        
        positive_words = ["helpful", "clear", "correct", "thank"]
        negative_words = ["sorry", "cannot", "error", "wrong"]
        
        score += sum(0.1 for w in positive_words if w in response.lower())
        score -= sum(0.1 for w in negative_words if w in response.lower())
        
        return score
    
    def _sigmoid(self, x: float) -> float:
        return 1 / (1 + np.exp(-x))
    
    def _update_model(self, pref: Dict, chosen_score: float, rejected_score: float):
        """Update model parameters (simplified)."""
        pass  # Would implement gradient update


class PPOTrainer:
    """
    Simplified PPO training for RLHF.
    """
    def __init__(self, policy_model, reward_model, reference_model):
        self.policy = policy_model
        self.reward_model = reward_model
        self.reference = reference_model  # For KL penalty
        
        self.kl_coef = 0.1
        self.clip_range = 0.2
    
    def train_step(self, prompts: List[str]) -> Dict:
        """Single PPO training step."""
        metrics = {
            "rewards": [],
            "kl_divs": [],
            "policy_loss": 0
        }
        
        for prompt in prompts:
            # Generate response with current policy
            response = self._generate(prompt)
            
            # Get reward
            reward = self.reward_model.score(prompt, response)
            
            # Calculate KL divergence from reference
            kl_div = self._calculate_kl(prompt, response)
            
            # Adjusted reward with KL penalty
            adjusted_reward = reward - self.kl_coef * kl_div
            
            # PPO update (simplified)
            self._ppo_update(prompt, response, adjusted_reward)
            
            metrics["rewards"].append(reward)
            metrics["kl_divs"].append(kl_div)
        
        return {
            "mean_reward": np.mean(metrics["rewards"]),
            "mean_kl": np.mean(metrics["kl_divs"])
        }
    
    def _generate(self, prompt: str) -> str:
        """Generate response with policy."""
        return self.policy.invoke(prompt).content
    
    def _calculate_kl(self, prompt: str, response: str) -> float:
        """Calculate KL divergence from reference model."""
        # Simplified: would compare token probabilities
        return 0.1
    
    def _ppo_update(self, prompt: str, response: str, reward: float):
        """Apply PPO update (simplified)."""
        pass  # Would implement actual PPO
```

---

## 🔄 Online Learning

```python
class OnlineLearningAgent:
    """
    Agent that learns continuously from interactions.
    """
    def __init__(self, llm, memory_system):
        self.llm = llm
        self.memory = memory_system
        self.feedback_buffer = []
        self.learned_guidelines = []
    
    def process_feedback(
        self,
        interaction_id: str,
        feedback_type: str,  # "positive", "negative", "correction"
        feedback_content: str
    ):
        """Process user feedback on an interaction."""
        self.feedback_buffer.append({
            "interaction_id": interaction_id,
            "type": feedback_type,
            "content": feedback_content,
            "timestamp": datetime.now()
        })
        
        # Trigger learning if enough feedback
        if len(self.feedback_buffer) >= 10:
            self._learn_from_feedback()
    
    def _learn_from_feedback(self):
        """Extract lessons from accumulated feedback."""
        # Group by feedback type
        positive = [f for f in self.feedback_buffer if f["type"] == "positive"]
        negative = [f for f in self.feedback_buffer if f["type"] == "negative"]
        corrections = [f for f in self.feedback_buffer if f["type"] == "correction"]
        
        prompt = f"""
        Analyze this feedback to extract behavioral guidelines:
        
        POSITIVE FEEDBACK (what went well):
        {self._format_feedback(positive)}
        
        NEGATIVE FEEDBACK (what went wrong):
        {self._format_feedback(negative)}
        
        CORRECTIONS (specific fixes):
        {self._format_feedback(corrections)}
        
        Extract:
        1. DO: Guidelines for good behavior
        2. DON'T: Things to avoid
        3. SPECIFIC RULES: Concrete rules from corrections
        """
        
        lessons = self.llm.invoke(prompt)
        self.learned_guidelines.append(lessons.content)
        
        # Store in long-term memory
        self.memory.semantic_memory.store(
            content=lessons.content,
            metadata={"type": "learned_guideline"},
            memory_type="guideline"
        )
        
        # Clear buffer
        self.feedback_buffer = []
    
    def get_adapted_prompt(self, base_prompt: str) -> str:
        """Adapt prompt with learned guidelines."""
        if not self.learned_guidelines:
            return base_prompt
        
        guidelines = "\n".join(self.learned_guidelines[-5:])  # Last 5
        
        return f"""
{base_prompt}

## Learned Guidelines (from user feedback)
{guidelines}
"""
    
    def _format_feedback(self, feedback_list: List[Dict]) -> str:
        """Format feedback for analysis."""
        if not feedback_list:
            return "None"
        return "\n".join([f"- {f['content']}" for f in feedback_list[:5]])
```

---

## 📊 Evaluation and Improvement Loop

```python
class ContinuousImprovementSystem:
    """
    System for continuous agent improvement.
    """
    def __init__(self, agent, evaluator, metrics_tracker):
        self.agent = agent
        self.evaluator = evaluator
        self.metrics = metrics_tracker
        self.improvement_history = []
    
    def run_evaluation_cycle(
        self,
        test_cases: List[Dict],
        baseline_scores: Dict = None
    ) -> Dict:
        """Run evaluation and identify improvements."""
        
        # Run agent on test cases
        results = []
        for case in test_cases:
            response = self.agent.run(case["input"])
            score = self.evaluator.evaluate(
                case["input"],
                response,
                case.get("expected")
            )
            results.append({
                "input": case["input"],
                "output": response,
                "score": score
            })
        
        # Aggregate metrics
        current_metrics = {
            "accuracy": np.mean([r["score"].get("accuracy", 0) for r in results]),
            "relevance": np.mean([r["score"].get("relevance", 0) for r in results]),
            "efficiency": np.mean([r["score"].get("efficiency", 0) for r in results])
        }
        
        # Compare to baseline
        if baseline_scores:
            improvements = {
                k: current_metrics[k] - baseline_scores.get(k, 0)
                for k in current_metrics
            }
        else:
            improvements = {}
        
        # Identify weak areas
        weak_areas = [
            k for k, v in current_metrics.items()
            if v < 0.7  # Below 70% threshold
        ]
        
        # Generate improvement suggestions
        suggestions = self._generate_improvements(results, weak_areas)
        
        return {
            "metrics": current_metrics,
            "improvements": improvements,
            "weak_areas": weak_areas,
            "suggestions": suggestions
        }
    
    def _generate_improvements(
        self,
        results: List[Dict],
        weak_areas: List[str]
    ) -> List[str]:
        """Generate improvement suggestions."""
        # Find lowest scoring examples
        sorted_results = sorted(results, key=lambda x: sum(x["score"].values()))
        poor_examples = sorted_results[:3]
        
        prompt = f"""
        Analyze these poor-performing examples:
        
        {self._format_examples(poor_examples)}
        
        Weak areas: {weak_areas}
        
        Suggest specific improvements for the agent:
        1. What prompting changes would help?
        2. What additional context or tools needed?
        3. What patterns should be addressed?
        """
        
        suggestions = self.llm.invoke(prompt)
        return suggestions.content.split('\n')
    
    def _format_examples(self, examples: List[Dict]) -> str:
        """Format examples for analysis."""
        formatted = []
        for ex in examples:
            formatted.append(f"""
            Input: {ex['input'][:200]}...
            Output: {ex['output'][:200]}...
            Score: {ex['score']}
            """)
        return "\n".join(formatted)
```

---

## 📝 Key Takeaways

1. **RL Framework**: Agent = Policy, Response = Action, Feedback = Reward
2. **Reward Modeling**: Combine multiple signals for comprehensive evaluation
3. **RLHF**: Learn from human preferences for alignment
4. **Online Learning**: Continuous improvement from real interactions
5. **Evaluation Loops**: Regular assessment drives improvement
6. **KL Penalty**: Prevents policy from diverging too far

---

## 🔗 What's Next?

Module 10: **RAG - Retrieval Augmented Generation** - Enhancing agents with external knowledge

---

## 📚 Resources

### Papers
- "Training Language Models to Follow Instructions with Human Feedback" (InstructGPT)
- "Direct Preference Optimization" (DPO)
- "Proximal Policy Optimization Algorithms"

### Libraries
- [trl](https://github.com/huggingface/trl) - Transformer Reinforcement Learning
- [OpenRLHF](https://github.com/OpenLLMAI/OpenRLHF)

---

*Module 9 Complete. Continue to Module 10: RAG - Retrieval Augmented Generation →*

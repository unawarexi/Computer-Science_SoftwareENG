# Reasoning and Planning in AI Agents

## Introduction

Reasoning and planning are fundamental cognitive capabilities that distinguish sophisticated AI agents from simple reactive systems. Reasoning enables agents to draw conclusions from available information, while planning enables them to determine sequences of actions to achieve goals.

Together, these capabilities allow agents to handle complex, novel situations—not just respond to what's immediately perceived, but think ahead, consider alternatives, and make informed decisions.

---

## What is Reasoning?

### Defining Reasoning

**Reasoning** is the cognitive process of deriving new information from existing information through logical inference. It allows agents to:

- Draw conclusions not explicitly stated
- Generalize from specific instances
- Evaluate evidence and arguments
- Solve problems systematically
- Make decisions under uncertainty

### Types of Reasoning

#### Deductive Reasoning

**Definition**: Drawing specific conclusions from general premises with logical certainty.

**Structure**:
- Premise 1: All A are B
- Premise 2: X is an A
- Conclusion: X is B

**Characteristics**:
- Conclusions are guaranteed if premises are true
- Moves from general to specific
- Preserves truth (sound arguments)

**Example**:
- All mammals are warm-blooded
- Dogs are mammals
- Therefore, dogs are warm-blooded

**In AI**: Formal logic systems, expert systems, rule-based reasoning

#### Inductive Reasoning

**Definition**: Inferring general principles from specific observations.

**Structure**:
- Observation: A₁, A₂, A₃... all have property P
- Conclusion: All A probably have property P

**Characteristics**:
- Conclusions are probabilistic, not certain
- Moves from specific to general
- Basis for learning and generalization

**Example**:
- Every swan I've seen is white
- Therefore, all swans are probably white
- (Note: Black swans exist in Australia!)

**In AI**: Machine learning, pattern recognition, statistical inference

#### Abductive Reasoning

**Definition**: Inferring the most likely explanation for observations.

**Structure**:
- Observation: O
- Hypothesis H would explain O
- Conclusion: H is likely true

**Characteristics**:
- "Inference to the best explanation"
- Conclusions are possible, not certain
- Common in diagnosis and investigation

**Example**:
- The grass is wet
- Rain would explain wet grass
- Therefore, it probably rained
- (But: Could be sprinklers, dew, etc.)

**In AI**: Diagnostic systems, hypothesis generation, root cause analysis

#### Analogical Reasoning

**Definition**: Drawing conclusions based on similarities between situations.

**Structure**:
- Situation A has properties P, Q, R
- Situation B has properties P, Q
- Conclusion: B probably also has property R

**Characteristics**:
- Powerful for novel situations
- Depends on relevant similarity
- Conclusions are suggestive, not definitive

**In AI**: Case-based reasoning, transfer learning, few-shot learning

---

## Reasoning Under Uncertainty

Real-world reasoning rarely involves certainty. Agents must reason effectively despite incomplete and uncertain information.

### Sources of Uncertainty

**Incomplete Information**: Not all relevant facts are known

**Noisy Observations**: Sensors and data are imperfect

**Future Uncertainty**: Cannot perfectly predict outcomes

**Model Uncertainty**: Models are simplifications of reality

### Probabilistic Reasoning

**Probability Theory** provides a principled framework for reasoning under uncertainty:

**Key Concepts**:
- **Prior Probability**: Initial belief before new evidence
- **Likelihood**: Probability of evidence given hypothesis
- **Posterior Probability**: Updated belief after evidence

**Bayes' Theorem**: The foundation of probabilistic reasoning
- Allows updating beliefs based on new evidence
- Prior × Likelihood → Posterior

**Bayesian Networks**: Represent probabilistic relationships
- Directed graphs showing dependencies
- Enable efficient probabilistic inference
- Widely used in diagnosis and prediction

### Handling Incomplete Information

**Closed-World Assumption**: What is not known to be true is false
- Simple but can lead to errors
- Common in database systems

**Open-World Assumption**: Unknown facts remain unknown
- More realistic but harder to reason with
- Requires explicit uncertainty modeling

**Default Reasoning**: Assume typical case unless evidence otherwise
- "Birds fly" as default
- Can be retracted: "Penguins don't fly"

---

## What is Planning?

### Defining Planning

**Planning** is the process of determining a sequence of actions that will transform a starting state into a goal state. It's looking ahead to determine how to achieve objectives.

### The Planning Problem

A planning problem consists of:

**Initial State**: Where the agent starts
- Description of the current world state
- What is true at the beginning

**Goal State**: What the agent wants to achieve
- Conditions that must be true
- May be partially specified

**Actions**: Available operations
- Preconditions: What must be true to perform the action
- Effects: How the action changes the world

**Plan**: A sequence (or structure) of actions
- Transforms initial state to goal state
- All preconditions satisfied when actions executed

### Planning vs. Reactive Control

| Planning | Reactive Control |
|----------|-----------------|
| Looks ahead | Responds to current state |
| Considers action sequences | Selects single actions |
| Achieves complex goals | Handles immediate situations |
| Computationally expensive | Fast response |
| Handles novel situations | Requires pre-defined responses |

---

## Classical Planning

### The Classical Planning Assumptions

Classical planning makes simplifying assumptions:

1. **Finite States**: World has finite number of states
2. **Fully Observable**: Complete knowledge of current state
3. **Deterministic**: Actions have predictable outcomes
4. **Static**: World changes only through agent actions
5. **Goals**: Conjunctions of propositions to achieve
6. **Sequential**: One action at a time, instant execution
7. **Implicit Time**: Time not explicitly modeled

### STRIPS Representation

**STRIPS** (Stanford Research Institute Problem Solver) is a classic representation:

**State**: Set of ground propositions that are true

**Action Schema**:
- **Name**: Identifier with parameters
- **Precondition**: Conjunctions of literals that must be true
- **Effect**: Conjunctions of literals describing changes
  - Add list: Propositions that become true
  - Delete list: Propositions that become false

**Example - Move Action**:
```
Action: Move(obj, from, to)
Precondition: At(obj, from) ∧ Clear(to)
Effect: At(obj, to) ∧ Clear(from) ∧ ¬At(obj, from) ∧ ¬Clear(to)
```

### Planning as Search

Planning can be viewed as searching through a space:

**State-Space Search**:
- **Forward Search**: Start at initial state, apply actions toward goal
- **Backward Search**: Start at goal, work backward to initial state

**Plan-Space Search**:
- Search through space of partial plans
- Add actions, constraints to refine plan
- Partial-Order Planning

### Heuristics for Planning

Effective planning requires good heuristics to guide search:

**Ignore-Delete-List Heuristic**: Assume actions only add effects
- Makes problem easier (relaxation)
- Solution length provides admissible heuristic

**Goal-Count Heuristic**: Number of unsatisfied goals
- Simple but often effective
- Can be improved with action counting

**Domain-Specific Heuristics**: Tailored to particular problems
- Can dramatically improve performance
- Require domain knowledge

---

## Beyond Classical Planning

Real-world planning often violates classical assumptions.

### Partial Observability

**Challenge**: Agent doesn't know full state

**Approaches**:
- **Belief States**: Reason about sets of possible states
- **Contingent Planning**: Plan for multiple possibilities
- **Conformant Planning**: Plan that works regardless of uncertainty

### Non-Deterministic Actions

**Challenge**: Actions may have multiple possible outcomes

**Approaches**:
- **Conditional Plans**: Different branches for different outcomes
- **Probabilistic Planning**: Optimize expected utility
- **Replanning**: Plan, execute, observe, replan

### Continuous States and Actions

**Challenge**: Infinite possible states and actions

**Approaches**:
- **Discretization**: Approximate with finite states
- **Motion Planning**: Specialized techniques for continuous spaces
- **Trajectory Optimization**: Find optimal continuous paths

### Temporal Planning

**Challenge**: Actions have duration, may overlap

**Approaches**:
- **Temporal Logic**: Represent time explicitly
- **Temporal Networks**: Constraints on timing
- **Scheduling**: Allocate resources over time

### Multi-Agent Planning

**Challenge**: Multiple agents with potentially conflicting goals

**Approaches**:
- **Centralized Planning**: Single planner for all agents
- **Distributed Planning**: Agents plan locally, coordinate
- **Game-Theoretic Planning**: Consider strategic interactions

---

## Hierarchical Planning

### The Problem of Scale

Real-world planning involves many actions at different levels of detail:
- High-level: "Prepare dinner"
- Medium-level: "Cook pasta"
- Low-level: "Turn on stove"

Flat planning doesn't scale—the search space explodes.

### Hierarchical Task Networks (HTN)

**Core Idea**: Organize planning knowledge hierarchically

**Components**:
- **Primitive Tasks**: Basic actions that can be executed
- **Compound Tasks**: Abstract tasks decomposed into subtasks
- **Methods**: Ways to decompose compound tasks

**Planning Process**:
1. Start with high-level goal
2. Select method to decompose
3. Recursively decompose until all primitive
4. Execute primitive actions

**Advantages**:
- Dramatically reduces search space
- Captures domain knowledge
- Plans are more natural/interpretable
- Can express complex procedures

### Goal Decomposition

**Abstract Goals** → **Subgoals** → **Actions**

Example: "Have a clean house"
- Subgoal: Clean living room
  - Action: Vacuum floor
  - Action: Dust furniture
- Subgoal: Clean kitchen
  - Action: Wash dishes
  - Action: Wipe counters

---

## Reasoning and Planning in LLM Agents

### Chain-of-Thought Reasoning

**Key Discovery**: Prompting LLMs to reason step-by-step dramatically improves performance.

**The Pattern**:
```
Question: [Complex problem]
Let me think through this step by step:
Step 1: [First reasoning step]
Step 2: [Second reasoning step]
...
Answer: [Final answer]
```

**Why It Works**:
- Breaks complex problems into manageable steps
- Makes intermediate reasoning explicit
- Reduces errors in complex reasoning
- Mimics human deliberate thinking

### Tree of Thoughts

**Extension**: Explore multiple reasoning paths, not just one chain.

**The Pattern**:
1. Generate multiple possible next thoughts
2. Evaluate promise of each path
3. Explore most promising paths
4. Backtrack if path fails

**Advantages**:
- Can recover from wrong initial steps
- Explores diverse solutions
- More systematic than single chain

### ReAct: Reasoning + Acting

**Integration**: Interleave reasoning with action and observation.

**The Pattern**:
```
Thought: I need to find X to answer this question
Action: Search for X
Observation: [Search results]
Thought: Based on results, Y is relevant
Action: Look up Y
Observation: [Y information]
Thought: Now I can answer the question
Answer: [Answer based on gathered information]
```

**Advantages**:
- Reasoning grounds actions
- Observations inform reasoning
- Flexible and adaptive

### Planning with LLMs

LLMs can serve as planners in various ways:

**Direct Planning**: Given goal, generate plan
- Simple approach
- May lack systematic coverage

**Decomposition Planning**: Break goal into subgoals
- Hierarchical approach
- More manageable subproblems

**Iterative Planning**: Generate partial plan, execute, observe, replan
- Handles uncertainty
- Adapts to outcomes

**Challenges**:
- LLMs may hallucinate invalid actions
- May not consider all constraints
- Long-horizon planning remains difficult

---

## Decision Making

### From Planning to Decision Making

Planning finds action sequences to achieve goals. Decision making adds:
- **Multiple Options**: Choose among alternatives
- **Uncertainty**: Outcomes not guaranteed
- **Tradeoffs**: Balance competing objectives

### Expected Utility Theory

**Rational Decision Making**: Choose action that maximizes expected utility

**Components**:
- **Outcomes**: Possible results of actions
- **Probabilities**: Likelihood of each outcome
- **Utilities**: Value (desirability) of each outcome
- **Expected Utility**: Probability-weighted sum of utilities

**The Principle**: A rational agent should always choose the action with highest expected utility.

### Multi-Objective Decision Making

Real decisions involve multiple objectives:
- Speed vs. safety
- Cost vs. quality
- Short-term vs. long-term

**Approaches**:
- **Weighted Sum**: Combine objectives with weights
- **Pareto Optimality**: Find solutions where no objective can improve without worsening another
- **Satisficing**: Find solution that is "good enough" on all objectives

---

## Summary

Reasoning and planning are the cognitive foundations of intelligent agent behavior. Reasoning allows agents to derive new knowledge, handle uncertainty, and draw conclusions. Planning enables agents to look ahead and determine how to achieve goals.

Classical approaches provide principled foundations, while modern LLM-based methods offer flexible and powerful alternatives. Effective agents typically combine multiple reasoning and planning strategies, adapting to the demands of different situations.

---

## Key Takeaways

1. Reasoning types (deductive, inductive, abductive, analogical) serve different purposes
2. Real-world reasoning must handle uncertainty—probabilistic methods are essential
3. Planning finds action sequences to transform initial states to goal states
4. Classical planning makes simplifying assumptions; real-world planning relaxes these
5. Hierarchical planning addresses scalability through abstraction
6. LLMs enable chain-of-thought reasoning and flexible planning
7. Decision making adds uncertainty, alternatives, and tradeoffs to planning

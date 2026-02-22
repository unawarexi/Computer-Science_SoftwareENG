# Agent Architectures

## Introduction

Agent architecture refers to the internal structure and organization of an AI agent—how perceptions are processed, how decisions are made, and how actions are generated. The architecture determines the agent's capabilities, limitations, and the types of problems it can effectively address.

Choosing the right architecture is crucial. Just as a building's architecture constrains what activities can occur within it, an agent's architecture constrains its behavior and capabilities.

---

## The Architecture Design Space

### Fundamental Questions

When designing an agent architecture, we must answer:

1. **Representation**: How is knowledge about the world represented?
2. **Reasoning**: How does the agent make decisions?
3. **Learning**: How does the agent improve over time?
4. **Action Selection**: How are actions chosen and executed?
5. **Memory**: What information is retained and how?
6. **Modularity**: How is functionality organized?

### Tradeoffs in Architecture Design

| Consideration | Tradeoff |
|--------------|----------|
| Reactivity vs. Deliberation | Fast response vs. careful planning |
| Generality vs. Efficiency | Handle any task vs. excel at specific tasks |
| Autonomy vs. Control | Independent operation vs. human oversight |
| Simplicity vs. Capability | Easy to build vs. sophisticated behavior |

---

## Classical Agent Architectures

### The Reactive Paradigm

**Philosophy**: Intelligence emerges from direct coupling between perception and action, without intervening representation or reasoning.

#### Subsumption Architecture

Developed by Rodney Brooks at MIT, the subsumption architecture revolutionized robotics in the late 1980s.

**Core Principles**:
- No central representation of the world
- Intelligence through interaction, not computation
- Layered behavior modules
- Simple behaviors combine to produce complex results

**Structure**:
```
Layer 3: Explore    [Higher priority, can inhibit lower layers]
Layer 2: Wander     
Layer 1: Avoid      
Layer 0: Survive    [Lowest level, most basic behaviors]
```

**Behavior Layers**:
Each layer is a complete behavior that maps sensors to actuators:
- Lower layers handle basic survival
- Higher layers add sophistication
- Higher layers can suppress (subsume) lower layers
- Parallel, asynchronous operation

**Advantages**:
- Real-time response
- Robust to sensor noise
- No complex reasoning overhead
- Scales well to physical robots

**Limitations**:
- Difficult to achieve complex goals
- No planning or lookahead
- Hard to modify or extend
- Limited to reactive behaviors

### The Deliberative Paradigm

**Philosophy**: Agents should maintain explicit models of the world and use reasoning to decide what to do.

#### Classical Planning Architecture

**Structure**:
```
Perception → World Model → Planner → Action
```

**Components**:
1. **Perception**: Interprets sensory data
2. **World Model**: Symbolic representation of current state
3. **Planner**: Searches for sequence of actions to achieve goal
4. **Executor**: Carries out the plan

**The Planning Process**:
1. Formalize current state symbolically
2. Define goal conditions
3. Search through action sequences
4. Find plan that transforms current state to goal state
5. Execute plan

**Classical Planning Representations**:
- **STRIPS**: States as sets of propositions, actions as add/delete lists
- **PDDL**: Planning Domain Definition Language
- **Situation Calculus**: First-order logic formalization

**Advantages**:
- Can achieve complex, long-horizon goals
- Explicit reasoning is inspectable
- Guarantees about plan correctness
- Handles novel situations through reasoning

**Limitations**:
- Computationally expensive (planning is hard)
- Requires accurate world model
- Slow to react to changes
- Fragile when assumptions are violated

### The Hybrid Paradigm

**Philosophy**: Combine reactive and deliberative approaches to get the benefits of both.

#### Three-Layer Architecture

The most common hybrid architecture organizes the agent into three tiers:

**Layer 1: Reactive Layer (Controller)**
- Direct sensor-to-actuator mappings
- Fast, real-time response
- Handles immediate situations
- Operates without deliberation

**Layer 2: Executive Layer (Sequencer)**
- Coordinates reactive behaviors
- Sequences actions according to plans
- Monitors execution
- Handles exceptions

**Layer 3: Deliberative Layer (Planner)**
- Maintains world model
- Plans to achieve goals
- Reasons about long-term objectives
- Slowest, most resource-intensive

**Inter-Layer Communication**:
- Higher layers set goals for lower layers
- Lower layers report status to higher layers
- Each layer operates at different timescales

**Example Operation**:
1. Deliberative layer creates plan: "Go to kitchen, make coffee"
2. Executive layer sequences: "Navigate to kitchen" → "Find coffee maker" → "Brew coffee"
3. Reactive layer handles: Obstacle avoidance, motor control, sensor processing

**Advantages**:
- Fast response when needed
- Long-term planning capability
- Graceful degradation
- Practical for real systems

**Variations**:
- **AuRA** (Autonomous Robot Architecture)
- **Atlantis**
- **TouringMachines**
- **InteRRaP**

---

## BDI Architecture

**BDI** stands for **Beliefs-Desires-Intentions**, a influential architecture based on a philosophical theory of human practical reasoning.

### Philosophical Foundations

BDI architecture draws from philosopher Michael Bratman's theory of human planning:
- Humans don't constantly reconsider all options
- We form intentions that guide and constrain future decisions
- Intentions provide stability and allow coordination

### Core Components

**Beliefs**: The agent's information about the world
- What the agent believes to be true
- Updated through perception
- May be incomplete or incorrect
- Forms the basis for reasoning

**Desires (Goals)**: States the agent wants to achieve
- May be multiple, possibly conflicting
- Represent motivations
- Not all desires become intentions

**Intentions**: Committed plans of action
- Subset of desires the agent has decided to pursue
- Provide stability—not constantly reconsidered
- Guide practical reasoning and action
- Persist until achieved, impossible, or superseded

### The BDI Control Loop

```
1. Observe environment → Update Beliefs
2. Generate new Desires based on Beliefs
3. Filter Desires to determine new Intentions
4. Select an Intention to pursue
5. Execute one step of the Intention
6. Repeat
```

### Intention Reconsideration

A key question: When should an agent reconsider its intentions?

**Bold Agents**: Rarely reconsider, keep pursuing intentions
- Risk: May pursue outdated or impossible goals

**Cautious Agents**: Frequently reconsider intentions
- Risk: May never complete anything due to constant replanning

**Optimal Strategy**: Reconsider when:
- Environment has changed significantly
- Current intention seems unlikely to succeed
- Better opportunities have emerged

### Advantages of BDI

- Intuitive—mirrors human reasoning
- Flexible—can adapt to changing circumstances
- Committed—provides stability in action
- Well-studied with theoretical foundations
- Practical implementations exist (AgentSpeak, JACK)

### Limitations of BDI

- Learning not addressed in basic architecture
- Interaction with other agents not explicit
- Plan library must be hand-crafted
- Scalability challenges

---

## Modern LLM-Based Agent Architectures

The emergence of Large Language Models has enabled fundamentally new agent architectures.

### The ReAct Architecture

**ReAct** (Reasoning and Acting) interleaves reasoning with action.

**The Pattern**:
```
Thought: [Reasoning about what to do]
Action: [Action to take]
Observation: [Result of action]
Thought: [Updated reasoning]
Action: [Next action]
...
```

**Key Innovation**: Explicit reasoning traces guide action selection
- Chain-of-thought reasoning made visible
- Actions grounded in reasoning
- Observations inform next reasoning step

**Advantages**:
- Interpretable reasoning process
- Flexible handling of diverse tasks
- Combines reasoning and acting naturally

### The Reflexion Architecture

**Reflexion** adds self-reflection and learning from mistakes.

**Components**:
- **Actor**: Generates actions based on observations
- **Evaluator**: Assesses success/failure of actions
- **Self-Reflection**: Generates verbal feedback on failures
- **Memory**: Stores experiences and reflections

**Process**:
1. Attempt task
2. Evaluate outcome
3. If failed, reflect on what went wrong
4. Store reflection in memory
5. Retry with benefit of reflection

**Key Innovation**: Verbal self-reflection as a learning mechanism
- No weight updates required
- Learns within context
- Builds experiential memory

### The Cognitive Architecture Pattern

Modern LLM agents often follow a cognitive architecture pattern:

**Core Components**:

**1. Perception Module**
- Processes inputs from environment
- Converts raw data to meaningful representations
- May include multiple modalities (text, image, etc.)

**2. Memory System**
- **Short-term/Working Memory**: Current context
- **Long-term Memory**: Persistent knowledge and experiences
- **Episodic Memory**: Specific past experiences
- **Semantic Memory**: General knowledge

**3. Reasoning/Planning Module**
- Analyzes situations
- Generates plans
- Evaluates options
- Uses chain-of-thought or other reasoning strategies

**4. Action Module**
- Executes planned actions
- Interacts with tools and environment
- Monitors action results

**5. Learning Module**
- Updates from experience
- Stores successful strategies
- Adapts to new situations

### Multi-Agent Architectures

Modern systems often employ multiple agents working together:

**Hierarchical Multi-Agent**:
- Manager agent delegates to specialist agents
- Each agent has focused expertise
- Manager coordinates overall task

**Collaborative Multi-Agent**:
- Agents with different roles collaborate
- Example: One agent writes, another reviews
- Iterative improvement through interaction

**Debate Architecture**:
- Multiple agents argue different positions
- Synthesis emerges from debate
- Reduces hallucination and improves accuracy

---

## Memory Architectures for Agents

Memory is crucial for agent effectiveness. Different memory types serve different purposes.

### Working Memory

**Purpose**: Hold currently relevant information
- Active context for current task
- Limited capacity
- Fast access

**Implementation**:
- Context window in LLMs
- Short-term buffers
- Attention mechanisms

### Episodic Memory

**Purpose**: Store specific experiences
- What happened, when, in what context
- Enables learning from past situations
- Supports retrieval of relevant experiences

**Implementation**:
- Experience databases
- Vector stores with embeddings
- Retrieval-augmented systems

### Semantic Memory

**Purpose**: Store general knowledge
- Facts about the world
- Relationships between concepts
- Domain knowledge

**Implementation**:
- Knowledge graphs
- Trained model weights
- Retrieved documents

### Procedural Memory

**Purpose**: Store how to do things
- Skills and procedures
- Learned behaviors
- Tool usage patterns

**Implementation**:
- Tool libraries
- Skill databases
- Behavior policies

### Memory Retrieval Strategies

**Recency**: Recently accessed memories are more available

**Relevance**: Memories similar to current situation

**Importance**: Memories marked as significant

**Hybrid**: Combine multiple factors for retrieval ranking

---

## Designing Agent Architectures

### Design Principles

**1. Separation of Concerns**
- Distinct modules for distinct functions
- Clear interfaces between components
- Enables independent development and testing

**2. Appropriate Abstraction**
- Right level of detail for each component
- Hide complexity where possible
- Expose necessary information

**3. Graceful Degradation**
- System works even if components fail
- Fallback behaviors
- Robust to partial information

**4. Scalability**
- Can handle increasing complexity
- Modular addition of capabilities
- Efficient resource use

### Architecture Selection Criteria

Choose architecture based on:

| Factor | Favors |
|--------|--------|
| Need for real-time response | Reactive |
| Complex long-term goals | Deliberative |
| Both immediate and long-term needs | Hybrid |
| Natural language interaction | LLM-based |
| Learning from experience | Learning architectures |
| Multi-stakeholder scenarios | BDI |

---

## Summary

Agent architecture is the blueprint for how an agent thinks and acts. From simple reactive systems to sophisticated hybrid and LLM-based architectures, the choice of architecture fundamentally shapes what an agent can do.

Classical architectures—reactive, deliberative, and hybrid—provide foundational concepts. BDI architecture offers a principled way to model goals and commitments. Modern LLM-based architectures enable flexible reasoning and action through natural language.

As you design agents, consider the tradeoffs between reactivity and deliberation, the role of memory, and how different components will work together to achieve the agent's goals.

---

## Key Takeaways

1. Architecture determines an agent's capabilities and limitations
2. Reactive architectures are fast but limited; deliberative architectures are powerful but slow
3. Hybrid architectures combine reactive and deliberative elements
4. BDI architecture models beliefs, desires, and intentions for practical reasoning
5. Modern LLM-based architectures enable flexible reasoning through language
6. Memory systems (working, episodic, semantic, procedural) are crucial for effective agents
7. Architecture choice should match task requirements and constraints

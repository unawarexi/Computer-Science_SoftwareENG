# ✨ Module 08: Prompt Engineering and Adaptation

## Overview

This module covers advanced prompt engineering techniques specifically for AI agents. You'll learn to design prompts that enable consistent, reliable, and adaptive agent behavior.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Master** advanced prompting techniques for agents
2. **Design** dynamic and adaptive prompts
3. **Implement** prompt optimization strategies
4. **Handle** edge cases and failure modes
5. **Create** reusable prompt templates

---

## 📚 Prerequisites

- Module 04: Large Language Models
- Module 05: Understanding AI Agents
- Experience writing LLM prompts

---

## 🎨 Prompt Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT PROMPT STRUCTURE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  SYSTEM PROMPT                                           │    │
│  │  ┌─────────────────────────────────────────────────────┐│    │
│  │  │ Identity & Role                                      ││    │
│  │  │ • Who is the agent?                                  ││    │
│  │  │ • What expertise does it have?                       ││    │
│  │  └─────────────────────────────────────────────────────┘│    │
│  │  ┌─────────────────────────────────────────────────────┐│    │
│  │  │ Capabilities & Tools                                 ││    │
│  │  │ • What can it do?                                    ││    │
│  │  │ • What tools are available?                          ││    │
│  │  └─────────────────────────────────────────────────────┘│    │
│  │  ┌─────────────────────────────────────────────────────┐│    │
│  │  │ Behavior Guidelines                                  ││    │
│  │  │ • How should it respond?                             ││    │
│  │  │ • What are the constraints?                          ││    │
│  │  └─────────────────────────────────────────────────────┘│    │
│  │  ┌─────────────────────────────────────────────────────┐│    │
│  │  │ Output Format                                        ││    │
│  │  │ • How should responses be structured?                ││    │
│  │  └─────────────────────────────────────────────────────┘│    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  DYNAMIC CONTEXT                                         │    │
│  │  • Retrieved memories                                    │    │
│  │  • Tool results                                          │    │
│  │  • Conversation history                                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  USER QUERY                                              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📝 System Prompt Templates

### Comprehensive Agent Template

```python
AGENT_SYSTEM_TEMPLATE = """
# Agent Identity
You are {agent_name}, a {agent_role}.

## Expertise
{expertise_description}

## Your Mission
{mission_statement}

---

# Available Tools
{tools_description}

## Tool Usage Guidelines
1. Only use tools when necessary
2. Verify tool inputs before calling
3. Handle tool errors gracefully
4. Explain your tool usage reasoning

---

# Behavior Guidelines

## DO:
{positive_behaviors}

## DON'T:
{negative_behaviors}

---

# Response Format
{output_format}

---

# Current Context
Date: {current_date}
User: {user_context}

{additional_context}
"""

def build_system_prompt(config: dict) -> str:
    """Build a system prompt from configuration."""
    return AGENT_SYSTEM_TEMPLATE.format(
        agent_name=config.get("name", "AI Assistant"),
        agent_role=config.get("role", "helpful assistant"),
        expertise_description=config.get("expertise", "General knowledge"),
        mission_statement=config.get("mission", "Help users effectively"),
        tools_description=format_tools(config.get("tools", [])),
        positive_behaviors=format_list(config.get("do", ["Be helpful", "Be accurate"])),
        negative_behaviors=format_list(config.get("dont", ["Make up information"])),
        output_format=config.get("format", "Clear, structured responses"),
        current_date=config.get("date", ""),
        user_context=config.get("user", ""),
        additional_context=config.get("context", "")
    )

def format_tools(tools: list) -> str:
    """Format tool descriptions."""
    if not tools:
        return "No external tools available."
    
    formatted = []
    for tool in tools:
        formatted.append(f"""
### {tool['name']}
- Description: {tool['description']}
- When to use: {tool.get('when_to_use', 'When relevant')}
- Input format: {tool.get('input_format', 'As specified')}
""")
    return "\n".join(formatted)

def format_list(items: list) -> str:
    """Format a list as bullet points."""
    return "\n".join(f"- {item}" for item in items)
```

### Specialized Agent Templates

```python
# Research Agent
RESEARCH_AGENT_PROMPT = """
You are a Research Analyst specializing in {domain}.

## Research Protocol
1. UNDERSTAND: Clarify the research question
2. SEARCH: Find relevant, authoritative sources
3. ANALYZE: Evaluate and synthesize information
4. VERIFY: Cross-check facts from multiple sources
5. REPORT: Present findings with citations

## Quality Standards
- Primary sources over secondary
- Recent data preferred (unless historical analysis)
- Note confidence levels for each finding
- Distinguish facts from interpretations

## Output Format
### Summary
[2-3 sentence overview]

### Key Findings
1. **Finding**: [description]
   - Source: [citation]
   - Confidence: [High/Medium/Low]

### Methodology
[How the research was conducted]

### Limitations
[What couldn't be verified or is uncertain]
"""

# Code Agent
CODE_AGENT_PROMPT = """
You are a Senior Software Engineer specialized in {languages}.

## Coding Standards
- Write clean, readable, well-documented code
- Follow {style_guide} conventions
- Include error handling
- Consider edge cases
- Write testable code

## When Writing Code
1. Understand requirements completely
2. Consider existing codebase patterns
3. Implement with best practices
4. Add helpful comments
5. Suggest tests if appropriate

## When Reviewing Code
1. Check for bugs and security issues
2. Evaluate code style and readability
3. Suggest improvements
4. Note what was done well

## Response Format
```{language}
// Code with comments explaining key decisions
```

**Explanation**: [Why this approach]
**Trade-offs**: [What alternatives exist]
**Testing**: [How to test this]
"""

# Customer Service Agent
SERVICE_AGENT_PROMPT = """
You are a Customer Service Representative for {company}.

## Core Values
- Empathy first: Acknowledge customer feelings
- Solution-focused: Move toward resolution
- Professional: Maintain composure always
- Transparent: Be honest about limitations

## Conversation Flow
1. GREET: Warm, professional welcome
2. LISTEN: Fully understand the issue
3. EMPATHIZE: Acknowledge their experience
4. SOLVE: Provide solution or next steps
5. CONFIRM: Ensure satisfaction
6. CLOSE: Professional farewell

## Response Guidelines
- Use customer's name when appropriate
- Keep responses concise but complete
- Offer alternatives when primary solution isn't possible
- Know when to escalate

## What You Can Do
{capabilities}

## What Requires Escalation
{escalation_triggers}
"""
```

---

## 🔄 Dynamic Prompt Construction

```python
from typing import List, Dict, Optional
from datetime import datetime

class DynamicPromptBuilder:
    """
    Builds prompts dynamically based on context and state.
    """
    def __init__(
        self,
        base_template: str,
        max_context_tokens: int = 4000
    ):
        self.base_template = base_template
        self.max_context_tokens = max_context_tokens
    
    def build(
        self,
        user_query: str,
        tools: List[Dict] = None,
        memories: List[str] = None,
        conversation_history: List[Dict] = None,
        task_context: Dict = None
    ) -> str:
        """Build a complete prompt for the current interaction."""
        
        sections = []
        
        # Base system prompt
        sections.append(self.base_template)
        
        # Add tools if available
        if tools:
            sections.append(self._format_tools_section(tools))
        
        # Add relevant memories
        if memories:
            memory_section = self._format_memories(memories)
            sections.append(memory_section)
        
        # Add task-specific context
        if task_context:
            sections.append(self._format_task_context(task_context))
        
        # Add timestamp
        sections.append(f"\nCurrent time: {datetime.now().isoformat()}")
        
        # Build conversation context
        if conversation_history:
            sections.append("\n## Recent Conversation")
            sections.append(self._format_conversation(conversation_history))
        
        # Combine and truncate if needed
        full_prompt = "\n\n".join(sections)
        return self._truncate_to_limit(full_prompt)
    
    def _format_tools_section(self, tools: List[Dict]) -> str:
        """Format tools for the prompt."""
        lines = ["## Available Tools"]
        for tool in tools:
            lines.append(f"""
### {tool['name']}
{tool['description']}
Parameters: {tool.get('parameters', 'None')}
""")
        return "\n".join(lines)
    
    def _format_memories(self, memories: List[str]) -> str:
        """Format relevant memories."""
        lines = ["## Relevant Context from Memory"]
        for i, memory in enumerate(memories[:5], 1):
            lines.append(f"{i}. {memory[:200]}...")
        return "\n".join(lines)
    
    def _format_task_context(self, context: Dict) -> str:
        """Format task-specific context."""
        lines = ["## Current Task Context"]
        for key, value in context.items():
            lines.append(f"- {key}: {value}")
        return "\n".join(lines)
    
    def _format_conversation(self, history: List[Dict]) -> str:
        """Format conversation history."""
        lines = []
        for msg in history[-10:]:  # Last 10 messages
            role = msg.get("role", "unknown")
            content = msg.get("content", "")[:500]
            lines.append(f"[{role}]: {content}")
        return "\n".join(lines)
    
    def _truncate_to_limit(self, prompt: str) -> str:
        """Truncate prompt to fit within token limits."""
        # Rough estimation: 4 chars ≈ 1 token
        estimated_tokens = len(prompt) // 4
        
        if estimated_tokens <= self.max_context_tokens:
            return prompt
        
        # Truncate from middle sections, preserve beginning and end
        lines = prompt.split('\n')
        while len('\n'.join(lines)) // 4 > self.max_context_tokens:
            # Remove from middle
            mid = len(lines) // 2
            lines.pop(mid)
        
        return '\n'.join(lines)
```

---

## 🎯 Task-Specific Prompting

### Few-Shot Examples

```python
class FewShotPromptManager:
    """
    Manages few-shot examples for consistent agent behavior.
    """
    def __init__(self, examples_db: Dict[str, List[Dict]]):
        self.examples_db = examples_db
    
    def get_examples(
        self,
        task_type: str,
        query: str,
        num_examples: int = 3
    ) -> str:
        """Get relevant few-shot examples."""
        examples = self.examples_db.get(task_type, [])
        
        if not examples:
            return ""
        
        # Select most relevant examples (could use embedding similarity)
        selected = examples[:num_examples]
        
        formatted = ["## Examples of Good Responses"]
        for i, ex in enumerate(selected, 1):
            formatted.append(f"""
### Example {i}
**User**: {ex['input']}
**Assistant**: {ex['output']}
""")
        
        return "\n".join(formatted)

# Example database
EXAMPLE_DB = {
    "code_review": [
        {
            "input": "Review this function: def add(a, b): return a + b",
            "output": """**Code Review**

✅ **Strengths**:
- Simple and clear implementation
- Descriptive function name

⚠️ **Suggestions**:
- Add type hints: `def add(a: int, b: int) -> int:`
- Add docstring explaining purpose
- Consider input validation

**Improved Version**:
```python
def add(a: int, b: int) -> int:
    \"\"\"Add two numbers and return the result.\"\"\"
    return a + b
```"""
        }
    ],
    "data_analysis": [
        {
            "input": "Analyze this sales data: [100, 150, 120, 180, 200]",
            "output": """**Sales Analysis**

📊 **Summary Statistics**:
- Total: 750 units
- Average: 150 units/period
- Min: 100 | Max: 200
- Trend: Upward (+100% from start to end)

📈 **Key Insights**:
1. Strong growth trajectory (+100% overall)
2. Minor dip in period 3, then recovery
3. Accelerating growth in recent periods

💡 **Recommendations**:
- Investigate period 3 dip causes
- Plan for continued growth capacity"""
        }
    ]
}
```

### Chain-of-Thought Prompting

```python
COT_TEMPLATES = {
    "problem_solving": """
Let me work through this step by step:

1. **Understanding the Problem**
   - What is being asked?
   - What information do I have?
   - What constraints exist?

2. **Breaking Down the Solution**
   - What are the key components?
   - What's the logical sequence?

3. **Executing Each Step**
   [Step-by-step work]

4. **Verifying the Solution**
   - Does this answer the question?
   - Are there any errors?

**Final Answer**: [conclusion]
""",

    "decision_making": """
Let me analyze this decision systematically:

1. **Options Available**
   - Option A: [description]
   - Option B: [description]

2. **Evaluation Criteria**
   - [criterion 1]: How does each option perform?
   - [criterion 2]: How does each option perform?

3. **Trade-offs Analysis**
   | Criteria | Option A | Option B |
   |----------|----------|----------|
   | ...      | ...      | ...      |

4. **Recommendation**
   Based on [key factors], I recommend [choice] because [reasoning].
""",

    "debugging": """
Let me debug this systematically:

1. **Reproduce the Issue**
   - What's the expected behavior?
   - What's the actual behavior?

2. **Identify Potential Causes**
   - Hypothesis 1: [description]
   - Hypothesis 2: [description]

3. **Test Each Hypothesis**
   - Testing H1: [result]
   - Testing H2: [result]

4. **Root Cause**
   The issue is caused by [root cause].

5. **Solution**
   [Fix description and code]
"""
}

def apply_cot_template(task_type: str, problem: str) -> str:
    """Apply chain-of-thought template to a problem."""
    template = COT_TEMPLATES.get(task_type, COT_TEMPLATES["problem_solving"])
    return f"""
{problem}

{template}
"""
```

---

## 🔧 Prompt Optimization

### A/B Testing Prompts

```python
from typing import Callable, List, Tuple
import random

class PromptOptimizer:
    """
    Optimize prompts through experimentation.
    """
    def __init__(self, llm, evaluator: Callable):
        self.llm = llm
        self.evaluator = evaluator  # Function to score responses
        self.experiments = []
    
    def ab_test(
        self,
        prompt_a: str,
        prompt_b: str,
        test_cases: List[str],
        num_trials: int = 10
    ) -> Dict:
        """Run A/B test between two prompts."""
        results = {"A": [], "B": []}
        
        for test_input in test_cases[:num_trials]:
            # Test prompt A
            response_a = self.llm.invoke(f"{prompt_a}\n\nInput: {test_input}")
            score_a = self.evaluator(test_input, response_a.content)
            results["A"].append(score_a)
            
            # Test prompt B
            response_b = self.llm.invoke(f"{prompt_b}\n\nInput: {test_input}")
            score_b = self.evaluator(test_input, response_b.content)
            results["B"].append(score_b)
        
        # Calculate statistics
        avg_a = sum(results["A"]) / len(results["A"])
        avg_b = sum(results["B"]) / len(results["B"])
        
        return {
            "prompt_a_avg": avg_a,
            "prompt_b_avg": avg_b,
            "winner": "A" if avg_a > avg_b else "B",
            "improvement": abs(avg_a - avg_b) / min(avg_a, avg_b) * 100,
            "details": results
        }
    
    def optimize_prompt(
        self,
        base_prompt: str,
        variations: List[str],
        test_cases: List[str]
    ) -> str:
        """Find the best prompt variation."""
        best_prompt = base_prompt
        best_score = 0
        
        for variation in [base_prompt] + variations:
            scores = []
            for test_input in test_cases[:5]:  # Quick evaluation
                response = self.llm.invoke(f"{variation}\n\nInput: {test_input}")
                score = self.evaluator(test_input, response.content)
                scores.append(score)
            
            avg_score = sum(scores) / len(scores)
            if avg_score > best_score:
                best_score = avg_score
                best_prompt = variation
        
        return best_prompt
    
    def auto_improve_prompt(
        self,
        prompt: str,
        poor_examples: List[Tuple[str, str, str]],  # (input, output, feedback)
        num_iterations: int = 3
    ) -> str:
        """Automatically improve prompt based on failure cases."""
        current_prompt = prompt
        
        for iteration in range(num_iterations):
            # Ask LLM to improve the prompt
            improvement_request = f"""
            Current prompt:
            {current_prompt}
            
            This prompt produced poor results in these cases:
            {self._format_poor_examples(poor_examples)}
            
            Suggest an improved version of the prompt that would handle these cases better.
            Keep the same general structure but improve specific instructions.
            """
            
            improved = self.llm.invoke(improvement_request)
            current_prompt = improved.content
        
        return current_prompt
    
    def _format_poor_examples(
        self,
        examples: List[Tuple[str, str, str]]
    ) -> str:
        """Format poor examples for improvement request."""
        formatted = []
        for inp, out, feedback in examples[:5]:
            formatted.append(f"""
Input: {inp}
Output: {out}
Issue: {feedback}
""")
        return "\n".join(formatted)
```

---

## 🛡️ Handling Edge Cases

```python
class RobustPromptHandler:
    """
    Handle edge cases and ensure prompt reliability.
    """
    def __init__(self, llm):
        self.llm = llm
    
    def with_fallbacks(
        self,
        primary_prompt: str,
        fallback_prompts: List[str],
        query: str,
        validator: Callable = None
    ) -> str:
        """Try primary prompt, fall back if needed."""
        prompts = [primary_prompt] + fallback_prompts
        
        for prompt in prompts:
            try:
                response = self.llm.invoke(f"{prompt}\n\n{query}")
                
                # Validate response if validator provided
                if validator and not validator(response.content):
                    continue
                
                return response.content
            except Exception as e:
                continue
        
        return "I apologize, but I'm unable to process this request."
    
    def with_retry_and_refine(
        self,
        prompt: str,
        query: str,
        max_retries: int = 3
    ) -> str:
        """Retry with refined prompts on failure."""
        last_response = None
        last_error = None
        
        for attempt in range(max_retries):
            try:
                if attempt == 0:
                    full_prompt = f"{prompt}\n\n{query}"
                else:
                    # Add refinement based on previous failure
                    full_prompt = f"""
{prompt}

Previous attempt resulted in: {last_error or 'unclear response'}
Please provide a clear, complete response.

{query}
"""
                
                response = self.llm.invoke(full_prompt)
                
                # Basic validation
                if len(response.content.strip()) > 10:
                    return response.content
                
                last_response = response.content
                last_error = "Response too short"
                
            except Exception as e:
                last_error = str(e)
        
        return last_response or "Unable to generate response."
    
    def handle_ambiguity(
        self,
        prompt: str,
        query: str,
        clarification_prompt: str = None
    ) -> Dict:
        """Handle ambiguous queries by asking for clarification."""
        
        # First, check if query is ambiguous
        ambiguity_check = self.llm.invoke(f"""
        Is this query ambiguous or missing important information?
        Query: {query}
        
        Respond with:
        CLEAR - if the query is clear and answerable
        AMBIGUOUS: [what's unclear] - if clarification is needed
        """)
        
        if "CLEAR" in ambiguity_check.content:
            # Proceed normally
            response = self.llm.invoke(f"{prompt}\n\n{query}")
            return {
                "status": "answered",
                "response": response.content
            }
        else:
            # Extract what's unclear
            unclear = ambiguity_check.content.split("AMBIGUOUS:")[-1].strip()
            
            if clarification_prompt:
                clarify_response = clarification_prompt.format(unclear=unclear)
            else:
                clarify_response = f"""
I'd like to help, but I need a bit more information:

{unclear}

Could you please clarify?
"""
            
            return {
                "status": "needs_clarification",
                "response": clarify_response,
                "unclear_aspects": unclear
            }
```

---

## 📊 Prompt Templates Library

```python
PROMPT_LIBRARY = {
    "summarize": {
        "brief": "Summarize the following in 2-3 sentences:\n{text}",
        "detailed": """Provide a comprehensive summary of the following:
{text}

Include:
- Main points
- Key details
- Important conclusions""",
        "bullet": """Summarize the following as bullet points:
{text}

Format:
• Main point 1
  - Supporting detail
• Main point 2"""
    },
    
    "analyze": {
        "swot": """Perform a SWOT analysis of:
{subject}

Format:
**Strengths**: 
**Weaknesses**: 
**Opportunities**: 
**Threats**: """,
        
        "pros_cons": """Analyze the pros and cons of:
{subject}

**Pros**:
1. 
2. 

**Cons**:
1. 
2. 

**Recommendation**: """,
    },
    
    "transform": {
        "simplify": """Explain this in simple terms that a beginner would understand:
{text}

Avoid jargon. Use analogies if helpful.""",
        
        "formalize": """Rewrite the following in a formal, professional tone:
{text}""",
        
        "technical": """Rewrite the following with technical precision:
{text}

Include relevant technical terminology."""
    },
    
    "generate": {
        "ideas": """Generate {count} creative ideas for:
{topic}

For each idea, provide:
- Title
- Brief description
- Potential impact""",
        
        "questions": """Generate {count} insightful questions about:
{topic}

Include a mix of:
- Clarifying questions
- Probing questions
- Strategic questions"""
    }
}

def get_prompt_template(category: str, template_type: str) -> str:
    """Get a prompt template from the library."""
    return PROMPT_LIBRARY.get(category, {}).get(template_type, "")
```

---

## 📝 Key Takeaways

1. **Structure matters** - Well-organized prompts yield better results
2. **Be explicit** - Clear instructions prevent misinterpretation
3. **Use examples** - Few-shot learning guides behavior
4. **Chain-of-thought** - Step-by-step reasoning improves accuracy
5. **Optimize iteratively** - Test and refine prompts
6. **Handle failures** - Build in fallbacks and retries

---

## 🔗 What's Next?

Module 9: **Reinforcement Learning for Agents** - Learning from feedback

---

## 📚 Resources

### Guides
- [OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- [Anthropic Prompt Engineering](https://docs.anthropic.com/claude/docs/prompt-engineering)

### Papers
- "Chain-of-Thought Prompting" (Wei et al.)
- "Self-Consistency Improves Chain of Thought Reasoning"

---

*Module 8 Complete. Continue to Module 9: Reinforcement Learning for Agents →*

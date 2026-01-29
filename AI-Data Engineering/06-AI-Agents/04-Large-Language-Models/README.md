# 🧠 Module 04: Large Language Models

## Overview

This module provides a comprehensive deep dive into Large Language Models (LLMs) - the cognitive engines that power AI agents. Understanding LLMs is essential for building effective, efficient, and reliable agent systems.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** how LLMs work internally
2. **Compare** different LLM providers and their offerings
3. **Master** prompt engineering techniques
4. **Learn** fine-tuning and customization approaches
5. **Optimize** LLM usage for cost and performance
6. **Handle** limitations and failure modes

---

## 📚 Prerequisites

- Module 02: AI/ML Fundamentals for Agents
- Module 03: AI Agent Frameworks
- Basic understanding of transformers

---

## 🏗️ LLM Architecture Recap

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LARGE LANGUAGE MODEL                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   INPUT: "The quick brown fox"                                       │
│                    │                                                 │
│                    ▼                                                 │
│   ┌────────────────────────────────────────┐                        │
│   │           TOKENIZER                     │                        │
│   │  "The" → 464  "quick" → 4248           │                        │
│   │  "brown" → 14198  "fox" → 21831        │                        │
│   └────────────────────────────────────────┘                        │
│                    │                                                 │
│                    ▼                                                 │
│   ┌────────────────────────────────────────┐                        │
│   │        EMBEDDING LAYER                  │                        │
│   │  Token IDs → Dense Vectors (d=4096)    │                        │
│   └────────────────────────────────────────┘                        │
│                    │                                                 │
│                    ▼                                                 │
│   ┌────────────────────────────────────────┐                        │
│   │     TRANSFORMER BLOCKS (×N)             │                        │
│   │  ┌──────────────────────────────────┐  │                        │
│   │  │  Multi-Head Self-Attention       │  │                        │
│   │  │  Feed-Forward Network            │  │                        │
│   │  │  Layer Normalization             │  │                        │
│   │  │  Residual Connections            │  │                        │
│   │  └──────────────────────────────────┘  │                        │
│   └────────────────────────────────────────┘                        │
│                    │                                                 │
│                    ▼                                                 │
│   ┌────────────────────────────────────────┐                        │
│   │      OUTPUT PROJECTION                  │                        │
│   │  → Vocabulary Logits (50,000+)         │                        │
│   │  → Softmax → Probabilities             │                        │
│   └────────────────────────────────────────┘                        │
│                    │                                                 │
│                    ▼                                                 │
│   OUTPUT: P("jumps") = 0.35, P("runs") = 0.22, ...                  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🏢 LLM Providers Comparison

### Tier 1: Leading Providers

| Provider | Flagship Model | Context Window | Best For |
|----------|---------------|----------------|----------|
| **OpenAI** | GPT-4o | 128K | General purpose, vision |
| **Anthropic** | Claude 3.5 Sonnet | 200K | Long context, safety |
| **Google** | Gemini 1.5 Pro | 2M | Multimodal, long context |
| **Meta** | LLaMA 3.1 405B | 128K | Open source |

### Tier 2: Specialized Providers

| Provider | Strength | Models |
|----------|----------|--------|
| **Cohere** | Enterprise RAG | Command R+ |
| **Mistral** | EU Compliance | Mistral Large |
| **Groq** | Speed (500+ tok/s) | LLaMA, Mixtral |
| **Together** | Cost-effective | Open source models |
| **Fireworks** | Fine-tuned models | Various |

### Model Selection Matrix

```
┌─────────────────────────────────────────────────────────────────┐
│                    MODEL SELECTION GUIDE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  USE CASE                    │  RECOMMENDED MODELS              │
│  ────────                    │  ──────────────────              │
│  Complex Reasoning           │  GPT-4o, Claude 3.5 Sonnet       │
│  Code Generation             │  Claude 3.5 Sonnet, GPT-4o       │
│  Long Documents              │  Gemini 1.5 Pro, Claude 3        │
│  Cost-Sensitive              │  GPT-4o-mini, Claude Haiku       │
│  Speed-Critical              │  Groq LLaMA, GPT-3.5-turbo       │
│  Privacy-Required            │  Local LLaMA, Mistral            │
│  Multimodal                  │  GPT-4o, Gemini 1.5              │
│  RAG/Enterprise              │  Cohere Command R+               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 API Integration

### OpenAI

```python
from openai import OpenAI

client = OpenAI(api_key="your-key")

# Basic completion
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Explain quantum computing."}
    ],
    temperature=0.7,
    max_tokens=1000
)

print(response.choices[0].message.content)

# With function calling
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get weather for a location",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {"type": "string"},
                    "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}
                },
                "required": ["location"]
            }
        }
    }
]

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "What's the weather in Tokyo?"}],
    tools=tools,
    tool_choice="auto"
)

# Streaming
stream = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Write a story"}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

### Anthropic Claude

```python
from anthropic import Anthropic

client = Anthropic(api_key="your-key")

# Basic message
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    system="You are an expert programmer.",
    messages=[
        {"role": "user", "content": "Write a Python decorator for caching."}
    ]
)

print(response.content[0].text)

# With tools
tools = [
    {
        "name": "search_database",
        "description": "Search the company database",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string"},
                "limit": {"type": "integer", "default": 10}
            },
            "required": ["query"]
        }
    }
]

response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    tools=tools,
    messages=[{"role": "user", "content": "Find all customers from Tokyo"}]
)

# Check for tool use
for content in response.content:
    if content.type == "tool_use":
        print(f"Tool: {content.name}, Input: {content.input}")
```

### Google Gemini

```python
import google.generativeai as genai

genai.configure(api_key="your-key")

model = genai.GenerativeModel("gemini-1.5-pro")

# Basic generation
response = model.generate_content("Explain machine learning")
print(response.text)

# With images (multimodal)
import PIL.Image
image = PIL.Image.open("diagram.png")

response = model.generate_content([
    "Describe this diagram in detail:",
    image
])

# Streaming
response = model.generate_content("Write a poem", stream=True)
for chunk in response:
    print(chunk.text, end="")
```

### Universal Access with LiteLLM

```python
from litellm import completion

# OpenAI
response = completion(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello"}]
)

# Anthropic
response = completion(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "Hello"}]
)

# Google
response = completion(
    model="gemini/gemini-1.5-pro",
    messages=[{"role": "user", "content": "Hello"}]
)

# Local Ollama
response = completion(
    model="ollama/llama3.1",
    messages=[{"role": "user", "content": "Hello"}],
    api_base="http://localhost:11434"
)
```

---

## 🎨 Prompt Engineering

### Core Principles

```
┌─────────────────────────────────────────────────────────────────┐
│                    PROMPT ENGINEERING PRINCIPLES                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. BE SPECIFIC                                                  │
│     ❌ "Write about dogs"                                        │
│     ✅ "Write a 200-word article about golden retrievers'        │
│         temperament for first-time dog owners"                   │
│                                                                  │
│  2. PROVIDE CONTEXT                                              │
│     ❌ "Summarize this"                                          │
│     ✅ "You are a senior analyst. Summarize this quarterly       │
│         report highlighting key financial metrics."              │
│                                                                  │
│  3. USE STRUCTURED FORMAT                                        │
│     ❌ "List some ideas"                                         │
│     ✅ "Provide 5 ideas in this format:                          │
│         - Idea: [title]                                          │
│         - Description: [1 sentence]                              │
│         - Difficulty: [Easy/Medium/Hard]"                        │
│                                                                  │
│  4. SHOW EXAMPLES (Few-shot)                                     │
│     Include 2-3 examples of desired output                       │
│                                                                  │
│  5. CHAIN OF THOUGHT                                             │
│     "Let's think step by step..."                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### System Prompts for Agents

```python
# Agent System Prompt Template
AGENT_SYSTEM_PROMPT = """You are an AI assistant with access to tools.

## Your Capabilities:
- Search the web for current information
- Execute Python code
- Query databases
- Send emails

## Guidelines:
1. Always verify information before providing answers
2. Use tools when you need external data
3. Be transparent about uncertainties
4. Ask for clarification when the request is ambiguous
5. Break complex tasks into steps

## Response Format:
- Start with a brief understanding of the request
- Explain your approach
- Execute the necessary steps
- Provide a clear conclusion

## Tools Available:
{tools}

Current date: {date}
"""

# Specialized Agent Prompts
RESEARCH_AGENT = """You are a research assistant specializing in {domain}.

Your task is to find accurate, up-to-date information on topics requested.

Guidelines:
- Use multiple sources when possible
- Verify claims with authoritative sources
- Note when information may be outdated
- Distinguish between facts and opinions
- Cite your sources

Output format:
## Summary
[2-3 sentence overview]

## Key Findings
- Finding 1
- Finding 2

## Sources
1. [source]
2. [source]

## Confidence Level
[High/Medium/Low] - [reason]
"""
```

### Advanced Prompting Techniques

```python
# Chain of Thought (CoT)
COT_PROMPT = """
Question: {question}

Let's approach this step by step:
1. First, I'll identify what we're trying to solve
2. Then, I'll gather the relevant information
3. Next, I'll analyze the data
4. Finally, I'll formulate the answer

Step 1: ...
"""

# Self-Consistency
def self_consistent_answer(question: str, num_samples: int = 5):
    """Generate multiple responses and take majority vote."""
    responses = []
    for _ in range(num_samples):
        response = llm.invoke(f"Think step by step: {question}")
        # Extract final answer
        answer = extract_answer(response)
        responses.append(answer)
    
    # Return most common answer
    return max(set(responses), key=responses.count)

# Tree of Thoughts (ToT)
TOT_PROMPT = """
Problem: {problem}

Generate 3 different approaches to solve this problem:

Approach 1:
- Idea: [describe]
- Pros: [list]
- Cons: [list]
- Evaluation: [score 1-10]

Approach 2:
...

Now, select the best approach and execute it:
"""

# ReAct Prompting
REACT_PROMPT = """
Question: {question}

You have access to these tools:
{tools}

Use this format:

Thought: I need to figure out...
Action: tool_name
Action Input: input to the tool
Observation: result from tool
... (repeat as needed)
Thought: I now know the answer
Final Answer: the answer to the question
"""
```

### Output Structuring

```python
from pydantic import BaseModel
from typing import List, Optional
from openai import OpenAI

class ResearchFinding(BaseModel):
    topic: str
    summary: str
    confidence: float
    sources: List[str]

class ResearchReport(BaseModel):
    title: str
    findings: List[ResearchFinding]
    conclusion: str
    recommendations: Optional[List[str]]

# Using OpenAI Structured Outputs
client = OpenAI()

response = client.beta.chat.completions.parse(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "You are a research assistant."},
        {"role": "user", "content": "Research AI agents and provide a report."}
    ],
    response_format=ResearchReport
)

report = response.choices[0].message.parsed
print(f"Title: {report.title}")
for finding in report.findings:
    print(f"- {finding.topic}: {finding.summary}")
```

---

## ⚙️ Model Parameters

### Temperature

```python
# Temperature controls randomness
# 0.0 = Deterministic, always pick highest probability
# 1.0 = More random, creative
# 2.0 = Very random (often incoherent)

# Use case mapping
TEMPERATURE_GUIDE = {
    "code_generation": 0.0,      # Deterministic, accurate
    "factual_qa": 0.1,           # Mostly deterministic
    "summarization": 0.3,        # Slight variation
    "general_chat": 0.7,         # Balanced
    "creative_writing": 0.9,     # More creative
    "brainstorming": 1.0,        # Maximum creativity
}
```

### Top-P (Nucleus Sampling)

```python
# Top-P: Only consider tokens in top P% probability mass
# top_p=0.1 → Very focused (top 10% probability)
# top_p=0.9 → More diverse (top 90% probability)

# Generally use EITHER temperature OR top_p, not both
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    temperature=1.0,  # If using temperature
    # OR
    top_p=0.9,        # If using top_p
)
```

### Other Parameters

```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    
    # Maximum tokens to generate
    max_tokens=4096,
    
    # Stop sequences - end generation at these strings
    stop=["\n\n", "END", "```"],
    
    # Presence penalty - reduce repetition of topics
    presence_penalty=0.6,  # -2.0 to 2.0
    
    # Frequency penalty - reduce repetition of exact phrases
    frequency_penalty=0.5,  # -2.0 to 2.0
    
    # Seed for reproducibility
    seed=42,
    
    # Number of completions to generate
    n=3,
    
    # Log probabilities (debugging)
    logprobs=True,
    top_logprobs=5
)
```

---

## 🔧 Fine-Tuning

### When to Fine-Tune

```
FINE-TUNE WHEN:
├── Need consistent style/format
├── Domain-specific terminology
├── Reducing prompt length (cost)
├── Improving task performance
└── Teaching specific behaviors

DON'T FINE-TUNE WHEN:
├── Few-shot prompting works well
├── Limited training data (<100 examples)
├── Frequent updates needed
└── General knowledge tasks
```

### OpenAI Fine-Tuning

```python
from openai import OpenAI
import json

client = OpenAI()

# Prepare training data (JSONL format)
training_data = [
    {
        "messages": [
            {"role": "system", "content": "You are a customer service agent."},
            {"role": "user", "content": "I want to return my order"},
            {"role": "assistant", "content": "I'd be happy to help with your return..."}
        ]
    },
    # ... more examples (minimum ~10, recommended 50-100+)
]

# Save to file
with open("training_data.jsonl", "w") as f:
    for example in training_data:
        f.write(json.dumps(example) + "\n")

# Upload training file
training_file = client.files.create(
    file=open("training_data.jsonl", "rb"),
    purpose="fine-tune"
)

# Start fine-tuning
job = client.fine_tuning.jobs.create(
    training_file=training_file.id,
    model="gpt-4o-mini-2024-07-18",
    hyperparameters={
        "n_epochs": 3,
        "batch_size": 1,
        "learning_rate_multiplier": 1.8
    }
)

# Monitor progress
status = client.fine_tuning.jobs.retrieve(job.id)
print(f"Status: {status.status}")

# Use fine-tuned model
response = client.chat.completions.create(
    model="ft:gpt-4o-mini-2024-07-18:your-org::job-id",
    messages=[...]
)
```

### LoRA and QLoRA (Open Source)

```python
# Using Hugging Face + PEFT for efficient fine-tuning
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import LoraConfig, get_peft_model
import torch

# Load base model
model_name = "meta-llama/Llama-3.1-8B-Instruct"
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    device_map="auto"
)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Configure LoRA
lora_config = LoraConfig(
    r=16,                    # Rank
    lora_alpha=32,           # Alpha
    target_modules=["q_proj", "v_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

# Apply LoRA
model = get_peft_model(model, lora_config)
model.print_trainable_parameters()
# Output: trainable params: 4,194,304 || all params: 8,030,261,248 || trainable%: 0.0522

# Fine-tune with your training loop or use trl
from trl import SFTTrainer

trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    tokenizer=tokenizer,
    max_seq_length=2048,
)
trainer.train()
```

---

## 💰 Cost Optimization

### Pricing Overview (as of 2024)

| Model | Input (1M tokens) | Output (1M tokens) |
|-------|-------------------|-------------------|
| GPT-4o | $2.50 | $10.00 |
| GPT-4o-mini | $0.15 | $0.60 |
| Claude 3.5 Sonnet | $3.00 | $15.00 |
| Claude Haiku | $0.25 | $1.25 |
| Gemini 1.5 Pro | $1.25 | $5.00 |
| Gemini 1.5 Flash | $0.075 | $0.30 |

### Cost Reduction Strategies

```python
# 1. Use cheaper models for simple tasks
def route_to_model(task_complexity: str, task: str):
    if task_complexity == "simple":
        return "gpt-4o-mini"  # Cheap
    elif task_complexity == "medium":
        return "gpt-4o"       # Balanced
    else:
        return "gpt-4o"       # Complex reasoning

# 2. Implement caching
from functools import lru_cache
import hashlib

@lru_cache(maxsize=1000)
def cached_llm_call(prompt_hash: str, model: str):
    # Only called if not in cache
    return llm.invoke(prompt)

def call_with_cache(prompt: str, model: str = "gpt-4o"):
    prompt_hash = hashlib.md5(prompt.encode()).hexdigest()
    return cached_llm_call(prompt_hash, model)

# 3. Prompt compression
def compress_prompt(prompt: str, max_tokens: int = 2000) -> str:
    """Reduce prompt length while preserving meaning."""
    # Remove redundant whitespace
    prompt = " ".join(prompt.split())
    
    # Use abbreviations for common phrases
    replacements = {
        "for example": "e.g.",
        "that is": "i.e.",
        "and so on": "etc.",
    }
    for full, short in replacements.items():
        prompt = prompt.replace(full, short)
    
    return prompt

# 4. Batch requests
async def batch_process(prompts: list[str]):
    """Process multiple prompts efficiently."""
    import asyncio
    from openai import AsyncOpenAI
    
    client = AsyncOpenAI()
    
    async def single_call(prompt):
        return await client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": prompt}]
        )
    
    # Run all calls concurrently
    results = await asyncio.gather(*[single_call(p) for p in prompts])
    return results
```

---

## ⚠️ Handling Limitations

### Common Issues

```python
# 1. Hallucination mitigation
def verify_with_search(llm_response: str, query: str) -> dict:
    """Cross-check LLM output with search results."""
    search_results = search_tool(query)
    
    verification_prompt = f"""
    Original response: {llm_response}
    Search results: {search_results}
    
    Verify the accuracy of the original response.
    Note any inaccuracies or unsupported claims.
    """
    
    verification = llm.invoke(verification_prompt)
    return {"response": llm_response, "verification": verification}

# 2. Context window management
def sliding_window_context(messages: list, max_tokens: int = 100000):
    """Keep recent messages within context window."""
    total_tokens = 0
    included_messages = []
    
    # Always include system message
    if messages[0]["role"] == "system":
        included_messages.append(messages[0])
        messages = messages[1:]
    
    # Add messages from most recent
    for msg in reversed(messages):
        msg_tokens = count_tokens(msg["content"])
        if total_tokens + msg_tokens > max_tokens:
            break
        included_messages.insert(1, msg)  # After system message
        total_tokens += msg_tokens
    
    return included_messages

# 3. Rate limiting
import time
from functools import wraps

def rate_limit(calls_per_minute: int):
    """Decorator to rate limit API calls."""
    min_interval = 60.0 / calls_per_minute
    last_called = [0.0]
    
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            elapsed = time.time() - last_called[0]
            wait_time = min_interval - elapsed
            if wait_time > 0:
                time.sleep(wait_time)
            last_called[0] = time.time()
            return func(*args, **kwargs)
        return wrapper
    return decorator

@rate_limit(calls_per_minute=60)
def call_llm(prompt: str):
    return client.chat.completions.create(...)

# 4. Retry with exponential backoff
import tenacity

@tenacity.retry(
    wait=tenacity.wait_exponential(multiplier=1, min=4, max=60),
    stop=tenacity.stop_after_attempt(5),
    retry=tenacity.retry_if_exception_type(Exception)
)
def robust_llm_call(prompt: str):
    return client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}]
    )
```

---

## 📊 Evaluation and Benchmarks

### Key Benchmarks

| Benchmark | Measures | Top Models |
|-----------|----------|------------|
| **MMLU** | General knowledge | GPT-4o, Claude 3.5 |
| **HumanEval** | Code generation | Claude 3.5, GPT-4o |
| **MT-Bench** | Multi-turn chat | GPT-4o |
| **MATH** | Mathematical reasoning | o1-preview |
| **ARC** | Reasoning | Claude 3 Opus |

### Custom Evaluation

```python
from typing import List, Dict
import json

def evaluate_agent(
    agent,
    test_cases: List[Dict],
    evaluator_llm
) -> Dict:
    """Evaluate agent performance on test cases."""
    results = []
    
    for case in test_cases:
        # Run agent
        response = agent.invoke(case["input"])
        
        # Evaluate with LLM
        eval_prompt = f"""
        Task: {case['input']}
        Expected behavior: {case['expected']}
        Agent response: {response}
        
        Rate the response on:
        1. Accuracy (0-10): Does it achieve the goal?
        2. Relevance (0-10): Is the response on-topic?
        3. Completeness (0-10): Does it fully address the request?
        
        Return JSON: {{"accuracy": X, "relevance": X, "completeness": X, "explanation": "..."}}
        """
        
        evaluation = evaluator_llm.invoke(eval_prompt)
        eval_data = json.loads(evaluation)
        eval_data["input"] = case["input"]
        eval_data["response"] = response
        results.append(eval_data)
    
    # Calculate aggregate metrics
    avg_accuracy = sum(r["accuracy"] for r in results) / len(results)
    avg_relevance = sum(r["relevance"] for r in results) / len(results)
    avg_completeness = sum(r["completeness"] for r in results) / len(results)
    
    return {
        "individual_results": results,
        "averages": {
            "accuracy": avg_accuracy,
            "relevance": avg_relevance,
            "completeness": avg_completeness
        }
    }
```

---

## 📝 Key Takeaways

1. **Choose models wisely** based on task requirements and budget
2. **Master prompt engineering** to get consistent, high-quality outputs
3. **Fine-tune** only when necessary and with sufficient data
4. **Optimize costs** through caching, routing, and batching
5. **Handle limitations** with verification, retries, and graceful degradation
6. **Evaluate systematically** to ensure agent quality

---

## 🔗 What's Next?

Module 5: **Understanding AI Agents** - Deep dive into agent architectures and patterns

---

## 📚 Resources

### Documentation
- [OpenAI Platform](https://platform.openai.com/docs)
- [Anthropic Docs](https://docs.anthropic.com)
- [Google AI Docs](https://ai.google.dev/docs)

### Papers
- "Scaling Laws for Neural Language Models"
- "Constitutional AI" (Anthropic)
- "GPT-4 Technical Report" (OpenAI)

### Tools
- [OpenRouter](https://openrouter.ai) - Universal API access
- [LiteLLM](https://github.com/BerriAI/litellm) - Unified LLM interface
- [Helicone](https://helicone.ai) - LLM monitoring

---

*Module 4 Complete. Continue to Module 5: Understanding AI Agents →*

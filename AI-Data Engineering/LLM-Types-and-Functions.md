# 🤖 LLM Types, Models & Functions

## Overview

This reference guide covers all major Large Language Models (LLMs), their capabilities, use cases, and how to interact with them. Use this as a quick reference when choosing models for your AI projects.

---

## 📊 Model Categories

```
┌─────────────────────────────────────────────────────────────────┐
│                      LLM LANDSCAPE                               │
└─────────────────────────────────────────────────────────────────┘

    ┌──────────────────┐     ┌──────────────────┐
    │   PROPRIETARY    │     │    OPEN SOURCE   │
    │   (API-based)    │     │   (Self-hosted)  │
    └──────────────────┘     └──────────────────┘
           │                         │
    ┌──────┴──────┐           ┌──────┴──────┐
    │             │           │             │
    ▼             ▼           ▼             ▼
 ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
 │OpenAI│    │Claude│    │LLaMA │    │Mistral│
 │ GPT  │    │      │    │      │    │       │
 └──────┘    └──────┘    └──────┘    └──────┘
    │             │           │             │
    ▼             ▼           ▼             ▼
 ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
 │Gemini│    │Cohere│    │ Qwen │    │ Phi  │
 │      │    │      │    │      │    │      │
 └──────┘    └──────┘    └──────┘    └──────┘
```

---

## 🏢 Proprietary Models (API-Based)

### OpenAI Models

| Model | Context | Best For | Pricing (per 1M tokens) |
|-------|---------|----------|------------------------|
| **GPT-4o** | 128K | Most capable, multimodal | $5 / $15 (in/out) |
| **GPT-4o-mini** | 128K | Fast, cost-effective | $0.15 / $0.60 |
| **GPT-4-turbo** | 128K | Complex reasoning | $10 / $30 |
| **GPT-4** | 8K | Stable, reliable | $30 / $60 |
| **GPT-3.5-turbo** | 16K | Simple tasks, cheap | $0.50 / $1.50 |
| **o1-preview** | 128K | Advanced reasoning | $15 / $60 |
| **o1-mini** | 128K | Faster reasoning | $3 / $12 |

```python
from openai import OpenAI
client = OpenAI()

# GPT-4o (recommended for most tasks)
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello!"}]
)

# GPT-4o-mini (cost-effective)
response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": "Hello!"}]
)

# With vision (multimodal)
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{
        "role": "user",
        "content": [
            {"type": "text", "text": "What's in this image?"},
            {"type": "image_url", "image_url": {"url": "https://..."}}
        ]
    }]
)
```

### Anthropic Claude Models

| Model | Context | Best For | Pricing (per 1M tokens) |
|-------|---------|----------|------------------------|
| **Claude 3.5 Sonnet** | 200K | Best balance | $3 / $15 |
| **Claude 3 Opus** | 200K | Complex analysis | $15 / $75 |
| **Claude 3 Sonnet** | 200K | Balanced tasks | $3 / $15 |
| **Claude 3 Haiku** | 200K | Fast, simple tasks | $0.25 / $1.25 |

```python
from anthropic import Anthropic
client = Anthropic()

# Claude 3.5 Sonnet (recommended)
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hello!"}]
)

# With system prompt
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    system="You are a helpful coding assistant.",
    messages=[{"role": "user", "content": "Write a Python function"}]
)
```

### Google Gemini Models

| Model | Context | Best For | Pricing |
|-------|---------|----------|---------|
| **Gemini 1.5 Pro** | 1M+ | Long context | $1.25 / $5 |
| **Gemini 1.5 Flash** | 1M | Fast, efficient | $0.075 / $0.30 |
| **Gemini 1.0 Pro** | 32K | General tasks | Free tier available |

```python
import google.generativeai as genai

genai.configure(api_key="your-api-key")

# Gemini 1.5 Pro
model = genai.GenerativeModel('gemini-1.5-pro')
response = model.generate_content("Hello!")

# With images
response = model.generate_content([
    "What's in this image?",
    image_part
])
```

### Cohere Models

| Model | Context | Best For |
|-------|---------|----------|
| **Command R+** | 128K | RAG, enterprise |
| **Command R** | 128K | Efficient RAG |
| **Command** | 4K | General tasks |

```python
import cohere
co = cohere.Client('your-api-key')

response = co.chat(
    model="command-r-plus",
    message="Hello!"
)
```

---

## 🔓 Open Source Models

### Meta LLaMA Family

| Model | Parameters | Context | Best For |
|-------|------------|---------|----------|
| **LLaMA 3.1 405B** | 405B | 128K | Largest open model |
| **LLaMA 3.1 70B** | 70B | 128K | High capability |
| **LLaMA 3.1 8B** | 8B | 128K | Local deployment |
| **LLaMA 3 70B** | 70B | 8K | Proven reliability |
| **LLaMA 3 8B** | 8B | 8K | Edge/local |
| **CodeLlama** | 7-70B | 16K | Code generation |

```python
# Using Ollama (local)
import ollama

response = ollama.chat(
    model='llama3.1',
    messages=[{'role': 'user', 'content': 'Hello!'}]
)

# Using HuggingFace
from transformers import AutoTokenizer, AutoModelForCausalLM

tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")
model = AutoModelForCausalLM.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")
```

### Mistral Models

| Model | Parameters | Context | Best For |
|-------|------------|---------|----------|
| **Mistral Large** | ~70B | 32K | Enterprise API |
| **Mixtral 8x22B** | 176B (MoE) | 64K | Best open MoE |
| **Mixtral 8x7B** | 47B (MoE) | 32K | Efficient reasoning |
| **Mistral 7B** | 7B | 32K | Local deployment |
| **Codestral** | 22B | 32K | Code generation |

```python
# Mistral API
from mistralai.client import MistralClient
client = MistralClient(api_key="your-api-key")

response = client.chat(
    model="mistral-large-latest",
    messages=[{"role": "user", "content": "Hello!"}]
)

# Local with Ollama
import ollama
response = ollama.chat(model='mixtral', messages=[...])
```

### Other Notable Open Models

| Model | Provider | Parameters | Specialty |
|-------|----------|------------|-----------|
| **Qwen 2.5** | Alibaba | 0.5-72B | Multilingual |
| **Phi-3** | Microsoft | 3.8-14B | Small & capable |
| **Yi** | 01.AI | 6-34B | Bilingual (EN/CN) |
| **Falcon** | TII | 7-180B | Open license |
| **Gemma 2** | Google | 2-27B | Efficient |
| **DeepSeek** | DeepSeek | 7-67B | Code & math |

---

## 🎯 Model Selection Guide

### By Use Case

| Use Case | Recommended Models |
|----------|-------------------|
| **General Chat** | GPT-4o-mini, Claude 3.5 Sonnet, Gemini 1.5 Flash |
| **Complex Reasoning** | GPT-4o, Claude 3 Opus, o1-preview |
| **Code Generation** | GPT-4o, Claude 3.5 Sonnet, CodeLlama, Codestral |
| **Long Documents** | Gemini 1.5 Pro, Claude 3, GPT-4-turbo |
| **RAG Applications** | Command R+, GPT-4o-mini, Claude 3 Haiku |
| **Local/Private** | LLaMA 3.1, Mistral, Phi-3 |
| **Cost-Sensitive** | GPT-4o-mini, Gemini Flash, Claude Haiku |
| **Multimodal** | GPT-4o, Gemini 1.5, Claude 3 |

### By Budget

| Budget | Recommended |
|--------|-------------|
| **Free** | Gemini 1.0, Groq (LLaMA), local Ollama |
| **Low** | GPT-4o-mini, Claude Haiku, Gemini Flash |
| **Medium** | GPT-4o, Claude 3.5 Sonnet |
| **Enterprise** | GPT-4, Claude 3 Opus, Mistral Large |

---

## ⚙️ Common API Parameters

### Temperature

Controls randomness (0 = deterministic, 2 = very random):

```python
# Factual/consistent output
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    temperature=0.0
)

# Creative writing
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    temperature=1.2
)
```

### Max Tokens

Limit response length:

```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    max_tokens=500  # Max output tokens
)
```

### Top P (Nucleus Sampling)

Alternative to temperature:

```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    top_p=0.9  # Consider top 90% probability mass
)
```

### Stop Sequences

Stop generation at specific strings:

```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    stop=["END", "\n\n"]  # Stop at these strings
)
```

### Frequency/Presence Penalty

Reduce repetition:

```python
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[...],
    frequency_penalty=0.5,  # Penalize frequent tokens
    presence_penalty=0.5    # Penalize tokens already present
)
```

---

## 🔧 Function Calling / Tool Use

### OpenAI Functions

```python
tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "Get current weather for a location",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "City and country"
                },
                "unit": {
                    "type": "string",
                    "enum": ["celsius", "fahrenheit"]
                }
            },
            "required": ["location"]
        }
    }
}]

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "What's the weather in Paris?"}],
    tools=tools,
    tool_choice="auto"
)

# Check if model wants to call a function
if response.choices[0].message.tool_calls:
    tool_call = response.choices[0].message.tool_calls[0]
    function_name = tool_call.function.name
    arguments = json.loads(tool_call.function.arguments)
```

### Claude Tools

```python
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    tools=[{
        "name": "get_weather",
        "description": "Get current weather for a location",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {"type": "string"}
            },
            "required": ["location"]
        }
    }],
    messages=[{"role": "user", "content": "What's the weather in Paris?"}]
)
```

---

## 📈 Embedding Models

| Model | Provider | Dimensions | Best For |
|-------|----------|------------|----------|
| **text-embedding-3-large** | OpenAI | 3072 | Highest quality |
| **text-embedding-3-small** | OpenAI | 1536 | Cost-effective |
| **embed-english-v3.0** | Cohere | 1024 | English RAG |
| **voyage-2** | Voyage AI | 1024 | High quality |
| **bge-large-en-v1.5** | BAAI | 1024 | Open source |
| **all-MiniLM-L6-v2** | HuggingFace | 384 | Fast/local |

---

## 🎙️ Speech Models

| Model | Provider | Capability |
|-------|----------|------------|
| **Whisper** | OpenAI | Speech-to-Text |
| **TTS-1** | OpenAI | Text-to-Speech |
| **TTS-1-HD** | OpenAI | High-quality TTS |

```python
# Speech to Text
audio_file = open("audio.mp3", "rb")
transcript = client.audio.transcriptions.create(
    model="whisper-1",
    file=audio_file
)

# Text to Speech
response = client.audio.speech.create(
    model="tts-1",
    voice="alloy",
    input="Hello, world!"
)
```

---

## 🖼️ Image Models

| Model | Provider | Capability |
|-------|----------|------------|
| **DALL-E 3** | OpenAI | Image generation |
| **Midjourney** | Midjourney | Artistic images |
| **Stable Diffusion** | Stability AI | Open source generation |
| **Imagen** | Google | Image generation |

```python
response = client.images.generate(
    model="dall-e-3",
    prompt="A sunset over mountains",
    size="1024x1024",
    quality="standard",
    n=1
)
image_url = response.data[0].url
```

---

## 📚 Quick Reference Card

### When to Use Which Model

```
Need the BEST quality?
    → GPT-4o or Claude 3 Opus

Need FAST & CHEAP?
    → GPT-4o-mini or Claude Haiku

Need LONG CONTEXT?
    → Gemini 1.5 Pro (1M tokens)

Need PRIVACY/LOCAL?
    → LLaMA 3.1 or Mistral

Need CODE?
    → GPT-4o, Claude 3.5, Codestral

Need MULTIMODAL?
    → GPT-4o or Gemini

Need REASONING?
    → o1-preview or Claude 3 Opus
```

---

## 🔗 Related Resources

- [06-AI-Agents](./06-AI-Agents) - Using LLMs in agent systems
- [04-AI-Core-Concepts](./04-AI-Core-Concepts) - Embeddings and RAG

# 🧠 Module 02: AI/ML Fundamentals for Agents

## Overview

This module covers the essential AI and Machine Learning concepts that underpin modern AI agents. Understanding these fundamentals is crucial for building, customizing, and troubleshooting agent systems.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** core machine learning concepts and paradigms
2. **Grasp** how neural networks process information
3. **Learn** how large language models work internally
4. **Master** embeddings and vector representations
5. **Comprehend** the training vs. inference distinction
6. **Apply** these concepts to agent development

---

## 📚 Prerequisites

- Basic programming knowledge
- Module 01: Introduction to Agentic AI
- Familiarity with Python

---

## 🤖 Machine Learning Fundamentals

### What is Machine Learning?

Machine Learning (ML) enables computers to learn patterns from data without being explicitly programmed.

```
┌─────────────────────────────────────────────────────────────┐
│                  MACHINE LEARNING PARADIGMS                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SUPERVISED LEARNING         │  UNSUPERVISED LEARNING       │
│  ────────────────────        │  ──────────────────────      │
│  • Labeled data              │  • Unlabeled data            │
│  • Classification            │  • Clustering                │
│  • Regression                │  • Dimensionality reduction  │
│  • Ex: Spam detection        │  • Ex: Customer segments     │
│                                                              │
│  REINFORCEMENT LEARNING      │  SELF-SUPERVISED LEARNING    │
│  ──────────────────────      │  ────────────────────────    │
│  • Learn from rewards        │  • Create own labels         │
│  • Trial and error           │  • Predict masked tokens     │
│  • Sequential decisions      │  • Foundation models         │
│  • Ex: Game-playing AI       │  • Ex: GPT, BERT             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Key ML Concepts

| Concept | Description | Agent Relevance |
|---------|-------------|-----------------|
| **Features** | Input variables | Tool parameters, user intent |
| **Labels** | Target outputs | Correct actions, answers |
| **Training** | Learning from data | Creating the base model |
| **Inference** | Making predictions | Real-time agent responses |
| **Overfitting** | Memorizing training data | Agent becoming too narrow |
| **Generalization** | Applying to new data | Handling novel situations |

---

## 🔮 Neural Networks Deep Dive

### Basic Architecture

```
INPUT LAYER          HIDDEN LAYERS          OUTPUT LAYER
    │                    │                      │
   ┌─┐                 ┌─┐ ┌─┐                 ┌─┐
   │○│────────────────▶│○│─│○│────────────────▶│○│──▶ Output
   └─┘                 └─┘ └─┘                 └─┘
   ┌─┐                 ┌─┐ ┌─┐                 
   │○│────────────────▶│○│─│○│                 
   └─┘                 └─┘ └─┘                 
   ┌─┐                 ┌─┐ ┌─┐                 
   │○│────────────────▶│○│─│○│                 
   └─┘                 └─┘ └─┘                 
    
  Features           Processing            Prediction
```

### How Neurons Work

```python
import numpy as np

def neuron(inputs, weights, bias):
    """
    A single artificial neuron:
    1. Multiply inputs by weights
    2. Sum everything up
    3. Add bias
    4. Apply activation function
    """
    # Linear combination
    z = np.dot(inputs, weights) + bias
    
    # Activation (ReLU)
    output = max(0, z)
    
    return output

# Example
inputs = np.array([0.5, 0.3, 0.2])
weights = np.array([0.4, 0.6, 0.8])
bias = 0.1

result = neuron(inputs, weights, bias)
print(f"Neuron output: {result}")
```

### Activation Functions

```python
import numpy as np

def sigmoid(x):
    """Maps to range (0, 1) - good for probabilities"""
    return 1 / (1 + np.exp(-x))

def relu(x):
    """Rectified Linear Unit - most common in deep learning"""
    return np.maximum(0, x)

def softmax(x):
    """Converts to probability distribution - used for classification"""
    exp_x = np.exp(x - np.max(x))  # Numerical stability
    return exp_x / exp_x.sum()

# Visualization
x = np.linspace(-5, 5, 100)

# In agents: softmax is used for token prediction
logits = np.array([2.0, 1.0, 0.1])  # Raw model outputs
probs = softmax(logits)  # [0.659, 0.242, 0.099]
print(f"Next token probabilities: {probs}")
```

### Forward and Backward Propagation

```python
class SimpleNeuralNetwork:
    """
    Demonstrates the core concepts of neural network training
    """
    def __init__(self, input_size, hidden_size, output_size):
        # Initialize random weights
        self.W1 = np.random.randn(input_size, hidden_size) * 0.01
        self.b1 = np.zeros((1, hidden_size))
        self.W2 = np.random.randn(hidden_size, output_size) * 0.01
        self.b2 = np.zeros((1, output_size))
    
    def forward(self, X):
        """Forward pass: input → prediction"""
        # Layer 1
        self.z1 = np.dot(X, self.W1) + self.b1
        self.a1 = np.maximum(0, self.z1)  # ReLU
        
        # Layer 2
        self.z2 = np.dot(self.a1, self.W2) + self.b2
        self.a2 = self.softmax(self.z2)
        
        return self.a2
    
    def backward(self, X, y, learning_rate=0.01):
        """Backward pass: compute gradients and update weights"""
        m = X.shape[0]
        
        # Output layer gradient
        dz2 = self.a2 - y
        dW2 = np.dot(self.a1.T, dz2) / m
        db2 = np.sum(dz2, axis=0, keepdims=True) / m
        
        # Hidden layer gradient
        da1 = np.dot(dz2, self.W2.T)
        dz1 = da1 * (self.z1 > 0)  # ReLU derivative
        dW1 = np.dot(X.T, dz1) / m
        db1 = np.sum(dz1, axis=0, keepdims=True) / m
        
        # Update weights (gradient descent)
        self.W2 -= learning_rate * dW2
        self.b2 -= learning_rate * db2
        self.W1 -= learning_rate * dW1
        self.b1 -= learning_rate * db1
    
    @staticmethod
    def softmax(x):
        exp_x = np.exp(x - np.max(x, axis=1, keepdims=True))
        return exp_x / exp_x.sum(axis=1, keepdims=True)
```

---

## 📝 Large Language Models (LLMs)

### The Transformer Architecture

LLMs are built on the **Transformer** architecture, introduced in "Attention Is All You Need" (2017).

```
┌─────────────────────────────────────────────────────────────────┐
│                    TRANSFORMER ARCHITECTURE                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                        ┌──────────────┐                         │
│                        │   OUTPUT     │                         │
│                        │ PROBABILITIES│                         │
│                        └──────────────┘                         │
│                               ▲                                  │
│                        ┌──────────────┐                         │
│                        │    LINEAR    │                         │
│                        │   + SOFTMAX  │                         │
│                        └──────────────┘                         │
│                               ▲                                  │
│         ┌─────────────────────┴─────────────────────┐           │
│         │                                           │           │
│   ┌─────────────┐                           ┌─────────────┐     │
│   │   ENCODER   │                           │   DECODER   │     │
│   │  (optional) │◀─────────────────────────▶│   LAYERS    │     │
│   │   LAYERS    │     Cross-Attention       │             │     │
│   └─────────────┘                           └─────────────┘     │
│         ▲                                           ▲           │
│   ┌─────────────┐                           ┌─────────────┐     │
│   │ POSITIONAL  │                           │ POSITIONAL  │     │
│   │  ENCODING   │                           │  ENCODING   │     │
│   └─────────────┘                           └─────────────┘     │
│         ▲                                           ▲           │
│   ┌─────────────┐                           ┌─────────────┐     │
│   │  EMBEDDING  │                           │  EMBEDDING  │     │
│   │    LAYER    │                           │    LAYER    │     │
│   └─────────────┘                           └─────────────┘     │
│         ▲                                           ▲           │
│       INPUT                                       INPUT         │
│      TOKENS                                      TOKENS         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Self-Attention Mechanism

The key innovation that enables LLMs to understand context:

```python
import numpy as np

def scaled_dot_product_attention(Q, K, V, mask=None):
    """
    The core attention mechanism
    
    Q: Query - "What am I looking for?"
    K: Key   - "What do I contain?"
    V: Value - "What information do I provide?"
    """
    d_k = Q.shape[-1]  # Dimension of keys
    
    # 1. Compute attention scores
    scores = np.matmul(Q, K.T) / np.sqrt(d_k)
    
    # 2. Apply mask (for causal/autoregressive models)
    if mask is not None:
        scores = np.where(mask == 0, -1e9, scores)
    
    # 3. Softmax to get attention weights
    attention_weights = softmax(scores)
    
    # 4. Weighted sum of values
    output = np.matmul(attention_weights, V)
    
    return output, attention_weights

def softmax(x):
    exp_x = np.exp(x - np.max(x, axis=-1, keepdims=True))
    return exp_x / exp_x.sum(axis=-1, keepdims=True)

# Example: "The cat sat on the mat"
# Each word attends to other words to understand context
```

### How LLMs Generate Text

```python
def generate_text(model, prompt, max_tokens=100, temperature=0.7):
    """
    Autoregressive text generation
    """
    tokens = tokenize(prompt)
    
    for _ in range(max_tokens):
        # 1. Get model predictions
        logits = model(tokens)
        
        # 2. Get probabilities for next token
        next_token_logits = logits[-1]
        
        # 3. Apply temperature (controls randomness)
        scaled_logits = next_token_logits / temperature
        probabilities = softmax(scaled_logits)
        
        # 4. Sample next token
        next_token = sample_from(probabilities)
        
        # 5. Check for end of sequence
        if next_token == EOS_TOKEN:
            break
        
        # 6. Append and continue
        tokens.append(next_token)
    
    return detokenize(tokens)
```

### Model Architectures

| Architecture | Examples | Characteristics |
|--------------|----------|-----------------|
| **Encoder-Only** | BERT, RoBERTa | Bidirectional, good for classification |
| **Decoder-Only** | GPT, LLaMA, Claude | Autoregressive, good for generation |
| **Encoder-Decoder** | T5, BART | Both directions, good for translation |

---

## 🔢 Embeddings and Vector Representations

### What are Embeddings?

Embeddings convert discrete items (words, sentences, images) into continuous vector spaces where similar items are close together.

```
┌──────────────────────────────────────────────────────────────────┐
│                    EMBEDDING SPACE (2D Simplified)               │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│     "king"  ●────────────────────────────● "queen"               │
│              \                          /                         │
│               \     gender vector      /                          │
│                \        ──────▶       /                           │
│                 \                    /                             │
│                  ●                  ●                              │
│               "man"             "woman"                            │
│                                                                   │
│     king - man + woman ≈ queen                                    │
│                                                                   │
│                    ●"dog"    ●"cat"                               │
│                          ●"pet"                                   │
│                                                                   │
│     ●"car"   ●"truck"                                            │
│           ●"vehicle"                                              │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Types of Embeddings

```python
# 1. Word Embeddings (Word2Vec, GloVe)
# Fixed vector per word, no context

# 2. Contextual Embeddings (BERT, GPT)
# Vector depends on surrounding context
# "bank" near "river" vs "bank" near "money"

# 3. Sentence Embeddings
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')
sentences = [
    "The weather is nice today",
    "It's a beautiful sunny day",
    "I love programming"
]

embeddings = model.encode(sentences)
print(f"Embedding shape: {embeddings.shape}")  # (3, 384)

# 4. Using OpenAI Embeddings
from openai import OpenAI
client = OpenAI()

response = client.embeddings.create(
    model="text-embedding-3-small",
    input="Hello world"
)
embedding = response.data[0].embedding
print(f"Embedding dimension: {len(embedding)}")  # 1536
```

### Similarity Measures

```python
import numpy as np

def cosine_similarity(a, b):
    """
    Most common similarity measure for embeddings
    Range: -1 to 1 (1 = identical)
    """
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def euclidean_distance(a, b):
    """
    Straight-line distance between points
    Range: 0 to infinity (0 = identical)
    """
    return np.linalg.norm(a - b)

def dot_product(a, b):
    """
    Simple dot product
    Considers both direction and magnitude
    """
    return np.dot(a, b)

# Example usage
query = model.encode("What's the weather like?")
doc = model.encode("Today is sunny and warm")

similarity = cosine_similarity(query, doc)
print(f"Similarity: {similarity:.4f}")  # ~0.65
```

---

## ⚙️ Training vs. Inference

### Training Phase

```
┌─────────────────────────────────────────────────────────────────┐
│                        TRAINING PHASE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MASSIVE DATA                                                   │
│        │                                                         │
│        ▼                                                         │
│   ┌──────────────┐         ┌──────────────┐                     │
│   │  TOKENIZER   │────────▶│    MODEL     │                     │
│   │              │         │  (billions   │                     │
│   │   "The"→1    │         │   of params) │                     │
│   │   "cat"→42   │         │              │                     │
│   └──────────────┘         └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            ┌──────────────┐                     │
│                            │    LOSS      │◀── Ground Truth     │
│                            │  FUNCTION    │                     │
│                            └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            ┌──────────────┐                     │
│                            │ BACKPROP &   │                     │
│                            │ OPTIMIZER    │                     │
│                            └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            UPDATE WEIGHTS                        │
│                                                                  │
│   Resources: 1000s of GPUs, weeks of compute, $millions         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Pre-training Objectives

```python
# 1. Causal Language Modeling (GPT-style)
# Predict next token given previous tokens
# "The cat sat on the ___" → "mat"

# 2. Masked Language Modeling (BERT-style)
# Predict masked tokens
# "The [MASK] sat on the mat" → "cat"

# 3. Contrastive Learning (Embedding models)
# Similar items close, dissimilar items far
```

### Fine-tuning

```python
# Supervised Fine-Tuning (SFT)
# Train on high-quality (prompt, response) pairs

# Reinforcement Learning from Human Feedback (RLHF)
# 1. Collect human preferences on responses
# 2. Train reward model on preferences
# 3. Optimize policy using PPO

# Direct Preference Optimization (DPO)
# Simpler alternative to RLHF
# Directly optimize on preference pairs
```

### Inference Phase

```
┌─────────────────────────────────────────────────────────────────┐
│                       INFERENCE PHASE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   USER PROMPT                                                    │
│        │                                                         │
│        ▼                                                         │
│   ┌──────────────┐         ┌──────────────┐                     │
│   │  TOKENIZER   │────────▶│ PRE-TRAINED  │                     │
│   │              │         │    MODEL     │                     │
│   │  (encode)    │         │  (frozen)    │                     │
│   └──────────────┘         └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            ┌──────────────┐                     │
│                            │    LOGITS    │                     │
│                            │  (raw scores)│                     │
│                            └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            ┌──────────────┐                     │
│                            │   SAMPLING   │                     │
│                            │  (temp, top-p│                     │
│                            │    top-k)    │                     │
│                            └──────────────┘                     │
│                                   │                              │
│                                   ▼                              │
│                            GENERATED TEXT                        │
│                                                                  │
│   Resources: Single GPU, milliseconds, ~$0.001                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Inference Parameters

```python
from openai import OpenAI
client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Write a poem"}],
    
    # Temperature: Controls randomness
    # 0.0 = Deterministic, 1.0+ = Creative/Random
    temperature=0.7,
    
    # Top-p (Nucleus Sampling): Only sample from top probability mass
    # 0.1 = Only top 10% probability tokens
    top_p=0.9,
    
    # Max Tokens: Limit response length
    max_tokens=500,
    
    # Stop Sequences: End generation at these strings
    stop=["\n\n", "END"],
    
    # Frequency/Presence Penalty: Reduce repetition
    frequency_penalty=0.5,  # Penalize repeated tokens
    presence_penalty=0.5,   # Penalize tokens that appeared at all
)
```

---

## 🔧 Relevance to AI Agents

### How These Concepts Power Agents

| Concept | Agent Application |
|---------|-------------------|
| **LLMs** | Brain for reasoning and generation |
| **Embeddings** | Memory storage and retrieval |
| **Attention** | Focus on relevant context |
| **Fine-tuning** | Customizing for specific domains |
| **Tokenization** | Processing text efficiently |

### Practical Implications

```python
# 1. Context Window Management
# LLMs have limited context - agents must manage it
def manage_context(messages, max_tokens=8000):
    """Truncate old messages to fit context window"""
    total_tokens = sum(count_tokens(m) for m in messages)
    while total_tokens > max_tokens:
        messages.pop(0)  # Remove oldest
        total_tokens = sum(count_tokens(m) for m in messages)
    return messages

# 2. Embedding-based Memory
# Store and retrieve relevant memories
class EmbeddingMemory:
    def __init__(self, embedding_model):
        self.model = embedding_model
        self.memories = []
        self.embeddings = []
    
    def add(self, memory: str):
        embedding = self.model.encode(memory)
        self.memories.append(memory)
        self.embeddings.append(embedding)
    
    def search(self, query: str, top_k: int = 5):
        query_embedding = self.model.encode(query)
        similarities = [cosine_similarity(query_embedding, e) 
                       for e in self.embeddings]
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        return [self.memories[i] for i in top_indices]

# 3. Tool Selection via Embeddings
# Match user intent to available tools
def select_tool(user_query: str, tools: list[dict]) -> str:
    query_emb = embed(user_query)
    tool_embs = [embed(t["description"]) for t in tools]
    similarities = [cosine_similarity(query_emb, te) for te in tool_embs]
    best_idx = np.argmax(similarities)
    return tools[best_idx]["name"]
```

---

## 📊 Model Comparison for Agents

| Aspect | Small Models | Large Models |
|--------|--------------|--------------|
| **Speed** | Fast (ms) | Slower (seconds) |
| **Cost** | Cheap | Expensive |
| **Accuracy** | Good for simple tasks | Better reasoning |
| **Context** | Often smaller | Larger windows |
| **Use Case** | Classification, extraction | Complex reasoning |

### Recommended Strategy

```
Simple tasks (extraction, classification):
└── GPT-3.5-turbo, Claude Haiku, Local 7B models

Complex reasoning (planning, multi-step):
└── GPT-4o, Claude 3.5 Sonnet, Claude 3 Opus

Cost-sensitive applications:
└── Mix of models based on task complexity
```

---

## 📝 Key Takeaways

1. **Neural Networks** learn patterns through forward/backward propagation
2. **Transformers** use attention to process sequences effectively
3. **Embeddings** represent meaning as vectors in continuous space
4. **LLMs** predict next tokens using massive pre-training
5. **Training** is expensive; **inference** is what agents use
6. Understanding these concepts helps you build better agents

---

## 🔗 What's Next?

Module 3: **AI Agent Frameworks** - Building agents with LangChain, AutoGen, and CrewAI

---

## 📚 Resources

### Papers
- "Attention Is All You Need" (Vaswani et al., 2017)
- "BERT: Pre-training of Deep Bidirectional Transformers" (Devlin et al., 2018)
- "Language Models are Few-Shot Learners" (GPT-3 paper, Brown et al., 2020)

### Courses
- [3Blue1Brown Neural Networks Series](https://youtube.com/3blue1brown)
- [Stanford CS224N: NLP with Deep Learning](https://web.stanford.edu/class/cs224n/)
- [fast.ai Practical Deep Learning](https://course.fast.ai/)

### Interactive Tools
- [Transformer Explainer](https://poloclub.github.io/transformer-explainer/)
- [CNN Explainer](https://poloclub.github.io/cnn-explainer/)
- [Embedding Projector](https://projector.tensorflow.org/)

---

*Module 2 Complete. Continue to Module 3: AI Agent Frameworks →*

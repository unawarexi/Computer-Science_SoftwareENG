# 📊 Embedding Models Comparison

## Overview

This document provides a comprehensive comparison of popular embedding models to help you choose the right one for your use case.

---

## 🏆 Top Embedding Models (2024-2025)

### OpenAI Models

| Model | Dimensions | Max Tokens | Best For | Cost |
|-------|------------|------------|----------|------|
| `text-embedding-3-large` | 3072 | 8191 | Highest accuracy | $0.00013/1K tokens |
| `text-embedding-3-small` | 1536 | 8191 | Balance of cost/performance | $0.00002/1K tokens |
| `text-embedding-ada-002` | 1536 | 8191 | Legacy, still reliable | $0.0001/1K tokens |

### Open Source Models

| Model | Dimensions | Max Tokens | Best For | Size |
|-------|------------|------------|----------|------|
| `all-MiniLM-L6-v2` | 384 | 256 | Fast, lightweight | 80MB |
| `all-mpnet-base-v2` | 768 | 384 | Better accuracy | 420MB |
| `e5-large-v2` | 1024 | 512 | High quality | 1.3GB |
| `bge-large-en-v1.5` | 1024 | 512 | MTEB leader | 1.3GB |
| `instructor-xl` | 768 | 512 | Task-specific | 4.9GB |

### Multilingual Models

| Model | Dimensions | Languages | Best For |
|-------|------------|-----------|----------|
| `multilingual-e5-large` | 1024 | 100+ | Cross-lingual search |
| `paraphrase-multilingual-MiniLM-L12-v2` | 384 | 50+ | Lightweight multilingual |
| `LaBSE` | 768 | 109 | Language-agnostic |

### Specialized Models

| Model | Dimensions | Specialization |
|-------|------------|----------------|
| `CodeBERT` | 768 | Code understanding |
| `StarEncoder` | 768 | Code search |
| `PubMedBERT` | 768 | Biomedical text |
| `LegalBERT` | 768 | Legal documents |
| `FinBERT` | 768 | Financial text |

---

## 📈 Performance Benchmarks (MTEB)

The Massive Text Embedding Benchmark (MTEB) scores:

| Model | Average Score | Retrieval | Clustering | Classification |
|-------|--------------|-----------|------------|----------------|
| text-embedding-3-large | 64.6 | 59.2 | 49.0 | 75.5 |
| bge-large-en-v1.5 | 64.2 | 59.5 | 48.8 | 75.3 |
| e5-large-v2 | 62.4 | 57.8 | 47.2 | 73.1 |
| all-mpnet-base-v2 | 57.8 | 49.4 | 43.7 | 65.2 |
| all-MiniLM-L6-v2 | 56.3 | 42.0 | 41.9 | 63.1 |

---

## 🎯 Model Selection Guide

### By Use Case

```
┌─────────────────────────────────────────────────────────────┐
│                    WHICH MODEL TO USE?                       │
└─────────────────────────────────────────────────────────────┘

Production + High Accuracy?
    └── YES → text-embedding-3-large
    └── NO  → Continue...

Need Multilingual?
    └── YES → multilingual-e5-large
    └── NO  → Continue...

Budget Constrained?
    └── YES → text-embedding-3-small (API) or bge-large (local)
    └── NO  → Continue...

Local/Private Deployment?
    └── YES → bge-large-en-v1.5 or e5-large-v2
    └── NO  → text-embedding-3-small

Speed Critical?
    └── YES → all-MiniLM-L6-v2
    └── NO  → all-mpnet-base-v2

Domain Specific?
    └── Code → CodeBERT/StarEncoder
    └── Medical → PubMedBERT
    └── Legal → LegalBERT
    └── Finance → FinBERT
```

### By Constraints

| Constraint | Recommended Model |
|------------|-------------------|
| Lowest latency | all-MiniLM-L6-v2 |
| Lowest cost | text-embedding-3-small |
| Best accuracy | text-embedding-3-large |
| No API dependency | bge-large-en-v1.5 |
| Edge/mobile | all-MiniLM-L6-v2 |
| Long documents | text-embedding-3-large (8K tokens) |

---

## 💻 Implementation Examples

### OpenAI

```python
from openai import OpenAI

client = OpenAI()

def embed_openai(texts, model="text-embedding-3-small"):
    response = client.embeddings.create(
        input=texts,
        model=model
    )
    return [d.embedding for d in response.data]
```

### Sentence Transformers (Local)

```python
from sentence_transformers import SentenceTransformer

# Load model
model = SentenceTransformer('BAAI/bge-large-en-v1.5')

def embed_local(texts):
    return model.encode(texts, normalize_embeddings=True)
```

### Cohere

```python
import cohere

co = cohere.Client('your-api-key')

def embed_cohere(texts, model="embed-english-v3.0"):
    response = co.embed(
        texts=texts,
        model=model,
        input_type="search_document"
    )
    return response.embeddings
```

### Voyage AI

```python
import voyageai

vo = voyageai.Client()

def embed_voyage(texts, model="voyage-2"):
    result = vo.embed(texts, model=model)
    return result.embeddings
```

---

## 📊 Cost Comparison (per 1M tokens)

| Provider | Model | Cost |
|----------|-------|------|
| OpenAI | text-embedding-3-small | $0.02 |
| OpenAI | text-embedding-3-large | $0.13 |
| Cohere | embed-english-v3.0 | $0.10 |
| Voyage AI | voyage-2 | $0.10 |
| Local | Any open source | $0 (compute only) |

---

## 🔄 Dimension Reduction

Some models support dimension reduction for efficiency:

```python
from openai import OpenAI

client = OpenAI()

# Reduce dimensions from 3072 to 256
response = client.embeddings.create(
    input="Your text",
    model="text-embedding-3-large",
    dimensions=256  # Reduced dimensions
)
```

Benefits:
- Faster similarity search
- Lower storage costs
- Slight accuracy trade-off

---

## 📚 Key Takeaways

1. **OpenAI text-embedding-3-small** - Best balance for most use cases
2. **bge-large-en-v1.5** - Best open-source option
3. **all-MiniLM-L6-v2** - Best for speed/edge deployment
4. **Consider domain-specific models** - When working in specialized fields
5. **Test on your data** - Benchmarks don't always reflect your specific use case

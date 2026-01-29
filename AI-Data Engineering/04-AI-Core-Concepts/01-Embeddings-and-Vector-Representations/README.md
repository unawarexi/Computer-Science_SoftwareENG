# 🔢 Embeddings and Vector Representations

## What Are Embeddings?

**Embeddings** are numerical representations of data (text, images, audio) in a continuous vector space. They transform human-understandable information into a format that machines can process and compare mathematically.

Think of embeddings as **coordinates in a high-dimensional space** where similar items are located close together.

---

## 🎯 Why Embeddings Matter

| Problem | Without Embeddings | With Embeddings |
|---------|-------------------|-----------------|
| Text Comparison | Exact string matching only | Semantic similarity |
| Search | Keyword-based | Meaning-based |
| ML Input | One-hot encoding (sparse) | Dense, meaningful vectors |
| Cross-modal | Cannot compare text to images | Unified representation space |

---

## 📐 Understanding Vector Space

### The Concept

```
Imagine a 3D space where:
- "King" is at position [0.8, 0.2, 0.9]
- "Queen" is at position [0.7, 0.3, 0.9]
- "Apple" is at position [0.1, 0.8, 0.2]

"King" and "Queen" are CLOSE (similar concepts)
"King" and "Apple" are FAR (different concepts)
```

### Real Embeddings

In practice, embeddings have **hundreds to thousands of dimensions**:
- OpenAI `text-embedding-ada-002`: 1536 dimensions
- OpenAI `text-embedding-3-small`: 1536 dimensions
- OpenAI `text-embedding-3-large`: 3072 dimensions
- Sentence-BERT: 384-768 dimensions
- Cohere Embed: 1024-4096 dimensions

---

## 🧮 How Embeddings Work

### 1. Training Process

Embedding models learn from massive datasets:

```
Training Data: Millions of text examples

Model learns:
- Words appearing in similar contexts → similar vectors
- Semantic relationships (king - man + woman ≈ queen)
- Contextual meaning (same word, different meanings)
```

### 2. The Embedding Process

```python
# Input text
text = "Machine learning is fascinating"

# Embedding model processes it
embedding = model.encode(text)

# Output: Dense vector
# [0.023, -0.156, 0.892, ..., 0.445]  # 1536 numbers
```

---

## 🔄 Types of Embeddings

### 1. Word Embeddings (Legacy)
- **Word2Vec**: One vector per word
- **GloVe**: Global Vectors for Word Representation
- **FastText**: Handles subword information

```python
# Word2Vec example
from gensim.models import Word2Vec

model = Word2Vec(sentences, vector_size=100, window=5)
vector = model.wv['computer']  # Get word vector
```

### 2. Sentence/Document Embeddings (Modern)
- **Sentence-BERT**: Sentence-level embeddings
- **OpenAI Embeddings**: State-of-the-art text embeddings
- **Cohere Embed**: Multilingual embeddings

```python
# OpenAI Embeddings
from openai import OpenAI

client = OpenAI()
response = client.embeddings.create(
    input="Your text here",
    model="text-embedding-3-small"
)
embedding = response.data[0].embedding
```

### 3. Multimodal Embeddings
- **CLIP**: Text and images in same space
- **ImageBind**: Audio, video, text, images unified

---

## 📊 Similarity Measures

### Cosine Similarity (Most Common)

Measures the angle between vectors (ignores magnitude):

```python
import numpy as np

def cosine_similarity(vec1, vec2):
    dot_product = np.dot(vec1, vec2)
    norm1 = np.linalg.norm(vec1)
    norm2 = np.linalg.norm(vec2)
    return dot_product / (norm1 * norm2)

# Result: -1 to 1
# 1 = identical direction (similar)
# 0 = perpendicular (unrelated)
# -1 = opposite (dissimilar)
```

### Euclidean Distance

Measures straight-line distance:

```python
def euclidean_distance(vec1, vec2):
    return np.linalg.norm(vec1 - vec2)

# Result: 0 to infinity
# 0 = identical
# Higher = more different
```

### Dot Product

Simple multiplication and sum:

```python
def dot_product(vec1, vec2):
    return np.dot(vec1, vec2)
```

---

## 💻 Practical Implementation

### Using OpenAI Embeddings

```python
from openai import OpenAI
import numpy as np

client = OpenAI()

def get_embedding(text, model="text-embedding-3-small"):
    """Get embedding for a single text."""
    response = client.embeddings.create(
        input=text,
        model=model
    )
    return response.data[0].embedding

def get_embeddings_batch(texts, model="text-embedding-3-small"):
    """Get embeddings for multiple texts efficiently."""
    response = client.embeddings.create(
        input=texts,
        model=model
    )
    return [item.embedding for item in response.data]

# Example usage
text1 = "I love programming"
text2 = "Coding is my passion"
text3 = "The weather is nice today"

emb1 = get_embedding(text1)
emb2 = get_embedding(text2)
emb3 = get_embedding(text3)

# Calculate similarities
sim_1_2 = cosine_similarity(np.array(emb1), np.array(emb2))
sim_1_3 = cosine_similarity(np.array(emb1), np.array(emb3))

print(f"Similarity (programming, coding): {sim_1_2:.4f}")  # High
print(f"Similarity (programming, weather): {sim_1_3:.4f}")  # Low
```

### Using Sentence-Transformers (Open Source)

```python
from sentence_transformers import SentenceTransformer

# Load model (runs locally)
model = SentenceTransformer('all-MiniLM-L6-v2')

# Get embeddings
sentences = [
    "Machine learning is a subset of AI",
    "Deep learning uses neural networks",
    "I like pizza"
]

embeddings = model.encode(sentences)

# embeddings.shape = (3, 384)
```

### Using HuggingFace Transformers

```python
from transformers import AutoTokenizer, AutoModel
import torch

tokenizer = AutoTokenizer.from_pretrained('sentence-transformers/all-MiniLM-L6-v2')
model = AutoModel.from_pretrained('sentence-transformers/all-MiniLM-L6-v2')

def get_embedding(text):
    inputs = tokenizer(text, return_tensors='pt', padding=True, truncation=True)
    with torch.no_grad():
        outputs = model(**inputs)
    # Mean pooling
    embeddings = outputs.last_hidden_state.mean(dim=1)
    return embeddings.numpy()[0]
```

---

## 🎨 Embedding Visualization

### t-SNE for 2D Visualization

```python
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt

# Assume we have embeddings and labels
embeddings = np.array([...])  # Shape: (n_samples, embedding_dim)
labels = ["cat", "dog", "car", "truck", ...]

# Reduce to 2D
tsne = TSNE(n_components=2, random_state=42)
embeddings_2d = tsne.fit_transform(embeddings)

# Plot
plt.figure(figsize=(10, 8))
plt.scatter(embeddings_2d[:, 0], embeddings_2d[:, 1])
for i, label in enumerate(labels):
    plt.annotate(label, (embeddings_2d[i, 0], embeddings_2d[i, 1]))
plt.title("Embedding Space Visualization")
plt.show()
```

---

## 📈 Best Practices

### 1. Choose the Right Model

| Use Case | Recommended Model |
|----------|-------------------|
| General purpose | OpenAI text-embedding-3-small |
| High accuracy | OpenAI text-embedding-3-large |
| Local/Free | all-MiniLM-L6-v2 |
| Multilingual | multilingual-e5-large |
| Code | CodeBERT, StarEncoder |

### 2. Preprocessing Tips

```python
def preprocess_for_embedding(text):
    """Prepare text for embedding."""
    # Remove excessive whitespace
    text = ' '.join(text.split())
    
    # Truncate if too long (most models have limits)
    max_chars = 8000  # Adjust based on model
    if len(text) > max_chars:
        text = text[:max_chars]
    
    return text
```

### 3. Batch Processing

```python
# DON'T: One API call per text (slow, expensive)
for text in texts:
    embedding = get_embedding(text)

# DO: Batch processing
embeddings = get_embeddings_batch(texts)  # Single API call
```

### 4. Caching Embeddings

```python
import hashlib
import json

def get_cached_embedding(text, cache_file="embeddings_cache.json"):
    """Cache embeddings to avoid recomputation."""
    text_hash = hashlib.md5(text.encode()).hexdigest()
    
    # Load cache
    try:
        with open(cache_file, 'r') as f:
            cache = json.load(f)
    except FileNotFoundError:
        cache = {}
    
    # Check cache
    if text_hash in cache:
        return cache[text_hash]
    
    # Compute and cache
    embedding = get_embedding(text)
    cache[text_hash] = embedding
    
    with open(cache_file, 'w') as f:
        json.dump(cache, f)
    
    return embedding
```

---

## 🔗 Embeddings in the RAG Pipeline

```
User Query: "How does photosynthesis work?"
                    │
                    ▼
            ┌───────────────┐
            │ Query Embedding│
            │ [0.2, -0.5, ...]│
            └───────────────┘
                    │
                    ▼
            ┌───────────────┐
            │  Vector Search │
            │  (Similarity)  │
            └───────────────┘
                    │
                    ▼
            ┌───────────────┐
            │ Top K Results  │
            │ Ranked by      │
            │ Cosine Sim     │
            └───────────────┘
                    │
                    ▼
            Context for LLM
```

---

## 📚 Key Takeaways

1. **Embeddings convert meaning to numbers** - enabling mathematical comparison
2. **Similar concepts = similar vectors** - close in vector space
3. **Cosine similarity is standard** - for comparing embeddings
4. **Batch process when possible** - for efficiency
5. **Cache embeddings** - avoid recomputation costs

---

## 🔗 Next Steps

Continue to [02-Tokenization-and-Text-Processing](../02-Tokenization-and-Text-Processing) to understand how text is prepared before embedding.

---

## 📖 Further Reading

- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [Sentence-Transformers Documentation](https://www.sbert.net/)
- [Understanding Word Vectors](https://jalammar.github.io/illustrated-word2vec/)

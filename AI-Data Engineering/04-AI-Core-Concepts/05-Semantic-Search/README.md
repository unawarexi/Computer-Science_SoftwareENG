# 🔎 Semantic Search

## What is Semantic Search?

**Semantic Search** finds information based on **meaning and intent**, not just keyword matching. It understands that "car" and "automobile" are related, even without exact word overlap.

Think of it as **searching by concept**, not by dictionary lookup.

---

## 🎯 Keyword Search vs Semantic Search

| Aspect | Keyword Search | Semantic Search |
|--------|---------------|-----------------|
| **How it works** | Exact/fuzzy string matching | Vector similarity |
| **Query: "car"** | Only finds "car" | Finds "automobile", "vehicle", "sedan" |
| **Synonyms** | Manual synonyms needed | Automatic understanding |
| **Typos** | Fuzzy matching needed | Often handles naturally |
| **Context** | Ignores context | Understands context |
| **Speed** | Very fast | Slightly slower |

---

## 🏗️ How Semantic Search Works

```
┌──────────────────────────────────────────────────────────────┐
│                    SEMANTIC SEARCH PIPELINE                   │
└──────────────────────────────────────────────────────────────┘

    INDEXING (Offline)
    ──────────────────
    
    Documents → Chunk → Embed → Store in Vector DB
         │         │        │           │
         ▼         ▼        ▼           ▼
    [Doc1, Doc2] [Chunks] [Vectors] [Index]
    
    
    QUERYING (Online)
    ─────────────────
    
    User Query → Embed → Search Vector DB → Rank → Return Results
         │          │            │            │          │
         ▼          ▼            ▼            ▼          ▼
    "How to..."  [Query Vec]  [Similar Vecs]  [Top K]  [Results]
```

---

## 💻 Building a Semantic Search System

### Step 1: Document Preparation

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

def prepare_documents(documents):
    """Chunk documents for indexing."""
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50
    )
    
    chunks = []
    for doc in documents:
        doc_chunks = splitter.split_text(doc['content'])
        for i, chunk in enumerate(doc_chunks):
            chunks.append({
                'id': f"{doc['id']}_chunk_{i}",
                'content': chunk,
                'source': doc['source'],
                'metadata': doc.get('metadata', {})
            })
    
    return chunks
```

### Step 2: Create Embeddings and Index

```python
from openai import OpenAI
import chromadb

client = OpenAI()
chroma_client = chromadb.PersistentClient(path="./search_db")

def create_search_index(chunks, collection_name="documents"):
    """Create searchable index from chunks."""
    
    # Get embeddings
    texts = [chunk['content'] for chunk in chunks]
    
    # Batch embed (max 2048 per request for OpenAI)
    embeddings = []
    batch_size = 2048
    for i in range(0, len(texts), batch_size):
        batch = texts[i:i + batch_size]
        response = client.embeddings.create(
            input=batch,
            model="text-embedding-3-small"
        )
        embeddings.extend([d.embedding for d in response.data])
    
    # Create collection
    collection = chroma_client.get_or_create_collection(
        name=collection_name,
        metadata={"hnsw:space": "cosine"}
    )
    
    # Add to collection
    collection.add(
        ids=[chunk['id'] for chunk in chunks],
        embeddings=embeddings,
        documents=texts,
        metadatas=[{
            'source': chunk['source'],
            **chunk['metadata']
        } for chunk in chunks]
    )
    
    return collection
```

### Step 3: Implement Search

```python
def semantic_search(query, collection, n_results=5):
    """Search for relevant documents."""
    
    # Embed query
    response = client.embeddings.create(
        input=query,
        model="text-embedding-3-small"
    )
    query_embedding = response.data[0].embedding
    
    # Search
    results = collection.query(
        query_embeddings=[query_embedding],
        n_results=n_results,
        include=['documents', 'metadatas', 'distances']
    )
    
    # Format results
    formatted = []
    for i in range(len(results['ids'][0])):
        formatted.append({
            'id': results['ids'][0][i],
            'content': results['documents'][0][i],
            'metadata': results['metadatas'][0][i],
            'similarity': 1 - results['distances'][0][i]  # Convert distance to similarity
        })
    
    return formatted

# Usage
results = semantic_search("How does machine learning work?", collection)
for r in results:
    print(f"[{r['similarity']:.3f}] {r['content'][:100]}...")
```

---

## 🔄 Hybrid Search

Combine keyword and semantic search for best results:

### BM25 + Semantic

```python
from rank_bm25 import BM25Okapi
import numpy as np

class HybridSearcher:
    def __init__(self, documents, embeddings, alpha=0.5):
        """
        alpha: Weight for semantic search (1-alpha for keyword)
        """
        self.documents = documents
        self.embeddings = np.array(embeddings)
        self.alpha = alpha
        
        # Create BM25 index
        tokenized = [doc.lower().split() for doc in documents]
        self.bm25 = BM25Okapi(tokenized)
    
    def search(self, query, query_embedding, k=10):
        # Keyword scores (BM25)
        keyword_scores = self.bm25.get_scores(query.lower().split())
        keyword_scores = keyword_scores / (keyword_scores.max() + 1e-6)  # Normalize
        
        # Semantic scores (cosine similarity)
        query_emb = np.array(query_embedding)
        semantic_scores = np.dot(self.embeddings, query_emb)
        semantic_scores = (semantic_scores + 1) / 2  # Normalize to 0-1
        
        # Combine scores
        combined = self.alpha * semantic_scores + (1 - self.alpha) * keyword_scores
        
        # Get top k
        top_indices = np.argsort(combined)[::-1][:k]
        
        return [
            {
                'document': self.documents[i],
                'score': combined[i],
                'keyword_score': keyword_scores[i],
                'semantic_score': semantic_scores[i]
            }
            for i in top_indices
        ]
```

### Using Weaviate Hybrid Search

```python
import weaviate

client = weaviate.connect_to_local()
collection = client.collections.get("Documents")

# Hybrid search (automatic combination)
response = collection.query.hybrid(
    query="machine learning algorithms",
    alpha=0.5,  # 0 = keyword only, 1 = semantic only
    limit=10
)

for obj in response.objects:
    print(f"[{obj.metadata.score:.3f}] {obj.properties['content'][:100]}...")
```

---

## 🎯 Search Quality Improvements

### 1. Query Expansion

```python
def expand_query(query, client):
    """Expand query with related terms."""
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{
            "role": "system",
            "content": "Generate 3 alternative phrasings of the query. Return only the alternatives, one per line."
        }, {
            "role": "user",
            "content": query
        }]
    )
    
    alternatives = response.choices[0].message.content.strip().split('\n')
    return [query] + alternatives

# Search with expanded queries
def search_with_expansion(query, collection):
    expanded = expand_query(query)
    all_results = []
    
    for q in expanded:
        results = semantic_search(q, collection, n_results=3)
        all_results.extend(results)
    
    # Deduplicate and re-rank
    seen = set()
    unique_results = []
    for r in sorted(all_results, key=lambda x: x['similarity'], reverse=True):
        if r['id'] not in seen:
            seen.add(r['id'])
            unique_results.append(r)
    
    return unique_results[:10]
```

### 2. Re-ranking

```python
from openai import OpenAI

def rerank_results(query, results, client):
    """Re-rank results using LLM."""
    
    # Format results for ranking
    docs = [r['content'] for r in results]
    
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{
            "role": "system",
            "content": """Rank these documents by relevance to the query.
            Return only the indices in order of relevance (most relevant first).
            Format: 1, 3, 2, 5, 4"""
        }, {
            "role": "user",
            "content": f"Query: {query}\n\nDocuments:\n" + 
                       "\n\n".join([f"{i+1}. {doc}" for i, doc in enumerate(docs)])
        }]
    )
    
    # Parse ranking
    ranking = response.choices[0].message.content.strip()
    indices = [int(x.strip()) - 1 for x in ranking.split(',')]
    
    return [results[i] for i in indices if i < len(results)]
```

### 3. Contextual Embeddings

```python
def embed_with_context(text, context_type="search_document"):
    """Generate embeddings with context type."""
    
    # Some models support context type
    # Cohere example:
    import cohere
    co = cohere.Client()
    
    response = co.embed(
        texts=[text],
        model="embed-english-v3.0",
        input_type=context_type  # "search_document" or "search_query"
    )
    
    return response.embeddings[0]

# Use different context for queries vs documents
doc_embedding = embed_with_context(document, "search_document")
query_embedding = embed_with_context(query, "search_query")
```

---

## 📊 Evaluating Search Quality

### Metrics

```python
def calculate_metrics(results, relevant_ids, k=10):
    """Calculate search quality metrics."""
    
    retrieved = [r['id'] for r in results[:k]]
    
    # Precision@k
    relevant_retrieved = len(set(retrieved) & set(relevant_ids))
    precision = relevant_retrieved / k
    
    # Recall@k
    recall = relevant_retrieved / len(relevant_ids) if relevant_ids else 0
    
    # MRR (Mean Reciprocal Rank)
    mrr = 0
    for i, id in enumerate(retrieved):
        if id in relevant_ids:
            mrr = 1 / (i + 1)
            break
    
    # NDCG@k (Normalized Discounted Cumulative Gain)
    dcg = sum([
        1 / np.log2(i + 2) if retrieved[i] in relevant_ids else 0
        for i in range(k)
    ])
    ideal_dcg = sum([1 / np.log2(i + 2) for i in range(min(k, len(relevant_ids)))])
    ndcg = dcg / ideal_dcg if ideal_dcg > 0 else 0
    
    return {
        'precision@k': precision,
        'recall@k': recall,
        'mrr': mrr,
        'ndcg@k': ndcg
    }
```

---

## 🛠️ Production Considerations

### 1. Caching

```python
from functools import lru_cache
import hashlib

@lru_cache(maxsize=1000)
def cached_embed(text):
    """Cache embeddings to avoid redundant API calls."""
    return tuple(get_embedding(text))

def cached_search(query, collection):
    query_hash = hashlib.md5(query.encode()).hexdigest()
    # Check cache...
    return semantic_search(query, collection)
```

### 2. Async Search

```python
import asyncio
from openai import AsyncOpenAI

async def async_semantic_search(queries, collection):
    """Search multiple queries concurrently."""
    client = AsyncOpenAI()
    
    async def embed_and_search(query):
        response = await client.embeddings.create(
            input=query,
            model="text-embedding-3-small"
        )
        embedding = response.data[0].embedding
        return collection.query(
            query_embeddings=[embedding],
            n_results=5
        )
    
    results = await asyncio.gather(*[
        embed_and_search(q) for q in queries
    ])
    
    return results
```

### 3. Filtering

```python
# Pre-filter by metadata for efficiency
results = collection.query(
    query_embeddings=[query_embedding],
    n_results=10,
    where={
        "$and": [
            {"category": {"$eq": "technology"}},
            {"date": {"$gte": "2024-01-01"}}
        ]
    }
)
```

---

## 📚 Key Takeaways

1. **Semantic > Keyword** for understanding intent
2. **Hybrid search** combines the best of both
3. **Re-ranking** improves relevance
4. **Query expansion** handles variations
5. **Measure quality** with proper metrics

---

## 🔗 Next Steps

Continue to [06-RAG-Fundamentals](../06-RAG-Fundamentals) to learn how to use search results with LLMs.

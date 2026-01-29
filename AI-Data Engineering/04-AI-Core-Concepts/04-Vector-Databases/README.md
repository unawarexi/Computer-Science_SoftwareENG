# 🗄️ Vector Databases

## What is a Vector Database?

A **Vector Database** is a specialized database designed to store, index, and query high-dimensional vectors (embeddings). Unlike traditional databases that search by exact matches, vector databases find items by **similarity**.

Think of it as **a library where books are organized by meaning**, not alphabetically.

---

## 🎯 Why Vector Databases?

| Traditional Database | Vector Database |
|---------------------|-----------------|
| Exact match queries | Similarity queries |
| "Find user with ID 123" | "Find similar products" |
| SQL: `WHERE name = 'John'` | "Find documents about X" |
| Indexes on columns | Indexes on vectors |
| Millisecond exact lookups | Millisecond similarity search |

---

## 🏗️ How Vector Databases Work

```
┌──────────────────────────────────────────────────────────────┐
│                  VECTOR DATABASE ARCHITECTURE                 │
└──────────────────────────────────────────────────────────────┘

    1. INDEXING PHASE
    ─────────────────
    Text/Data → Embedding Model → Vector [0.1, -0.3, ...] 
                                        │
                                        ▼
                                  ┌──────────┐
                                  │  INDEX   │
                                  │ (HNSW,   │
                                  │  IVF,    │
                                  │  etc.)   │
                                  └──────────┘
                                        │
                                        ▼
                                  ┌──────────┐
                                  │ STORAGE  │
                                  └──────────┘

    2. QUERY PHASE
    ──────────────
    Query → Embedding Model → Query Vector [0.2, -0.1, ...]
                                        │
                                        ▼
                                  ┌──────────┐
                                  │  INDEX   │──→ Find nearest neighbors
                                  └──────────┘
                                        │
                                        ▼
                              Top K similar vectors
                                        │
                                        ▼
                              Return results + metadata
```

---

## 📊 Popular Vector Databases

### Cloud-Hosted (Managed)

| Database | Best For | Free Tier | Key Features |
|----------|----------|-----------|--------------|
| **Pinecone** | Production, enterprise | 1 index, 100K vectors | Fully managed, fast |
| **Weaviate Cloud** | Hybrid search | Limited | GraphQL, modules |
| **Qdrant Cloud** | High performance | 1GB free | Rust-based, fast |
| **Zilliz Cloud** | Large scale | Limited | Milvus managed |

### Self-Hosted (Open Source)

| Database | Best For | Language | Key Features |
|----------|----------|----------|--------------|
| **ChromaDB** | Development, prototyping | Python | Simple API, embedded |
| **Weaviate** | Production | Go | Hybrid search, modules |
| **Milvus** | Large scale | Go/C++ | Distributed, GPU support |
| **Qdrant** | Performance | Rust | Fast, rich filtering |
| **FAISS** | Research, embedded | C++/Python | Facebook's library |
| **pgvector** | PostgreSQL users | SQL | Postgres extension |

---

## 💻 Implementation Examples

### ChromaDB (Easiest to Start)

```python
import chromadb
from chromadb.utils import embedding_functions

# Initialize client
client = chromadb.Client()  # In-memory
# client = chromadb.PersistentClient(path="./chroma_db")  # Persistent

# Create embedding function
openai_ef = embedding_functions.OpenAIEmbeddingFunction(
    api_key="your-api-key",
    model_name="text-embedding-3-small"
)

# Create collection
collection = client.create_collection(
    name="my_documents",
    embedding_function=openai_ef
)

# Add documents
collection.add(
    documents=[
        "Machine learning is a subset of AI",
        "Deep learning uses neural networks",
        "Natural language processing handles text"
    ],
    ids=["doc1", "doc2", "doc3"],
    metadatas=[
        {"topic": "ML", "source": "textbook"},
        {"topic": "DL", "source": "paper"},
        {"topic": "NLP", "source": "article"}
    ]
)

# Query
results = collection.query(
    query_texts=["What is artificial intelligence?"],
    n_results=2
)

print(results['documents'])
print(results['distances'])
```

### Pinecone

```python
from pinecone import Pinecone, ServerlessSpec
from openai import OpenAI

# Initialize
pc = Pinecone(api_key="your-pinecone-api-key")
openai_client = OpenAI()

# Create index
pc.create_index(
    name="my-index",
    dimension=1536,  # OpenAI embedding dimension
    metric="cosine",
    spec=ServerlessSpec(
        cloud="aws",
        region="us-east-1"
    )
)

# Connect to index
index = pc.Index("my-index")

# Generate embeddings
def get_embedding(text):
    response = openai_client.embeddings.create(
        input=text,
        model="text-embedding-3-small"
    )
    return response.data[0].embedding

# Upsert vectors
documents = [
    {"id": "doc1", "text": "Machine learning basics"},
    {"id": "doc2", "text": "Deep learning fundamentals"},
    {"id": "doc3", "text": "NLP techniques"}
]

vectors = []
for doc in documents:
    embedding = get_embedding(doc["text"])
    vectors.append({
        "id": doc["id"],
        "values": embedding,
        "metadata": {"text": doc["text"]}
    })

index.upsert(vectors=vectors)

# Query
query_embedding = get_embedding("What is AI?")
results = index.query(
    vector=query_embedding,
    top_k=3,
    include_metadata=True
)

for match in results['matches']:
    print(f"Score: {match['score']:.4f} - {match['metadata']['text']}")
```

### Weaviate

```python
import weaviate
from weaviate.classes.config import Configure, Property, DataType

# Connect
client = weaviate.connect_to_local()  # or connect_to_wcs() for cloud

# Create collection (class)
client.collections.create(
    name="Document",
    vectorizer_config=Configure.Vectorizer.text2vec_openai(),
    properties=[
        Property(name="content", data_type=DataType.TEXT),
        Property(name="source", data_type=DataType.TEXT),
    ]
)

# Get collection
documents = client.collections.get("Document")

# Add objects
documents.data.insert({
    "content": "Machine learning is fascinating",
    "source": "textbook"
})

# Query with near_text
response = documents.query.near_text(
    query="artificial intelligence",
    limit=5
)

for obj in response.objects:
    print(obj.properties)

client.close()
```

### Qdrant

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# Initialize client
client = QdrantClient(":memory:")  # In-memory
# client = QdrantClient(host="localhost", port=6333)  # Docker

# Create collection
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(size=1536, distance=Distance.COSINE)
)

# Add points
points = [
    PointStruct(
        id=1,
        vector=embedding1,  # Your embedding vector
        payload={"text": "Machine learning", "source": "textbook"}
    ),
    PointStruct(
        id=2,
        vector=embedding2,
        payload={"text": "Deep learning", "source": "paper"}
    )
]

client.upsert(
    collection_name="documents",
    points=points
)

# Search
results = client.search(
    collection_name="documents",
    query_vector=query_embedding,
    limit=3
)

for result in results:
    print(f"Score: {result.score:.4f} - {result.payload}")
```

### FAISS (Facebook AI Similarity Search)

```python
import faiss
import numpy as np

# Create index
dimension = 1536
index = faiss.IndexFlatL2(dimension)  # L2 distance
# index = faiss.IndexFlatIP(dimension)  # Inner product (cosine)

# Add vectors
vectors = np.array(embeddings).astype('float32')
index.add(vectors)

# Search
query = np.array([query_embedding]).astype('float32')
distances, indices = index.search(query, k=5)

print(f"Top 5 indices: {indices[0]}")
print(f"Distances: {distances[0]}")

# Save/Load index
faiss.write_index(index, "my_index.faiss")
index = faiss.read_index("my_index.faiss")
```

### pgvector (PostgreSQL)

```sql
-- Enable extension
CREATE EXTENSION vector;

-- Create table
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding vector(1536)
);

-- Insert
INSERT INTO documents (content, embedding) 
VALUES ('Machine learning basics', '[0.1, 0.2, ...]');

-- Query nearest neighbors
SELECT content, embedding <-> '[0.1, 0.2, ...]' AS distance
FROM documents
ORDER BY embedding <-> '[0.1, 0.2, ...]'
LIMIT 5;
```

```python
# Using psycopg2
import psycopg2
from pgvector.psycopg2 import register_vector

conn = psycopg2.connect("postgresql://...")
register_vector(conn)

cur = conn.cursor()
cur.execute(
    "SELECT content FROM documents ORDER BY embedding <-> %s LIMIT 5",
    (query_embedding,)
)
results = cur.fetchall()
```

---

## 🔍 Indexing Algorithms

### HNSW (Hierarchical Navigable Small World)

```
Most popular for production use

Pros:
- Very fast queries
- Good accuracy
- Works well at scale

Cons:
- Higher memory usage
- Slower index building

Used by: Pinecone, Weaviate, Qdrant, ChromaDB
```

### IVF (Inverted File Index)

```
Clusters vectors, searches relevant clusters

Pros:
- Memory efficient
- Good for large datasets

Cons:
- Requires training
- May miss some results

Used by: FAISS, Milvus
```

### Flat (Brute Force)

```
Compares query to every vector

Pros:
- 100% accurate
- No index building

Cons:
- Slow for large datasets
- O(n) search time

Used by: Small datasets, validation
```

---

## 🎛️ Distance Metrics

| Metric | Formula | Use Case |
|--------|---------|----------|
| **Cosine** | 1 - cos(θ) | Normalized embeddings (most common) |
| **Euclidean (L2)** | √Σ(a-b)² | Raw embeddings |
| **Dot Product** | Σ(a×b) | When magnitude matters |

```python
# Choosing the right metric
if embeddings_are_normalized:
    metric = "cosine"  # or "dot_product" (equivalent when normalized)
else:
    metric = "euclidean"
```

---

## 📊 Comparison Table

| Feature | ChromaDB | Pinecone | Weaviate | Qdrant | Milvus |
|---------|----------|----------|----------|--------|--------|
| **Ease of Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Performance** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Scalability** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Self-hosted** | ✅ | ❌ | ✅ | ✅ | ✅ |
| **Managed** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Free Tier** | Unlimited | Limited | Limited | Limited | Limited |
| **Hybrid Search** | ❌ | ❌ | ✅ | ✅ | ✅ |

---

## 🛠️ Best Practices

### 1. Choose the Right Database

```
Prototyping → ChromaDB
Production (managed) → Pinecone or Qdrant Cloud
Production (self-hosted) → Qdrant or Weaviate
Large scale → Milvus
Existing PostgreSQL → pgvector
```

### 2. Optimize for Your Use Case

```python
# For faster queries, use approximate search
index.search(vector, k=10, approximate=True)

# For better accuracy, use exact search (slower)
index.search(vector, k=10, approximate=False)
```

### 3. Use Metadata Filtering

```python
# Filter before vector search for efficiency
results = collection.query(
    query_embeddings=[query_embedding],
    n_results=10,
    where={"category": "technology"}  # Pre-filter
)
```

### 4. Batch Operations

```python
# DON'T: Insert one at a time
for doc in documents:
    collection.add(documents=[doc])

# DO: Batch insert
collection.add(documents=documents)  # All at once
```

---

## 📚 Key Takeaways

1. **Vector DBs enable semantic search** - Find by meaning, not keywords
2. **Choose based on needs** - Prototyping vs production vs scale
3. **HNSW is the standard** - Fast and accurate for most cases
4. **Use cosine similarity** - Standard for normalized embeddings
5. **Leverage metadata** - Filter before vector search

---

## 🔗 Next Steps

Continue to [05-Semantic-Search](../05-Semantic-Search) to learn how to implement effective search systems.

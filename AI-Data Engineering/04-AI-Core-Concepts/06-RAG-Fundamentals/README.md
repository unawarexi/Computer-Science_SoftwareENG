# 🔄 RAG - Retrieval Augmented Generation

## What is RAG?

**Retrieval Augmented Generation (RAG)** is a technique that enhances LLM responses by retrieving relevant information from external knowledge sources before generating an answer.

Think of it as **giving the LLM a reference library** to consult before answering.

---

## 🎯 Why RAG?

| Problem with Pure LLMs | RAG Solution |
|----------------------|--------------|
| Knowledge cutoff date | Access current information |
| Hallucinations | Ground responses in facts |
| No private data access | Query your own documents |
| Generic responses | Domain-specific answers |
| Can't cite sources | Provides references |

---

## 🏗️ RAG Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                         RAG PIPELINE                                  │
└──────────────────────────────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────────────────────────┐
    │                     OFFLINE: INDEXING                           │
    └─────────────────────────────────────────────────────────────────┘
    
    Documents → Load → Chunk → Embed → Store in Vector DB
         │        │       │       │            │
         ▼        ▼       ▼       ▼            ▼
      [PDFs,   [Text]  [500    [Vectors]   [Indexed
       URLs,           tokens              & Ready]
       DBs]            each]
    
    
    ┌─────────────────────────────────────────────────────────────────┐
    │                     ONLINE: RETRIEVAL + GENERATION               │
    └─────────────────────────────────────────────────────────────────┘
    
    User Query
         │
         ▼
    ┌─────────┐     ┌──────────────┐     ┌─────────────┐
    │  Embed  │────▶│ Vector Search │────▶│  Retrieved  │
    │  Query  │     │   (Top K)     │     │   Context   │
    └─────────┘     └──────────────┘     └─────────────┘
                                               │
                                               ▼
                                    ┌─────────────────┐
         ┌──────────────────────────│ Prompt Template │
         │                          │ Query + Context │
         │                          └─────────────────┘
         │                                   │
         ▼                                   ▼
    ┌─────────┐                      ┌─────────────┐
    │   LLM   │◀─────────────────────│   Augmented │
    │         │                      │    Prompt   │
    └─────────┘                      └─────────────┘
         │
         ▼
    Generated Response with Sources
```

---

## 💻 Building a RAG System

### Complete Implementation

```python
from openai import OpenAI
from langchain.text_splitter import RecursiveCharacterTextSplitter
import chromadb

class RAGSystem:
    def __init__(self, collection_name="rag_docs"):
        self.client = OpenAI()
        self.chroma = chromadb.PersistentClient(path="./rag_db")
        self.collection = self.chroma.get_or_create_collection(
            name=collection_name,
            metadata={"hnsw:space": "cosine"}
        )
        self.splitter = RecursiveCharacterTextSplitter(
            chunk_size=500,
            chunk_overlap=50
        )
    
    def add_documents(self, documents):
        """Index documents for retrieval."""
        all_chunks = []
        all_ids = []
        all_metadatas = []
        
        for doc_id, doc in enumerate(documents):
            chunks = self.splitter.split_text(doc['content'])
            for i, chunk in enumerate(chunks):
                all_chunks.append(chunk)
                all_ids.append(f"doc{doc_id}_chunk{i}")
                all_metadatas.append({
                    'source': doc.get('source', 'unknown'),
                    'title': doc.get('title', ''),
                    'doc_id': str(doc_id)
                })
        
        # Batch embed
        embeddings = self._embed_texts(all_chunks)
        
        # Add to collection
        self.collection.add(
            ids=all_ids,
            embeddings=embeddings,
            documents=all_chunks,
            metadatas=all_metadatas
        )
        
        print(f"Indexed {len(all_chunks)} chunks from {len(documents)} documents")
    
    def _embed_texts(self, texts):
        """Generate embeddings for texts."""
        embeddings = []
        batch_size = 2048
        
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            response = self.client.embeddings.create(
                input=batch,
                model="text-embedding-3-small"
            )
            embeddings.extend([d.embedding for d in response.data])
        
        return embeddings
    
    def retrieve(self, query, k=5):
        """Retrieve relevant chunks for query."""
        query_embedding = self._embed_texts([query])[0]
        
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=k,
            include=['documents', 'metadatas', 'distances']
        )
        
        retrieved = []
        for i in range(len(results['ids'][0])):
            retrieved.append({
                'content': results['documents'][0][i],
                'metadata': results['metadatas'][0][i],
                'similarity': 1 - results['distances'][0][i]
            })
        
        return retrieved
    
    def generate(self, query, context_chunks, model="gpt-4"):
        """Generate response using retrieved context."""
        
        # Format context
        context = "\n\n---\n\n".join([
            f"Source: {c['metadata'].get('source', 'unknown')}\n{c['content']}"
            for c in context_chunks
        ])
        
        # Create prompt
        prompt = f"""Use the following context to answer the question. 
If the answer is not in the context, say "I don't have enough information to answer this."
Always cite your sources.

Context:
{context}

Question: {query}

Answer:"""
        
        response = self.client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": "You are a helpful assistant that answers questions based on provided context."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7
        )
        
        return response.choices[0].message.content
    
    def query(self, question, k=5):
        """Full RAG pipeline: retrieve and generate."""
        # Retrieve
        context_chunks = self.retrieve(question, k=k)
        
        # Generate
        answer = self.generate(question, context_chunks)
        
        return {
            'answer': answer,
            'sources': [c['metadata'] for c in context_chunks],
            'context': context_chunks
        }


# Usage
rag = RAGSystem()

# Add documents
documents = [
    {
        'content': "Machine learning is a subset of AI that enables systems to learn from data...",
        'source': "ML Textbook",
        'title': "Introduction to ML"
    },
    {
        'content': "Deep learning uses neural networks with many layers...",
        'source': "DL Guide",
        'title': "Deep Learning Basics"
    }
]
rag.add_documents(documents)

# Query
result = rag.query("What is the difference between ML and deep learning?")
print(result['answer'])
print("\nSources:", result['sources'])
```

---

## 🔧 RAG Components Deep Dive

### 1. Document Loading

```python
from langchain_community.document_loaders import (
    PyPDFLoader,
    TextLoader,
    UnstructuredHTMLLoader,
    WebBaseLoader,
    DirectoryLoader
)

# PDF
pdf_loader = PyPDFLoader("document.pdf")
pdf_docs = pdf_loader.load()

# Web pages
web_loader = WebBaseLoader(["https://example.com/page1", "https://example.com/page2"])
web_docs = web_loader.load()

# Directory of files
dir_loader = DirectoryLoader(
    "./documents/",
    glob="**/*.txt",
    loader_cls=TextLoader
)
all_docs = dir_loader.load()
```

### 2. Advanced Chunking

```python
from langchain.text_splitter import (
    RecursiveCharacterTextSplitter,
    MarkdownHeaderTextSplitter,
    TokenTextSplitter
)

# For markdown documents
markdown_splitter = MarkdownHeaderTextSplitter(
    headers_to_split_on=[
        ("#", "Header 1"),
        ("##", "Header 2"),
        ("###", "Header 3"),
    ]
)

# Token-based (precise for LLM context)
token_splitter = TokenTextSplitter(
    chunk_size=500,
    chunk_overlap=50
)
```

### 3. Retrieval Strategies

```python
# Basic retrieval
results = vectorstore.similarity_search(query, k=5)

# With score threshold
results = vectorstore.similarity_search_with_score(query, k=10)
filtered = [(doc, score) for doc, score in results if score > 0.7]

# MMR (Maximum Marginal Relevance) - for diversity
results = vectorstore.max_marginal_relevance_search(
    query,
    k=5,
    fetch_k=20,  # Fetch more, then select diverse subset
    lambda_mult=0.5  # 0 = max diversity, 1 = max relevance
)
```

### 4. Prompt Engineering for RAG

```python
RAG_PROMPT_TEMPLATE = """You are a helpful assistant. Use the following pieces of context to answer the question at the end.

Guidelines:
- If you don't know the answer from the context, say "I don't have information about that in my knowledge base."
- Always cite which source your information comes from
- Be concise but thorough
- If the context contains conflicting information, mention it

Context:
{context}

Question: {question}

Helpful Answer:"""

CITATION_PROMPT = """Based on the following sources, answer the question and cite your sources using [1], [2], etc.

Sources:
{numbered_sources}

Question: {question}

Answer with citations:"""
```

---

## 🚀 Advanced RAG Techniques

### 1. Parent Document Retrieval

Retrieve small chunks, return larger parent chunks:

```python
from langchain.retrievers import ParentDocumentRetriever
from langchain.storage import InMemoryStore

# Create two splitters
parent_splitter = RecursiveCharacterTextSplitter(chunk_size=2000)
child_splitter = RecursiveCharacterTextSplitter(chunk_size=400)

# Storage for parent documents
store = InMemoryStore()

retriever = ParentDocumentRetriever(
    vectorstore=vectorstore,
    docstore=store,
    child_splitter=child_splitter,
    parent_splitter=parent_splitter,
)

# Search finds child chunks, returns parent chunks
docs = retriever.get_relevant_documents("query")
```

### 2. Self-Query Retrieval

Let LLM create metadata filters:

```python
from langchain.retrievers.self_query.base import SelfQueryRetriever

retriever = SelfQueryRetriever.from_llm(
    llm=llm,
    vectorstore=vectorstore,
    document_contents="Scientific papers about AI",
    metadata_field_info=[
        {"name": "year", "type": "integer", "description": "Publication year"},
        {"name": "author", "type": "string", "description": "Author name"},
        {"name": "topic", "type": "string", "description": "Paper topic"}
    ]
)

# Query: "Papers about transformers from 2023"
# Automatically filters: year=2023, topic contains "transformer"
docs = retriever.get_relevant_documents("Papers about transformers from 2023")
```

### 3. Contextual Compression

Compress retrieved documents to relevant parts:

```python
from langchain.retrievers import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import LLMChainExtractor

compressor = LLMChainExtractor.from_llm(llm)
compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor,
    base_retriever=vectorstore.as_retriever()
)

# Returns only relevant parts of documents
docs = compression_retriever.get_relevant_documents(query)
```

### 4. Hypothetical Document Embeddings (HyDE)

Generate hypothetical answer, then search:

```python
def hyde_search(query, vectorstore, llm):
    """HyDE: Generate hypothetical document, then search."""
    
    # Generate hypothetical answer
    hypothetical = llm.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{
            "role": "user",
            "content": f"Write a short passage that would answer: {query}"
        }]
    ).choices[0].message.content
    
    # Search using hypothetical answer embedding
    results = vectorstore.similarity_search(hypothetical, k=5)
    
    return results
```

### 5. Multi-Query Retrieval

Generate multiple query variations:

```python
from langchain.retrievers.multi_query import MultiQueryRetriever

retriever = MultiQueryRetriever.from_llm(
    retriever=vectorstore.as_retriever(),
    llm=llm
)

# Generates multiple queries, combines results
docs = retriever.get_relevant_documents(
    "What are the effects of climate change?"
)
# Might generate:
# - "climate change impacts"
# - "consequences of global warming"
# - "environmental effects of climate change"
```

---

## 📊 RAG Evaluation

### Metrics

```python
def evaluate_rag(questions, ground_truths, rag_system):
    """Evaluate RAG system performance."""
    
    results = {
        'retrieval_precision': [],
        'answer_relevance': [],
        'faithfulness': []
    }
    
    for question, truth in zip(questions, ground_truths):
        response = rag_system.query(question)
        
        # Retrieval precision: relevant docs retrieved?
        # Answer relevance: does answer address question?
        # Faithfulness: is answer grounded in context?
        
        # Use LLM-as-judge for evaluation
        eval_prompt = f"""
        Question: {question}
        Expected Answer: {truth}
        Generated Answer: {response['answer']}
        
        Rate from 1-5:
        1. Relevance (does it answer the question?): 
        2. Correctness (is it factually correct?):
        3. Completeness (is it thorough?):
        """
        
        # ... evaluate with LLM
    
    return results
```

### RAGAS Framework

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall
)

# Evaluate with RAGAS
results = evaluate(
    dataset,
    metrics=[
        faithfulness,
        answer_relevancy,
        context_precision,
        context_recall
    ]
)
print(results)
```

---

## 🛠️ Production Best Practices

### 1. Caching

```python
import hashlib
from functools import lru_cache

class CachedRAG(RAGSystem):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.cache = {}
    
    def query(self, question, k=5):
        cache_key = hashlib.md5(f"{question}_{k}".encode()).hexdigest()
        
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        result = super().query(question, k)
        self.cache[cache_key] = result
        
        return result
```

### 2. Streaming Responses

```python
def stream_rag_response(query, context):
    """Stream RAG response for better UX."""
    
    prompt = f"Context: {context}\n\nQuestion: {query}\n\nAnswer:"
    
    stream = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        stream=True
    )
    
    for chunk in stream:
        if chunk.choices[0].delta.content:
            yield chunk.choices[0].delta.content
```

### 3. Error Handling

```python
def robust_rag_query(question, rag_system, retries=3):
    """RAG query with error handling."""
    
    for attempt in range(retries):
        try:
            result = rag_system.query(question)
            
            # Validate response
            if not result['answer'] or len(result['answer']) < 10:
                raise ValueError("Response too short")
            
            return result
            
        except Exception as e:
            if attempt == retries - 1:
                return {
                    'answer': "I'm sorry, I couldn't process your question. Please try again.",
                    'error': str(e),
                    'sources': []
                }
            time.sleep(2 ** attempt)  # Exponential backoff
```

---

## 📚 Key Takeaways

1. **RAG = Retrieval + Generation** - Best of both worlds
2. **Quality retrieval is crucial** - Garbage in, garbage out
3. **Chunk size matters** - Too small or large hurts performance
4. **Prompt engineering is key** - Guide the LLM properly
5. **Evaluate systematically** - Use proper metrics
6. **Advanced techniques exist** - HyDE, multi-query, compression

---

## 🔗 Continue Learning

This completes the AI Core Concepts module! Next, explore:
- [06-AI-Agents](../../06-AI-Agents) - Build intelligent agents using these concepts

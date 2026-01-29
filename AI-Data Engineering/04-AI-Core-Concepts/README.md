# 🧠 AI Core Concepts

## Overview

This module covers the **fundamental building blocks** of modern AI systems, particularly those powering Large Language Models (LLMs) and AI Agents. Understanding these concepts is essential before diving into agent development.

These concepts form the bridge between raw data and intelligent AI systems.

---

## 📚 Module Structure

| # | Topic | Description | Duration |
|---|-------|-------------|----------|
| 01 | [Embeddings & Vector Representations](./01-Embeddings-and-Vector-Representations) | Convert text/data into numerical vectors | 1 week |
| 02 | [Tokenization & Text Processing](./02-Tokenization-and-Text-Processing) | Break down text for AI processing | 1 week |
| 03 | [Chunking Strategies](./03-Chunking-Strategies) | Split documents for optimal retrieval | 1 week |
| 04 | [Vector Databases](./04-Vector-Databases) | Store and query embeddings efficiently | 2 weeks |
| 05 | [Semantic Search](./05-Semantic-Search) | Find relevant information by meaning | 1 week |
| 06 | [RAG Fundamentals](./06-RAG-Fundamentals) | Combine retrieval with generation | 2 weeks |

---

## 🎯 Learning Objectives

After completing this module, you will:

- ✅ Understand how text is converted to numerical representations
- ✅ Know how tokenizers work and their impact on LLMs
- ✅ Master document chunking strategies for RAG systems
- ✅ Work with vector databases like Pinecone, ChromaDB, Weaviate
- ✅ Implement semantic search systems
- ✅ Build RAG pipelines from scratch

---

## 🔗 How These Concepts Connect

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        AI CORE CONCEPTS PIPELINE                        │
└─────────────────────────────────────────────────────────────────────────┘

    Raw Text/Documents
           │
           ▼
    ┌──────────────┐
    │ TOKENIZATION │  ← Break text into tokens (words, subwords)
    └──────────────┘
           │
           ▼
    ┌──────────────┐
    │   CHUNKING   │  ← Split documents into manageable pieces
    └──────────────┘
           │
           ▼
    ┌──────────────┐
    │  EMBEDDINGS  │  ← Convert chunks to numerical vectors
    └──────────────┘
           │
           ▼
    ┌──────────────┐
    │ VECTOR DB    │  ← Store vectors for fast similarity search
    └──────────────┘
           │
           ▼
    ┌──────────────┐
    │SEMANTIC SEARCH│ ← Query by meaning, not keywords
    └──────────────┘
           │
           ▼
    ┌──────────────┐
    │     RAG      │  ← Retrieve context + Generate response
    └──────────────┘
           │
           ▼
    AI Agent Response
```

---

## 🛠️ Key Tools & Libraries

| Category | Tools |
|----------|-------|
| **Embeddings** | OpenAI Embeddings, Sentence-Transformers, Cohere, Voyage AI |
| **Tokenizers** | tiktoken, HuggingFace Tokenizers, SentencePiece |
| **Vector DBs** | Pinecone, ChromaDB, Weaviate, Milvus, Qdrant, FAISS |
| **RAG Frameworks** | LangChain, LlamaIndex, Haystack |

---

## 📖 Prerequisites

Before starting this module, ensure you understand:

- Python programming (intermediate)
- Basic linear algebra (vectors, dot products)
- Basic understanding of neural networks
- Familiarity with APIs and JSON

---

## 🚀 Quick Start Example

Here's a simple example showing how these concepts work together:

```python
# Example: Simple RAG Pipeline
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter

# 1. Load and chunk documents
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
chunks = text_splitter.split_documents(documents)

# 2. Create embeddings and store in vector DB
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(chunks, embeddings)

# 3. Semantic search
query = "What is machine learning?"
relevant_docs = vectorstore.similarity_search(query, k=3)

# 4. Use retrieved context for generation (RAG)
context = "\n".join([doc.page_content for doc in relevant_docs])
# Pass context to LLM for response generation
```

---

## 📅 Suggested Study Plan

| Week | Focus | Activities |
|------|-------|------------|
| 1 | Embeddings & Tokenization | Theory + hands-on with embedding models |
| 2 | Chunking Strategies | Experiment with different chunking methods |
| 3 | Vector Databases | Set up and query vector DBs |
| 4 | Semantic Search & RAG | Build a complete RAG pipeline |

---

## 🔗 Related Modules

- **Previous**: [03-Deep-Learning](../03-Deep-Learning) - Neural network foundations
- **Next**: [06-AI-Agents](../06-AI-Agents) - Apply these concepts in agents

---

*Master these concepts, and you'll have the foundation for building powerful AI systems!*

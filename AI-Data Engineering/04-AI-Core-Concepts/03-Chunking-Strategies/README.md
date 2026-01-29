# 📄 Chunking Strategies

## What is Chunking?

**Chunking** is the process of splitting large documents into smaller, manageable pieces for processing by AI systems, particularly for Retrieval Augmented Generation (RAG).

Think of it as **dividing a book into meaningful sections** that can be independently searched and retrieved.

---

## 🎯 Why Chunking Matters

| Problem | Impact |
|---------|--------|
| Documents exceed context limits | Can't process entire document at once |
| Irrelevant information | Too much context dilutes relevance |
| Poor retrieval | Wrong chunk size = wrong results |
| Cost inefficiency | Larger chunks = higher API costs |

---

## 📏 Chunk Size Considerations

### The Goldilocks Problem

```
Too Small (< 100 tokens):
- Loses context
- Fragments sentences
- Poor semantic meaning

Too Large (> 1000 tokens):
- Contains irrelevant info
- Exceeds embedding limits
- Higher costs

Just Right (200-500 tokens):
- Maintains context
- Good semantic meaning
- Efficient retrieval
```

### Recommended Sizes by Use Case

| Use Case | Chunk Size | Overlap |
|----------|------------|---------|
| Q&A over documents | 500-1000 chars | 100-200 chars |
| Semantic search | 256-512 tokens | 50-100 tokens |
| Summarization | 1000-2000 chars | 200-400 chars |
| Code documentation | 1000-1500 chars | 200 chars |
| Chat with PDFs | 500-800 chars | 100 chars |

---

## 🔧 Chunking Methods

### 1. Fixed-Size Chunking

Split by character/token count:

```python
def fixed_size_chunks(text, chunk_size=1000, overlap=200):
    """Split text into fixed-size chunks with overlap."""
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        chunk = text[start:end]
        chunks.append(chunk)
        start = end - overlap
    return chunks

# Example
text = "Your long document here..."
chunks = fixed_size_chunks(text, chunk_size=500, overlap=50)
```

**Pros**: Simple, predictable size
**Cons**: May cut sentences/words mid-way

### 2. Recursive Character Splitting

Split by hierarchy of separators:

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ". ", " ", ""]
)

chunks = splitter.split_text(text)
```

**How it works**:
1. Try to split by `\n\n` (paragraphs)
2. If chunks too big, try `\n` (lines)
3. If still too big, try `. ` (sentences)
4. Continue until chunk_size reached

**Pros**: Respects document structure
**Cons**: Variable chunk sizes

### 3. Sentence-Based Chunking

Split by sentences:

```python
import nltk
nltk.download('punkt')
from nltk.tokenize import sent_tokenize

def sentence_chunks(text, sentences_per_chunk=5):
    """Group sentences into chunks."""
    sentences = sent_tokenize(text)
    chunks = []
    for i in range(0, len(sentences), sentences_per_chunk):
        chunk = ' '.join(sentences[i:i + sentences_per_chunk])
        chunks.append(chunk)
    return chunks
```

**Pros**: Natural boundaries, complete thoughts
**Cons**: Variable sizes, may be too small

### 4. Semantic Chunking

Split by meaning/topic changes:

```python
from langchain_experimental.text_splitter import SemanticChunker
from langchain.embeddings import OpenAIEmbeddings

embeddings = OpenAIEmbeddings()
semantic_splitter = SemanticChunker(
    embeddings=embeddings,
    breakpoint_threshold_type="percentile"
)

chunks = semantic_splitter.split_text(text)
```

**Pros**: Keeps related content together
**Cons**: Expensive (requires embeddings), slower

### 5. Document-Aware Chunking

Respect document structure:

```python
from langchain.text_splitter import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("#", "Header 1"),
    ("##", "Header 2"),
    ("###", "Header 3"),
]

markdown_splitter = MarkdownHeaderTextSplitter(
    headers_to_split_on=headers_to_split_on
)

chunks = markdown_splitter.split_text(markdown_text)
```

**Pros**: Maintains document hierarchy
**Cons**: Only works with structured documents

---

## 💻 Complete Implementation

### LangChain Text Splitters

```python
from langchain.text_splitter import (
    CharacterTextSplitter,
    RecursiveCharacterTextSplitter,
    TokenTextSplitter,
    MarkdownHeaderTextSplitter,
    HTMLHeaderTextSplitter,
    PythonCodeTextSplitter
)

# 1. Character-based
char_splitter = CharacterTextSplitter(
    separator="\n\n",
    chunk_size=1000,
    chunk_overlap=200
)

# 2. Recursive (recommended for most cases)
recursive_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    length_function=len,
    separators=["\n\n", "\n", ". ", " ", ""]
)

# 3. Token-based (precise token counts)
token_splitter = TokenTextSplitter(
    chunk_size=500,
    chunk_overlap=50
)

# 4. For Python code
code_splitter = PythonCodeTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
```

### LlamaIndex Node Parsers

```python
from llama_index.core.node_parser import (
    SentenceSplitter,
    SemanticSplitterNodeParser,
    HierarchicalNodeParser
)
from llama_index.embeddings.openai import OpenAIEmbedding

# 1. Sentence-based
sentence_parser = SentenceSplitter(
    chunk_size=1024,
    chunk_overlap=20
)

# 2. Semantic (groups by meaning)
embed_model = OpenAIEmbedding()
semantic_parser = SemanticSplitterNodeParser(
    buffer_size=1,
    breakpoint_percentile_threshold=95,
    embed_model=embed_model
)

# 3. Hierarchical (multi-level chunks)
hierarchical_parser = HierarchicalNodeParser.from_defaults(
    chunk_sizes=[2048, 512, 128]
)
```

---

## 📊 Chunking Strategy Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│                    CHUNKING STRATEGY SELECTION                   │
└─────────────────────────────────────────────────────────────────┘

Document Type?
│
├── Markdown/HTML → Document-Aware Chunking
│   └── Use headers as natural boundaries
│
├── Code → Code-Aware Chunking
│   └── Split by functions/classes
│
├── Plain Text → Choose based on needs:
│   │
│   ├── Speed/Simplicity → Fixed-Size or Recursive
│   │
│   ├── Quality Focus → Semantic Chunking
│   │
│   └── Balanced → Sentence-Based
│
└── PDF/Complex → Recursive with post-processing
```

---

## 🔄 Chunk Overlap

### Why Overlap?

```
Without overlap:
Chunk 1: "The capital of France is"
Chunk 2: "Paris. It is known for the Eiffel Tower."

Query: "What is the capital of France?"
Problem: Answer split across chunks!

With overlap:
Chunk 1: "The capital of France is Paris."
Chunk 2: "is Paris. It is known for the Eiffel Tower."

Query: "What is the capital of France?"  
Solution: Chunk 1 has complete answer!
```

### Overlap Guidelines

| Chunk Size | Recommended Overlap |
|------------|---------------------|
| 500 chars | 50-100 chars (10-20%) |
| 1000 chars | 100-200 chars (10-20%) |
| 2000 chars | 200-400 chars (10-20%) |

---

## 🎨 Advanced Techniques

### 1. Hierarchical Chunking

Create chunks at multiple granularities:

```python
def hierarchical_chunks(text):
    """Create multi-level chunks."""
    # Level 1: Large chunks (summaries)
    large_splitter = RecursiveCharacterTextSplitter(
        chunk_size=2000, chunk_overlap=200
    )
    large_chunks = large_splitter.split_text(text)
    
    # Level 2: Medium chunks (paragraphs)
    medium_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500, chunk_overlap=50
    )
    medium_chunks = medium_splitter.split_text(text)
    
    # Level 3: Small chunks (sentences)
    small_splitter = RecursiveCharacterTextSplitter(
        chunk_size=150, chunk_overlap=20
    )
    small_chunks = small_splitter.split_text(text)
    
    return {
        'large': large_chunks,
        'medium': medium_chunks,
        'small': small_chunks
    }
```

### 2. Agentic Chunking

Let an LLM decide chunk boundaries:

```python
from openai import OpenAI

client = OpenAI()

def agentic_chunk(text):
    """Use LLM to identify natural chunk boundaries."""
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{
            "role": "system",
            "content": "Split the following text into logical chunks. Return chunk boundaries as line numbers."
        }, {
            "role": "user",
            "content": text
        }]
    )
    # Parse response and create chunks
    return parse_chunk_boundaries(response, text)
```

### 3. Parent-Child Chunking

Store relationships between chunks:

```python
class ChunkWithContext:
    def __init__(self, content, parent_id=None, children_ids=None):
        self.content = content
        self.parent_id = parent_id
        self.children_ids = children_ids or []
        
def create_parent_child_chunks(text):
    """Create chunks with parent-child relationships."""
    # Create large parent chunks
    parent_splitter = RecursiveCharacterTextSplitter(
        chunk_size=2000, chunk_overlap=0
    )
    parent_chunks = parent_splitter.split_text(text)
    
    all_chunks = []
    for i, parent in enumerate(parent_chunks):
        parent_id = f"parent_{i}"
        
        # Create smaller child chunks
        child_splitter = RecursiveCharacterTextSplitter(
            chunk_size=400, chunk_overlap=50
        )
        children = child_splitter.split_text(parent)
        
        children_ids = []
        for j, child in enumerate(children):
            child_id = f"child_{i}_{j}"
            children_ids.append(child_id)
            all_chunks.append(ChunkWithContext(
                content=child,
                parent_id=parent_id
            ))
        
        all_chunks.append(ChunkWithContext(
            content=parent,
            children_ids=children_ids
        ))
    
    return all_chunks
```

---

## 📏 Measuring Chunk Quality

```python
def evaluate_chunks(chunks, embeddings_model):
    """Evaluate chunk quality metrics."""
    from sentence_transformers import SentenceTransformer
    import numpy as np
    
    model = SentenceTransformer(embeddings_model)
    embeddings = model.encode(chunks)
    
    # Metric 1: Average chunk length
    avg_length = np.mean([len(c) for c in chunks])
    
    # Metric 2: Length variance (lower is more consistent)
    length_variance = np.var([len(c) for c in chunks])
    
    # Metric 3: Semantic coherence (higher is better)
    # Compare each chunk's embedding to its neighbors
    coherence_scores = []
    for i in range(len(embeddings) - 1):
        sim = np.dot(embeddings[i], embeddings[i+1])
        coherence_scores.append(sim)
    avg_coherence = np.mean(coherence_scores)
    
    return {
        'num_chunks': len(chunks),
        'avg_length': avg_length,
        'length_variance': length_variance,
        'avg_coherence': avg_coherence
    }
```

---

## 📚 Key Takeaways

1. **No one-size-fits-all** - Choose strategy based on document type and use case
2. **Use overlap** - Prevents information loss at boundaries
3. **Test different sizes** - Experiment with your specific data
4. **Consider semantics** - Meaning-based chunking often outperforms fixed-size
5. **Monitor retrieval quality** - Bad chunks = bad retrieval

---

## 🔗 Next Steps

Continue to [04-Vector-Databases](../04-Vector-Databases) to learn how to store and query your chunks efficiently.

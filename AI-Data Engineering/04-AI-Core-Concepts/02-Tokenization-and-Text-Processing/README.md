# ✂️ Tokenization and Text Processing

## What is Tokenization?

**Tokenization** is the process of breaking down text into smaller units called **tokens**. These tokens are the fundamental units that language models process.

Think of it as **chopping text into digestible pieces** that an AI can understand.

---

## 🎯 Why Tokenization Matters

| Aspect | Impact |
|--------|--------|
| **Context Window** | Tokens determine how much text fits in a model's context |
| **Cost** | API pricing is based on token count |
| **Quality** | Tokenization affects model understanding |
| **Speed** | More tokens = slower processing |

---

## 📝 Types of Tokenization

### 1. Word-Level Tokenization

Splits text by words (spaces/punctuation):

```
Input: "Hello, world!"
Tokens: ["Hello", ",", "world", "!"]
```

**Pros**: Simple, intuitive
**Cons**: Large vocabulary, can't handle new words

### 2. Character-Level Tokenization

Each character is a token:

```
Input: "Hello"
Tokens: ["H", "e", "l", "l", "o"]
```

**Pros**: Small vocabulary, handles any word
**Cons**: Loses word meaning, very long sequences

### 3. Subword Tokenization (Modern Standard)

Breaks words into meaningful subunits:

```
Input: "unhappiness"
Tokens: ["un", "happiness"] or ["un", "happ", "iness"]
```

**Pros**: Balance of vocabulary size and meaning
**Cons**: More complex

---

## 🔧 Subword Tokenization Algorithms

### Byte-Pair Encoding (BPE)

Used by: **GPT-2, GPT-3, GPT-4**

```
Algorithm:
1. Start with character vocabulary
2. Count all adjacent pairs
3. Merge most frequent pair
4. Repeat until vocabulary size reached

Example:
"low lower lowest" 
→ Characters: l, o, w, e, r, s, t
→ After merging: "lo", "low", "er", "est"
```

### WordPiece

Used by: **BERT, DistilBERT**

```
Similar to BPE but uses likelihood instead of frequency

"playing" → ["play", "##ing"]
(## indicates continuation of word)
```

### SentencePiece

Used by: **T5, LLaMA, GPT-4**

```
Language-agnostic, handles any text including spaces

"Hello World" → ["▁Hello", "▁World"]
(▁ represents space)
```

### Unigram

Used by: **XLNet, ALBERT**

```
Starts with large vocabulary, prunes tokens
based on how much they improve likelihood
```

---

## 💻 Working with Tokenizers

### OpenAI (tiktoken)

```python
import tiktoken

# Get encoder for specific model
enc = tiktoken.encoding_for_model("gpt-4")

# Encode text to tokens
text = "Hello, how are you?"
tokens = enc.encode(text)
print(f"Tokens: {tokens}")
print(f"Token count: {len(tokens)}")

# Decode tokens back to text
decoded = enc.decode(tokens)
print(f"Decoded: {decoded}")

# See individual tokens
for token in tokens:
    print(f"{token} → '{enc.decode([token])}'")
```

### HuggingFace Tokenizers

```python
from transformers import AutoTokenizer

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

# Tokenize
text = "Hello, how are you?"
tokens = tokenizer.tokenize(text)
print(f"Tokens: {tokens}")

# Convert to IDs
token_ids = tokenizer.encode(text)
print(f"Token IDs: {token_ids}")

# Full encoding with attention mask
encoded = tokenizer(text, return_tensors="pt")
print(f"Input IDs: {encoded['input_ids']}")
print(f"Attention Mask: {encoded['attention_mask']}")
```

### Comparing Tokenizers

```python
import tiktoken
from transformers import AutoTokenizer

text = "Tokenization is fascinating! 🚀"

# GPT-4 tokenizer
gpt4_enc = tiktoken.encoding_for_model("gpt-4")
gpt4_tokens = gpt4_enc.encode(text)

# BERT tokenizer
bert_tok = AutoTokenizer.from_pretrained("bert-base-uncased")
bert_tokens = bert_tok.tokenize(text)

# LLaMA tokenizer
llama_tok = AutoTokenizer.from_pretrained("meta-llama/Llama-2-7b-hf")
llama_tokens = llama_tok.tokenize(text)

print(f"GPT-4: {len(gpt4_tokens)} tokens")
print(f"BERT: {len(bert_tokens)} tokens")
print(f"LLaMA: {len(llama_tokens)} tokens")
```

---

## 📊 Token Limits by Model

| Model | Context Window | Max Output |
|-------|---------------|------------|
| GPT-3.5-turbo | 16,385 tokens | 4,096 tokens |
| GPT-4 | 8,192 tokens | 8,192 tokens |
| GPT-4-turbo | 128,000 tokens | 4,096 tokens |
| GPT-4o | 128,000 tokens | 16,384 tokens |
| Claude 3 Opus | 200,000 tokens | 4,096 tokens |
| Claude 3.5 Sonnet | 200,000 tokens | 8,192 tokens |
| Gemini 1.5 Pro | 1,000,000 tokens | 8,192 tokens |
| LLaMA 2 | 4,096 tokens | 4,096 tokens |
| LLaMA 3 | 8,192 tokens | 8,192 tokens |

---

## 🧮 Token Estimation

### Rule of Thumb

For English text:
- **1 token ≈ 4 characters**
- **1 token ≈ 0.75 words**
- **100 tokens ≈ 75 words**
- **1,000 tokens ≈ 750 words ≈ 1.5 pages**

### Precise Counting

```python
import tiktoken

def count_tokens(text, model="gpt-4"):
    """Count tokens for a specific model."""
    enc = tiktoken.encoding_for_model(model)
    return len(enc.encode(text))

def estimate_cost(text, model="gpt-4", price_per_1k=0.03):
    """Estimate API cost for text."""
    tokens = count_tokens(text, model)
    return (tokens / 1000) * price_per_1k

# Example
text = "Your long document here..."
print(f"Tokens: {count_tokens(text)}")
print(f"Estimated cost: ${estimate_cost(text):.4f}")
```

---

## 🔤 Text Preprocessing Pipeline

```python
import re
import unicodedata

def preprocess_text(text):
    """Complete text preprocessing pipeline."""
    
    # 1. Normalize unicode
    text = unicodedata.normalize('NFKC', text)
    
    # 2. Convert to lowercase (optional)
    text = text.lower()
    
    # 3. Remove extra whitespace
    text = ' '.join(text.split())
    
    # 4. Remove special characters (optional)
    # text = re.sub(r'[^\w\s]', '', text)
    
    # 5. Handle contractions (optional)
    contractions = {
        "won't": "will not",
        "can't": "cannot",
        "n't": " not",
        "'re": " are",
        "'s": " is",
        "'d": " would",
        "'ll": " will",
        "'ve": " have",
        "'m": " am"
    }
    for contraction, expansion in contractions.items():
        text = text.replace(contraction, expansion)
    
    return text

# Example
raw_text = "I won't   go there!  It's AMAZING!!!"
clean_text = preprocess_text(raw_text)
print(clean_text)  # "i will not go there! it is amazing!!!"
```

---

## 🎭 Special Tokens

Models use special tokens for structure:

| Token | Purpose | Example |
|-------|---------|---------|
| `[CLS]` | Classification token (BERT) | Start of sequence |
| `[SEP]` | Separator token | Between sentences |
| `[PAD]` | Padding token | Fill to max length |
| `[MASK]` | Masked token | For MLM training |
| `<|endoftext|>` | End of text (GPT) | Sequence boundary |
| `<s>`, `</s>` | Start/End (LLaMA) | Sequence boundaries |

```python
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

# See special tokens
print(tokenizer.special_tokens_map)
# {'unk_token': '[UNK]', 'sep_token': '[SEP]', 
#  'pad_token': '[PAD]', 'cls_token': '[CLS]', 
#  'mask_token': '[MASK]'}
```

---

## ⚠️ Common Tokenization Issues

### 1. Out-of-Vocabulary (OOV) Words

```python
# Unknown words become [UNK] or are split oddly
text = "supercalifragilisticexpialidocious"
# Might become: ["super", "##cali", "##fra", "##gi", ...]
```

### 2. Inconsistent Spacing

```python
# Same word, different tokens based on position
"Hello" vs " Hello"  # Different token IDs!
```

### 3. Non-English Text

```python
# Many more tokens needed
english = "Hello"  # 1 token
chinese = "你好"    # 2-3 tokens per character
```

### 4. Code and Technical Content

```python
# Code often tokenizes poorly
code = "def calculate_sum(a, b):"
# Becomes many small tokens, uses more context
```

---

## 🛠️ Best Practices

### 1. Always Count Tokens

```python
def safe_truncate(text, max_tokens, model="gpt-4"):
    """Truncate text to fit token limit."""
    enc = tiktoken.encoding_for_model(model)
    tokens = enc.encode(text)
    if len(tokens) <= max_tokens:
        return text
    return enc.decode(tokens[:max_tokens])
```

### 2. Reserve Tokens for Response

```python
max_context = 8192
max_response = 1000
max_input = max_context - max_response  # 7192 tokens for input
```

### 3. Monitor Token Usage

```python
def log_token_usage(prompt, response, model):
    """Log token usage for cost tracking."""
    prompt_tokens = count_tokens(prompt, model)
    response_tokens = count_tokens(response, model)
    total = prompt_tokens + response_tokens
    print(f"Prompt: {prompt_tokens}, Response: {response_tokens}, Total: {total}")
```

---

## 📚 Key Takeaways

1. **Tokenization is not word splitting** - Subword tokenization is the standard
2. **Token count ≠ word count** - Tokens are model-specific
3. **Context limits are in tokens** - Always count tokens, not characters
4. **Different models = different tokenizers** - Don't assume compatibility
5. **Preprocessing affects tokens** - Clean text before tokenizing

---

## 🔗 Next Steps

Continue to [03-Chunking-Strategies](../03-Chunking-Strategies) to learn how to split documents for optimal retrieval.

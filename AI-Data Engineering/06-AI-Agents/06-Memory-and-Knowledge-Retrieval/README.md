# 🧠 Module 06: Memory and Knowledge Retrieval

## Overview

This module covers memory systems for AI agents - how agents store, organize, and retrieve information to maintain context and improve over time.

---

## 🎯 Learning Objectives

By completing this module, you will:

1. **Understand** different types of agent memory
2. **Implement** short-term and long-term memory systems
3. **Build** efficient knowledge retrieval systems
4. **Design** memory architectures for different use cases
5. **Optimize** memory for performance and relevance

---

## 📚 Prerequisites

- Module 04: Large Language Models
- Module 05: Understanding AI Agents
- Understanding of embeddings and vector databases

---

## 🗄️ Types of Agent Memory

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT MEMORY TYPES                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SENSORY MEMORY          WORKING MEMORY        LONG-TERM MEMORY │
│  (Immediate Input)       (Active Context)      (Persistent)     │
│  ───────────────         ──────────────        ────────────────  │
│  • Raw input             • Current task        • Episodic        │
│  • Very short term       • Reasoning state     • Semantic        │
│  • Pre-processing        • Tool results        • Procedural      │
│                                                                  │
│       │                        │                      │          │
│       ▼                        ▼                      ▼          │
│  ┌─────────┐             ┌──────────┐          ┌──────────┐     │
│  │ Buffer  │────────────▶│ Context  │◀────────▶│ Vector   │     │
│  │         │             │ Window   │          │ Store    │     │
│  └─────────┘             └──────────┘          └──────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💬 Short-Term / Working Memory

### Conversation Memory

```python
from typing import List, Dict, Optional
from datetime import datetime
from pydantic import BaseModel

class Message(BaseModel):
    role: str  # "user", "assistant", "system", "tool"
    content: str
    timestamp: datetime = None
    metadata: Dict = {}

class ConversationMemory:
    """
    Manages conversation context within a session.
    """
    def __init__(self, max_messages: int = 50, max_tokens: int = 100000):
        self.messages: List[Message] = []
        self.max_messages = max_messages
        self.max_tokens = max_tokens
        self.system_message: Optional[Message] = None
    
    def add_message(self, role: str, content: str, metadata: Dict = None):
        """Add a message to memory."""
        message = Message(
            role=role,
            content=content,
            timestamp=datetime.now(),
            metadata=metadata or {}
        )
        self.messages.append(message)
        self._enforce_limits()
    
    def set_system_message(self, content: str):
        """Set the system message (always included)."""
        self.system_message = Message(role="system", content=content)
    
    def get_context(self) -> List[Dict]:
        """Get messages for LLM context."""
        result = []
        
        # Always include system message first
        if self.system_message:
            result.append({
                "role": self.system_message.role,
                "content": self.system_message.content
            })
        
        # Add conversation messages
        for msg in self.messages:
            result.append({
                "role": msg.role,
                "content": msg.content
            })
        
        return result
    
    def _enforce_limits(self):
        """Trim memory to stay within limits."""
        # Remove oldest messages (keep system message)
        while len(self.messages) > self.max_messages:
            self.messages.pop(0)
        
        # Check token count
        while self._count_tokens() > self.max_tokens and len(self.messages) > 1:
            self.messages.pop(0)
    
    def _count_tokens(self) -> int:
        """Estimate token count."""
        total = sum(len(msg.content) // 4 for msg in self.messages)
        if self.system_message:
            total += len(self.system_message.content) // 4
        return total
    
    def summarize_and_compress(self, llm) -> str:
        """Summarize older messages to save context space."""
        if len(self.messages) < 10:
            return
        
        # Get older messages to summarize
        to_summarize = self.messages[:len(self.messages)//2]
        summary_content = "\n".join([
            f"{m.role}: {m.content}" for m in to_summarize
        ])
        
        # Generate summary
        summary = llm.invoke(f"""
        Summarize this conversation, preserving key information:
        {summary_content}
        
        Keep: facts, decisions, important context
        Remove: greetings, filler, redundancy
        """).content
        
        # Replace old messages with summary
        self.messages = [
            Message(role="system", content=f"[Previous conversation summary: {summary}]")
        ] + self.messages[len(to_summarize):]
```

### Sliding Window with Summarization

```python
class SlidingWindowMemory:
    """
    Maintains a sliding window of recent messages with automatic summarization.
    """
    def __init__(
        self,
        window_size: int = 20,
        summary_threshold: int = 15,
        llm = None
    ):
        self.window_size = window_size
        self.summary_threshold = summary_threshold
        self.llm = llm
        self.messages: List[Message] = []
        self.summaries: List[str] = []  # Rolling summaries
    
    def add(self, role: str, content: str):
        """Add message, triggering summarization if needed."""
        self.messages.append(Message(role=role, content=content))
        
        if len(self.messages) > self.window_size:
            self._summarize_and_trim()
    
    def _summarize_and_trim(self):
        """Summarize older messages and trim."""
        # Take first half of messages
        to_summarize = self.messages[:self.summary_threshold]
        
        # Generate summary
        summary = self._generate_summary(to_summarize)
        self.summaries.append(summary)
        
        # Keep only recent messages
        self.messages = self.messages[self.summary_threshold:]
    
    def _generate_summary(self, messages: List[Message]) -> str:
        """Generate a summary of messages."""
        content = "\n".join([f"{m.role}: {m.content}" for m in messages])
        
        response = self.llm.invoke(f"""
        Create a brief summary of this conversation segment:
        {content}
        
        Focus on:
        - Key decisions made
        - Important information shared
        - Action items or commitments
        
        Keep it under 100 words.
        """)
        
        return response.content
    
    def get_context(self) -> str:
        """Get full context with summaries."""
        context_parts = []
        
        # Add summaries
        if self.summaries:
            context_parts.append("=== Previous Context ===")
            for i, summary in enumerate(self.summaries):
                context_parts.append(f"[Summary {i+1}]: {summary}")
        
        # Add recent messages
        context_parts.append("\n=== Recent Messages ===")
        for msg in self.messages:
            context_parts.append(f"{msg.role}: {msg.content}")
        
        return "\n".join(context_parts)
```

---

## 📚 Long-Term Memory with Vector Stores

### Semantic Memory

```python
from typing import List, Dict, Any
import chromadb
from sentence_transformers import SentenceTransformer

class SemanticMemory:
    """
    Long-term semantic memory using vector similarity search.
    """
    def __init__(
        self,
        collection_name: str = "agent_memory",
        embedding_model: str = "all-MiniLM-L6-v2"
    ):
        self.embedding_model = SentenceTransformer(embedding_model)
        self.client = chromadb.Client()
        self.collection = self.client.get_or_create_collection(
            name=collection_name,
            metadata={"hnsw:space": "cosine"}
        )
    
    def store(
        self,
        content: str,
        metadata: Dict[str, Any] = None,
        memory_type: str = "general"
    ):
        """Store a memory with embeddings."""
        import uuid
        
        # Generate embedding
        embedding = self.embedding_model.encode(content).tolist()
        
        # Prepare metadata
        meta = {
            "type": memory_type,
            "timestamp": datetime.now().isoformat(),
            **(metadata or {})
        }
        
        # Store in vector database
        self.collection.add(
            ids=[str(uuid.uuid4())],
            embeddings=[embedding],
            documents=[content],
            metadatas=[meta]
        )
    
    def retrieve(
        self,
        query: str,
        top_k: int = 5,
        memory_type: str = None,
        min_score: float = 0.5
    ) -> List[Dict]:
        """Retrieve relevant memories."""
        # Generate query embedding
        query_embedding = self.embedding_model.encode(query).tolist()
        
        # Build filter
        where_filter = {}
        if memory_type:
            where_filter["type"] = memory_type
        
        # Query
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=top_k,
            where=where_filter if where_filter else None,
            include=["documents", "metadatas", "distances"]
        )
        
        # Format results
        memories = []
        for i, doc in enumerate(results["documents"][0]):
            score = 1 - results["distances"][0][i]  # Convert distance to similarity
            if score >= min_score:
                memories.append({
                    "content": doc,
                    "metadata": results["metadatas"][0][i],
                    "score": score
                })
        
        return memories
    
    def forget(self, memory_id: str):
        """Remove a specific memory."""
        self.collection.delete(ids=[memory_id])
    
    def update_importance(self, memory_id: str, importance: float):
        """Update memory importance score."""
        self.collection.update(
            ids=[memory_id],
            metadatas=[{"importance": importance}]
        )
```

### Episodic Memory (Experience-Based)

```python
from dataclasses import dataclass
from datetime import datetime
from typing import List, Optional

@dataclass
class Episode:
    """Represents a specific experience or event."""
    id: str
    description: str
    context: str
    outcome: str
    timestamp: datetime
    emotions: List[str] = None  # For sentiment
    entities: List[str] = None  # People, places, things
    importance: float = 0.5

class EpisodicMemory:
    """
    Stores and retrieves specific experiences/events.
    """
    def __init__(self, semantic_memory: SemanticMemory, llm):
        self.semantic_memory = semantic_memory
        self.llm = llm
        self.episodes: Dict[str, Episode] = {}
    
    def record_episode(
        self,
        description: str,
        context: str,
        outcome: str,
        importance: float = 0.5
    ) -> Episode:
        """Record a new episode."""
        import uuid
        
        episode_id = str(uuid.uuid4())
        
        # Extract entities and emotions using LLM
        analysis = self._analyze_episode(description, context, outcome)
        
        episode = Episode(
            id=episode_id,
            description=description,
            context=context,
            outcome=outcome,
            timestamp=datetime.now(),
            emotions=analysis.get("emotions", []),
            entities=analysis.get("entities", []),
            importance=importance
        )
        
        # Store in episodic memory
        self.episodes[episode_id] = episode
        
        # Also store in semantic memory for retrieval
        episode_text = f"""
        Event: {description}
        Context: {context}
        Outcome: {outcome}
        """
        
        self.semantic_memory.store(
            content=episode_text,
            metadata={
                "episode_id": episode_id,
                "entities": ",".join(analysis.get("entities", [])),
                "emotions": ",".join(analysis.get("emotions", []))
            },
            memory_type="episodic"
        )
        
        return episode
    
    def recall_similar_episodes(
        self,
        situation: str,
        top_k: int = 3
    ) -> List[Episode]:
        """Find similar past episodes."""
        # Search semantic memory
        results = self.semantic_memory.retrieve(
            query=situation,
            top_k=top_k,
            memory_type="episodic"
        )
        
        # Get full episode objects
        episodes = []
        for result in results:
            episode_id = result["metadata"].get("episode_id")
            if episode_id in self.episodes:
                episodes.append(self.episodes[episode_id])
        
        return episodes
    
    def _analyze_episode(self, description: str, context: str, outcome: str) -> Dict:
        """Extract entities and emotions from episode."""
        prompt = f"""
        Analyze this episode:
        Description: {description}
        Context: {context}
        Outcome: {outcome}
        
        Extract:
        1. Entities (people, places, things, concepts)
        2. Emotions (how this might feel)
        
        Return as JSON:
        {{"entities": [...], "emotions": [...]}}
        """
        
        response = self.llm.invoke(prompt)
        try:
            import json
            return json.loads(response.content)
        except:
            return {"entities": [], "emotions": []}
    
    def learn_from_episodes(self, situation: str) -> str:
        """Generate advice based on past episodes."""
        similar = self.recall_similar_episodes(situation, top_k=5)
        
        if not similar:
            return "No similar experiences found."
        
        episodes_text = "\n\n".join([
            f"Past situation: {ep.description}\nContext: {ep.context}\nOutcome: {ep.outcome}"
            for ep in similar
        ])
        
        prompt = f"""
        Current situation: {situation}
        
        Similar past experiences:
        {episodes_text}
        
        Based on these past experiences, what advice would you give?
        What patterns do you notice? What should be avoided or repeated?
        """
        
        return self.llm.invoke(prompt).content
```

---

## 🔗 Knowledge Graphs

```python
from typing import Dict, List, Set, Tuple
import networkx as nx

class KnowledgeGraph:
    """
    Graph-based knowledge storage for relationships and reasoning.
    """
    def __init__(self, llm):
        self.graph = nx.DiGraph()
        self.llm = llm
    
    def add_fact(self, subject: str, predicate: str, obj: str, confidence: float = 1.0):
        """Add a fact as a triple."""
        # Add nodes
        self.graph.add_node(subject, type="entity")
        self.graph.add_node(obj, type="entity")
        
        # Add edge with relationship
        self.graph.add_edge(
            subject, obj,
            relation=predicate,
            confidence=confidence
        )
    
    def extract_facts(self, text: str) -> List[Tuple[str, str, str]]:
        """Extract facts from text using LLM."""
        prompt = f"""
        Extract facts from this text as (subject, predicate, object) triples:
        
        Text: {text}
        
        Format each fact as:
        - (subject, predicate, object)
        
        Example:
        Text: "John works at Google in San Francisco"
        - (John, works_at, Google)
        - (Google, located_in, San Francisco)
        - (John, lives_in, San Francisco)
        """
        
        response = self.llm.invoke(prompt)
        
        # Parse triples from response
        facts = []
        for line in response.content.split('\n'):
            if line.strip().startswith('-'):
                # Parse (s, p, o) format
                try:
                    content = line.split('(')[1].split(')')[0]
                    parts = [p.strip() for p in content.split(',')]
                    if len(parts) == 3:
                        facts.append(tuple(parts))
                except:
                    continue
        
        return facts
    
    def add_from_text(self, text: str):
        """Extract and add facts from text."""
        facts = self.extract_facts(text)
        for subject, predicate, obj in facts:
            self.add_fact(subject, predicate, obj)
    
    def query(self, subject: str = None, predicate: str = None, obj: str = None) -> List[Dict]:
        """Query the knowledge graph."""
        results = []
        
        for u, v, data in self.graph.edges(data=True):
            match = True
            if subject and u != subject:
                match = False
            if obj and v != obj:
                match = False
            if predicate and data.get('relation') != predicate:
                match = False
            
            if match:
                results.append({
                    "subject": u,
                    "predicate": data.get('relation'),
                    "object": v,
                    "confidence": data.get('confidence', 1.0)
                })
        
        return results
    
    def get_related(self, entity: str, max_hops: int = 2) -> Dict:
        """Get all related entities within N hops."""
        if entity not in self.graph:
            return {"entity": entity, "related": []}
        
        related = {}
        visited = {entity}
        current_level = {entity}
        
        for hop in range(max_hops):
            next_level = set()
            for node in current_level:
                # Outgoing edges
                for _, neighbor, data in self.graph.out_edges(node, data=True):
                    if neighbor not in visited:
                        if hop not in related:
                            related[hop] = []
                        related[hop].append({
                            "entity": neighbor,
                            "relation": f"{node} --{data['relation']}--> {neighbor}"
                        })
                        next_level.add(neighbor)
                
                # Incoming edges
                for neighbor, _, data in self.graph.in_edges(node, data=True):
                    if neighbor not in visited:
                        if hop not in related:
                            related[hop] = []
                        related[hop].append({
                            "entity": neighbor,
                            "relation": f"{neighbor} --{data['relation']}--> {node}"
                        })
                        next_level.add(neighbor)
            
            visited.update(next_level)
            current_level = next_level
        
        return {"entity": entity, "related": related}
    
    def reason(self, question: str) -> str:
        """Answer questions using graph reasoning."""
        # Extract entities from question
        entities = self._extract_entities(question)
        
        # Gather relevant subgraph
        context = []
        for entity in entities:
            related = self.get_related(entity, max_hops=2)
            for hop, items in related.get("related", {}).items():
                for item in items:
                    context.append(item["relation"])
        
        # Use LLM to reason with context
        prompt = f"""
        Question: {question}
        
        Known facts:
        {chr(10).join(context)}
        
        Based on these facts, answer the question.
        If the facts don't provide enough information, say so.
        """
        
        return self.llm.invoke(prompt).content
    
    def _extract_entities(self, text: str) -> List[str]:
        """Extract entity names from text."""
        # Simple: find matching nodes
        entities = []
        for node in self.graph.nodes():
            if node.lower() in text.lower():
                entities.append(node)
        return entities
```

---

## 🔄 Integrated Memory System

```python
class AgentMemorySystem:
    """
    Complete memory system integrating all memory types.
    """
    def __init__(self, llm, embedding_model: str = "all-MiniLM-L6-v2"):
        self.llm = llm
        
        # Initialize memory components
        self.working_memory = SlidingWindowMemory(llm=llm)
        self.semantic_memory = SemanticMemory(embedding_model=embedding_model)
        self.episodic_memory = EpisodicMemory(self.semantic_memory, llm)
        self.knowledge_graph = KnowledgeGraph(llm)
    
    def process_interaction(self, user_input: str, agent_response: str):
        """Process an interaction and update all memory systems."""
        # Update working memory
        self.working_memory.add("user", user_input)
        self.working_memory.add("assistant", agent_response)
        
        # Extract and store facts
        combined = f"User: {user_input}\nAssistant: {agent_response}"
        self.knowledge_graph.add_from_text(combined)
        
        # Store in semantic memory if significant
        if self._is_significant(combined):
            self.semantic_memory.store(
                content=combined,
                metadata={"type": "interaction"},
                memory_type="interaction"
            )
    
    def record_experience(self, description: str, context: str, outcome: str):
        """Record a significant experience."""
        self.episodic_memory.record_episode(
            description=description,
            context=context,
            outcome=outcome
        )
    
    def retrieve_relevant_context(self, query: str) -> Dict:
        """Retrieve all relevant context for a query."""
        context = {
            "working_memory": self.working_memory.get_context(),
            "semantic_memories": self.semantic_memory.retrieve(query, top_k=5),
            "similar_experiences": [],
            "related_knowledge": []
        }
        
        # Get similar experiences
        episodes = self.episodic_memory.recall_similar_episodes(query, top_k=3)
        context["similar_experiences"] = [
            {"description": ep.description, "outcome": ep.outcome}
            for ep in episodes
        ]
        
        # Get knowledge graph context
        entities = self.knowledge_graph._extract_entities(query)
        for entity in entities:
            related = self.knowledge_graph.get_related(entity)
            context["related_knowledge"].append(related)
        
        return context
    
    def build_prompt_context(self, query: str, max_tokens: int = 4000) -> str:
        """Build context string for LLM prompt."""
        context = self.retrieve_relevant_context(query)
        
        parts = []
        
        # Working memory (recent conversation)
        parts.append("=== Recent Conversation ===")
        parts.append(context["working_memory"])
        
        # Relevant memories
        if context["semantic_memories"]:
            parts.append("\n=== Relevant Memories ===")
            for mem in context["semantic_memories"][:3]:
                parts.append(f"- {mem['content'][:200]}...")
        
        # Past experiences
        if context["similar_experiences"]:
            parts.append("\n=== Similar Past Experiences ===")
            for exp in context["similar_experiences"]:
                parts.append(f"- {exp['description']} → {exp['outcome']}")
        
        # Knowledge
        if context["related_knowledge"]:
            parts.append("\n=== Related Knowledge ===")
            for kg in context["related_knowledge"]:
                if kg.get("related"):
                    for hop, items in kg["related"].items():
                        for item in items[:3]:
                            parts.append(f"- {item['relation']}")
        
        return "\n".join(parts)
    
    def _is_significant(self, text: str) -> bool:
        """Determine if interaction is worth storing long-term."""
        # Simple heuristics - could use LLM for better classification
        if len(text) < 50:
            return False
        
        significant_keywords = [
            "important", "remember", "note", "decision",
            "agreed", "concluded", "learned", "discovered"
        ]
        
        return any(kw in text.lower() for kw in significant_keywords)
```

---

## 📝 Key Takeaways

1. **Working memory** handles immediate context (conversation)
2. **Semantic memory** stores facts retrievable by similarity
3. **Episodic memory** captures specific experiences
4. **Knowledge graphs** model relationships for reasoning
5. **Integration** combines all types for comprehensive recall
6. **Relevance** is key - retrieve what matters for the task

---

## 🔗 What's Next?

Module 7: **Decision Making and Planning** - How agents make decisions and create plans

---

## 📚 Resources

### Papers
- "Memory-Augmented Neural Networks" (Graves et al.)
- "Generative Agents: Interactive Simulacra of Human Behavior"
- "MemGPT: Towards LLMs as Operating Systems"

### Tools
- [ChromaDB](https://www.trychroma.com/)
- [Pinecone](https://www.pinecone.io/)
- [LangChain Memory](https://python.langchain.com/docs/modules/memory/)

---

*Module 6 Complete. Continue to Module 7: Decision Making and Planning →*

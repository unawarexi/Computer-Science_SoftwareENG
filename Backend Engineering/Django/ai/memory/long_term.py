"""
Long-Term Memory
================
Persistent memory for AI agents.

This module provides:
- Vector-based memory storage
- Entity memory
- Episodic memory
- Memory retrieval and importance scoring
"""

import logging
import hashlib
from abc import ABC, abstractmethod
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional, Tuple

from ai.memory.schemas import MemoryEntry, Entity

logger = logging.getLogger("ai.memory.long_term")


# =============================================================================
# BASE LONG-TERM MEMORY
# =============================================================================

class BaseLongTermMemory(ABC):
    """Base class for long-term memory."""
    
    @abstractmethod
    async def store(self, content: str, **metadata) -> str:
        """Store a memory and return its ID."""
        pass
    
    @abstractmethod
    async def retrieve(self, query: str, k: int = 5) -> List[MemoryEntry]:
        """Retrieve relevant memories."""
        pass
    
    @abstractmethod
    async def forget(self, memory_id: str) -> bool:
        """Remove a memory."""
        pass
    
    @abstractmethod
    async def get_stats(self) -> Dict[str, Any]:
        """Get memory statistics."""
        pass


# =============================================================================
# VECTOR MEMORY
# =============================================================================

class VectorMemory(BaseLongTermMemory):
    """
    Vector-based long-term memory.
    
    Uses embeddings for semantic retrieval.
    """
    
    def __init__(
        self,
        vector_store: Any,
        embeddings_model: Any,
        namespace: str = "default",
    ):
        """
        Initialize vector memory.
        
        Args:
            vector_store: LangChain vector store
            embeddings_model: LangChain embeddings model
            namespace: Namespace for this memory
        """
        self.vector_store = vector_store
        self.embeddings_model = embeddings_model
        self.namespace = namespace
        self._memory_cache: Dict[str, MemoryEntry] = {}
    
    def _generate_id(self, content: str) -> str:
        """Generate unique memory ID."""
        timestamp = datetime.utcnow().isoformat()
        hash_input = f"{self.namespace}:{timestamp}:{content[:100]}"
        return hashlib.sha256(hash_input.encode()).hexdigest()[:16]
    
    async def store(
        self,
        content: str,
        memory_type: str = "general",
        importance: float = 0.5,
        **metadata,
    ) -> str:
        """
        Store a memory.
        
        Args:
            content: Memory content
            memory_type: Type of memory (general, fact, event, preference)
            importance: Importance score (0-1)
            **metadata: Additional metadata
            
        Returns:
            Memory ID
        """
        memory_id = self._generate_id(content)
        
        # Create memory entry
        entry = MemoryEntry(
            id=memory_id,
            content=content,
            memory_type=memory_type,
            importance=importance,
            metadata={
                "namespace": self.namespace,
                **metadata,
            }
        )
        
        # Generate embedding
        embedding = await self.embeddings_model.aembed_query(content)
        entry.embedding = embedding
        
        # Store in vector store
        from langchain_core.documents import Document
        doc = Document(
            page_content=content,
            metadata={
                "memory_id": memory_id,
                "memory_type": memory_type,
                "importance": importance,
                "timestamp": entry.timestamp.isoformat(),
                "namespace": self.namespace,
                **metadata,
            }
        )
        
        await self.vector_store.aadd_documents([doc])
        
        # Cache locally
        self._memory_cache[memory_id] = entry
        
        logger.info(f"Stored memory {memory_id}: {content[:50]}...")
        return memory_id
    
    async def retrieve(
        self,
        query: str,
        k: int = 5,
        memory_type: Optional[str] = None,
        min_importance: Optional[float] = None,
    ) -> List[MemoryEntry]:
        """
        Retrieve relevant memories.
        
        Args:
            query: Search query
            k: Number of memories to retrieve
            memory_type: Filter by memory type
            min_importance: Minimum importance threshold
            
        Returns:
            List of memory entries
        """
        # Build filter
        filter_dict = {"namespace": self.namespace}
        if memory_type:
            filter_dict["memory_type"] = memory_type
        
        # Search vector store
        docs = await self.vector_store.asimilarity_search(
            query,
            k=k * 2,  # Get more for filtering
            filter=filter_dict,
        )
        
        # Convert to memory entries and filter
        entries = []
        for doc in docs:
            importance = doc.metadata.get("importance", 0.5)
            if min_importance and importance < min_importance:
                continue
            
            entry = MemoryEntry(
                id=doc.metadata.get("memory_id", "unknown"),
                content=doc.page_content,
                memory_type=doc.metadata.get("memory_type", "general"),
                importance=importance,
                timestamp=datetime.fromisoformat(doc.metadata.get("timestamp", datetime.utcnow().isoformat())),
                metadata=doc.metadata,
            )
            entry.touch()
            entries.append(entry)
        
        return entries[:k]
    
    async def forget(self, memory_id: str) -> bool:
        """Remove a memory."""
        try:
            # Remove from vector store
            await self.vector_store.adelete([memory_id])
            
            # Remove from cache
            if memory_id in self._memory_cache:
                del self._memory_cache[memory_id]
            
            logger.info(f"Forgot memory {memory_id}")
            return True
        except Exception as e:
            logger.error(f"Failed to forget memory {memory_id}: {e}")
            return False
    
    async def decay(
        self,
        decay_factor: float = 0.99,
        min_importance: float = 0.1,
    ) -> int:
        """
        Decay memory importance over time.
        
        Args:
            decay_factor: Factor to multiply importance by
            min_importance: Remove memories below this threshold
            
        Returns:
            Number of memories decayed/removed
        """
        decayed = 0
        to_remove = []
        
        for memory_id, entry in self._memory_cache.items():
            # Calculate time-based decay
            age = datetime.utcnow() - entry.timestamp
            days_old = age.total_seconds() / 86400
            
            # Apply decay based on age and access
            if entry.access_count == 0 and days_old > 7:
                entry.importance *= decay_factor
            
            if entry.importance < min_importance:
                to_remove.append(memory_id)
            
            decayed += 1
        
        # Remove low-importance memories
        for memory_id in to_remove:
            await self.forget(memory_id)
        
        logger.info(f"Decayed {decayed} memories, removed {len(to_remove)}")
        return decayed
    
    async def get_stats(self) -> Dict[str, Any]:
        """Get memory statistics."""
        return {
            "namespace": self.namespace,
            "cached_count": len(self._memory_cache),
            "memory_types": list(set(
                e.memory_type for e in self._memory_cache.values()
            )),
        }


# =============================================================================
# ENTITY MEMORY
# =============================================================================

class EntityMemory(BaseLongTermMemory):
    """
    Memory system focused on entities.
    
    Tracks people, places, organizations, and their relationships.
    """
    
    ENTITY_EXTRACTION_PROMPT = """Extract entities from the following text.
For each entity, provide:
- name: The entity name
- type: person, organization, location, concept, or other
- description: Brief description based on context

Text: {text}

Output as JSON array:"""
    
    def __init__(
        self,
        llm: Any,
        vector_store: Optional[Any] = None,
        embeddings_model: Optional[Any] = None,
    ):
        """
        Initialize entity memory.
        
        Args:
            llm: LLM for entity extraction
            vector_store: Optional vector store for semantic search
            embeddings_model: Optional embeddings model
        """
        self.llm = llm
        self.vector_store = vector_store
        self.embeddings_model = embeddings_model
        self.entities: Dict[str, Entity] = {}
    
    async def store(
        self,
        content: str,
        **metadata,
    ) -> str:
        """
        Extract and store entities from content.
        
        Args:
            content: Text to extract entities from
            **metadata: Additional metadata
            
        Returns:
            Comma-separated list of entity names
        """
        # Extract entities using LLM
        entities = await self._extract_entities(content)
        
        stored_names = []
        for entity_data in entities:
            name = entity_data.get("name", "").lower()
            if not name:
                continue
            
            if name in self.entities:
                # Update existing entity
                self.entities[name].update(entity_data)
            else:
                # Create new entity
                self.entities[name] = Entity(
                    name=name,
                    entity_type=entity_data.get("type", "other"),
                    description=entity_data.get("description", ""),
                )
            
            stored_names.append(name)
        
        return ",".join(stored_names)
    
    async def _extract_entities(self, text: str) -> List[Dict[str, Any]]:
        """Extract entities using LLM."""
        import json
        
        prompt = self.ENTITY_EXTRACTION_PROMPT.format(text=text[:2000])
        response = self.llm.invoke(prompt)
        content = response.content if hasattr(response, 'content') else str(response)
        
        try:
            # Try to parse JSON
            # Find JSON array in response
            start = content.find("[")
            end = content.rfind("]") + 1
            if start >= 0 and end > start:
                return json.loads(content[start:end])
        except json.JSONDecodeError:
            logger.warning("Failed to parse entity extraction response")
        
        return []
    
    async def retrieve(
        self,
        query: str,
        k: int = 5,
    ) -> List[MemoryEntry]:
        """
        Retrieve entities matching query.
        
        Args:
            query: Search query
            k: Number of entities to return
            
        Returns:
            Memory entries for matching entities
        """
        query_lower = query.lower()
        matches = []
        
        for name, entity in self.entities.items():
            # Simple matching
            if query_lower in name or query_lower in entity.description.lower():
                entry = MemoryEntry(
                    id=name,
                    content=f"{entity.name} ({entity.entity_type}): {entity.description}",
                    memory_type="entity",
                    importance=min(entity.mention_count / 10, 1.0),
                    metadata={
                        "entity_type": entity.entity_type,
                        "mention_count": entity.mention_count,
                    },
                )
                matches.append(entry)
        
        # Sort by mention count
        matches.sort(key=lambda x: x.importance, reverse=True)
        return matches[:k]
    
    async def forget(self, memory_id: str) -> bool:
        """Remove an entity."""
        if memory_id in self.entities:
            del self.entities[memory_id]
            return True
        return False
    
    async def get_stats(self) -> Dict[str, Any]:
        """Get entity statistics."""
        type_counts = {}
        for entity in self.entities.values():
            type_counts[entity.entity_type] = type_counts.get(entity.entity_type, 0) + 1
        
        return {
            "total_entities": len(self.entities),
            "entity_types": type_counts,
        }
    
    def get_entity(self, name: str) -> Optional[Entity]:
        """Get entity by name."""
        return self.entities.get(name.lower())
    
    def get_all_entities(self) -> List[Entity]:
        """Get all entities."""
        return list(self.entities.values())


# =============================================================================
# COMBINED LONG-TERM MEMORY
# =============================================================================

class LongTermMemory:
    """
    Combined long-term memory system.
    
    Integrates vector memory and entity memory.
    """
    
    def __init__(
        self,
        vector_store: Any,
        embeddings_model: Any,
        llm: Optional[Any] = None,
        namespace: str = "default",
    ):
        """
        Initialize long-term memory.
        
        Args:
            vector_store: LangChain vector store
            embeddings_model: LangChain embeddings model
            llm: Optional LLM for entity extraction
            namespace: Memory namespace
        """
        self.vector_memory = VectorMemory(
            vector_store=vector_store,
            embeddings_model=embeddings_model,
            namespace=namespace,
        )
        
        self.entity_memory = EntityMemory(
            llm=llm,
            vector_store=vector_store,
            embeddings_model=embeddings_model,
        ) if llm else None
    
    async def store(
        self,
        content: str,
        extract_entities: bool = True,
        **metadata,
    ) -> Dict[str, str]:
        """
        Store memory and optionally extract entities.
        
        Args:
            content: Content to store
            extract_entities: Whether to extract entities
            **metadata: Additional metadata
            
        Returns:
            Dict with memory_id and entity_names
        """
        result = {}
        
        # Store in vector memory
        memory_id = await self.vector_memory.store(content, **metadata)
        result["memory_id"] = memory_id
        
        # Extract entities if enabled
        if extract_entities and self.entity_memory:
            entity_names = await self.entity_memory.store(content, **metadata)
            result["entity_names"] = entity_names
        
        return result
    
    async def retrieve(
        self,
        query: str,
        k: int = 5,
        include_entities: bool = True,
    ) -> Dict[str, List[MemoryEntry]]:
        """
        Retrieve relevant memories.
        
        Args:
            query: Search query
            k: Number of results
            include_entities: Include entity matches
            
        Returns:
            Dict with memories and entities
        """
        result = {}
        
        # Vector search
        result["memories"] = await self.vector_memory.retrieve(query, k=k)
        
        # Entity search
        if include_entities and self.entity_memory:
            result["entities"] = await self.entity_memory.retrieve(query, k=k)
        
        return result
    
    async def get_stats(self) -> Dict[str, Any]:
        """Get combined statistics."""
        stats = {
            "vector_memory": await self.vector_memory.get_stats(),
        }
        
        if self.entity_memory:
            stats["entity_memory"] = await self.entity_memory.get_stats()
        
        return stats

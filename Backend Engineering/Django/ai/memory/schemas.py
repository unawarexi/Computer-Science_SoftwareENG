"""
Memory Schemas
==============
Data models for memory systems.

This module defines:
- Message schema
- Memory entry schema
- Conversation context
"""

from datetime import datetime
from typing import Any, Dict, List, Optional, Literal
from dataclasses import dataclass, field
from enum import Enum

from pydantic import BaseModel, Field


# =============================================================================
# MESSAGE TYPES
# =============================================================================

class MessageRole(str, Enum):
    """Message role types."""
    SYSTEM = "system"
    USER = "user"
    ASSISTANT = "assistant"
    TOOL = "tool"
    FUNCTION = "function"


# =============================================================================
# MESSAGE SCHEMA
# =============================================================================

class Message(BaseModel):
    """
    Chat message schema.
    
    Compatible with OpenAI/Anthropic message formats.
    """
    role: MessageRole
    content: str
    name: Optional[str] = None
    tool_call_id: Optional[str] = None
    tool_calls: Optional[List[Dict[str, Any]]] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    metadata: Dict[str, Any] = Field(default_factory=dict)
    
    def to_openai(self) -> Dict[str, Any]:
        """Convert to OpenAI message format."""
        msg = {
            "role": self.role.value,
            "content": self.content,
        }
        if self.name:
            msg["name"] = self.name
        if self.tool_call_id:
            msg["tool_call_id"] = self.tool_call_id
        if self.tool_calls:
            msg["tool_calls"] = self.tool_calls
        return msg
    
    def to_anthropic(self) -> Dict[str, Any]:
        """Convert to Anthropic message format."""
        return {
            "role": "user" if self.role == MessageRole.USER else "assistant",
            "content": self.content,
        }
    
    def to_langchain(self):
        """Convert to LangChain message."""
        from langchain_core.messages import (
            SystemMessage,
            HumanMessage,
            AIMessage,
            ToolMessage,
        )
        
        if self.role == MessageRole.SYSTEM:
            return SystemMessage(content=self.content)
        elif self.role == MessageRole.USER:
            return HumanMessage(content=self.content)
        elif self.role == MessageRole.ASSISTANT:
            return AIMessage(content=self.content)
        elif self.role == MessageRole.TOOL:
            return ToolMessage(
                content=self.content,
                tool_call_id=self.tool_call_id or "",
            )
        return HumanMessage(content=self.content)
    
    @classmethod
    def from_langchain(cls, message) -> "Message":
        """Create from LangChain message."""
        from langchain_core.messages import (
            SystemMessage,
            HumanMessage,
            AIMessage,
            ToolMessage,
        )
        
        if isinstance(message, SystemMessage):
            role = MessageRole.SYSTEM
        elif isinstance(message, HumanMessage):
            role = MessageRole.USER
        elif isinstance(message, AIMessage):
            role = MessageRole.ASSISTANT
        elif isinstance(message, ToolMessage):
            role = MessageRole.TOOL
        else:
            role = MessageRole.USER
        
        return cls(
            role=role,
            content=message.content,
            tool_call_id=getattr(message, 'tool_call_id', None),
        )


# =============================================================================
# MEMORY ENTRY
# =============================================================================

class MemoryEntry(BaseModel):
    """
    Single memory entry for long-term storage.
    """
    id: str
    content: str
    memory_type: str = "general"  # general, fact, event, preference
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    importance: float = 0.5  # 0-1 scale
    access_count: int = 0
    last_accessed: Optional[datetime] = None
    metadata: Dict[str, Any] = Field(default_factory=dict)
    embedding: Optional[List[float]] = None
    
    def touch(self) -> None:
        """Update access timestamp and count."""
        self.access_count += 1
        self.last_accessed = datetime.utcnow()


# =============================================================================
# CONVERSATION CONTEXT
# =============================================================================

class ConversationContext(BaseModel):
    """
    Complete conversation context.
    """
    conversation_id: str
    messages: List[Message] = Field(default_factory=list)
    summary: Optional[str] = None
    entities: Dict[str, Any] = Field(default_factory=dict)
    topics: List[str] = Field(default_factory=list)
    metadata: Dict[str, Any] = Field(default_factory=dict)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    
    @property
    def message_count(self) -> int:
        """Get number of messages."""
        return len(self.messages)
    
    @property
    def token_estimate(self) -> int:
        """Estimate token count (rough: 4 chars per token)."""
        total_chars = sum(len(m.content) for m in self.messages)
        return total_chars // 4
    
    def add_message(self, message: Message) -> None:
        """Add message and update timestamp."""
        self.messages.append(message)
        self.updated_at = datetime.utcnow()
    
    def get_last_n(self, n: int) -> List[Message]:
        """Get last n messages."""
        return self.messages[-n:]
    
    def to_langchain_messages(self) -> List:
        """Convert all messages to LangChain format."""
        return [m.to_langchain() for m in self.messages]
    
    def to_openai_messages(self) -> List[Dict[str, Any]]:
        """Convert all messages to OpenAI format."""
        return [m.to_openai() for m in self.messages]


# =============================================================================
# ENTITY SCHEMA
# =============================================================================

class Entity(BaseModel):
    """
    Entity extracted from conversation.
    """
    name: str
    entity_type: str  # person, organization, location, etc.
    description: str = ""
    attributes: Dict[str, Any] = Field(default_factory=dict)
    relationships: List[Dict[str, str]] = Field(default_factory=list)
    first_mentioned: datetime = Field(default_factory=datetime.utcnow)
    last_mentioned: datetime = Field(default_factory=datetime.utcnow)
    mention_count: int = 1
    
    def update(self, new_info: Dict[str, Any]) -> None:
        """Update entity with new information."""
        if "description" in new_info:
            self.description = new_info["description"]
        if "attributes" in new_info:
            self.attributes.update(new_info["attributes"])
        if "relationships" in new_info:
            self.relationships.extend(new_info["relationships"])
        self.last_mentioned = datetime.utcnow()
        self.mention_count += 1


# =============================================================================
# MEMORY STATS
# =============================================================================

@dataclass
class MemoryStats:
    """Statistics about memory usage."""
    total_messages: int = 0
    total_tokens: int = 0
    summary_count: int = 0
    entity_count: int = 0
    long_term_entries: int = 0
    oldest_message: Optional[datetime] = None
    newest_message: Optional[datetime] = None
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return {
            "total_messages": self.total_messages,
            "total_tokens": self.total_tokens,
            "summary_count": self.summary_count,
            "entity_count": self.entity_count,
            "long_term_entries": self.long_term_entries,
            "oldest_message": self.oldest_message.isoformat() if self.oldest_message else None,
            "newest_message": self.newest_message.isoformat() if self.newest_message else None,
        }

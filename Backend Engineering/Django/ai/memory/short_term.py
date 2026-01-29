"""
Short-Term Memory
=================
Conversation memory for AI agents.

This module provides:
- Buffer memory (full history)
- Window memory (last N messages)
- Summary memory (compressed history)
- Token-limited memory
"""

import logging
from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

from langchain_core.messages import BaseMessage

from ai.memory.schemas import (
    Message,
    MessageRole,
    ConversationContext,
    MemoryStats,
)

logger = logging.getLogger("ai.memory.short_term")


# =============================================================================
# BASE MEMORY
# =============================================================================

class BaseConversationMemory(ABC):
    """Base class for conversation memory."""
    
    @abstractmethod
    def add_message(self, message: Message) -> None:
        """Add a message to memory."""
        pass
    
    @abstractmethod
    def get_messages(self) -> List[Message]:
        """Get messages from memory."""
        pass
    
    @abstractmethod
    def clear(self) -> None:
        """Clear memory."""
        pass
    
    def add_user_message(self, content: str) -> None:
        """Add user message."""
        self.add_message(Message(role=MessageRole.USER, content=content))
    
    def add_assistant_message(self, content: str) -> None:
        """Add assistant message."""
        self.add_message(Message(role=MessageRole.ASSISTANT, content=content))
    
    def add_system_message(self, content: str) -> None:
        """Add system message."""
        self.add_message(Message(role=MessageRole.SYSTEM, content=content))
    
    def get_langchain_messages(self) -> List[BaseMessage]:
        """Get messages in LangChain format."""
        return [m.to_langchain() for m in self.get_messages()]
    
    def get_openai_messages(self) -> List[Dict[str, Any]]:
        """Get messages in OpenAI format."""
        return [m.to_openai() for m in self.get_messages()]


# =============================================================================
# BUFFER MEMORY
# =============================================================================

class BufferMemory(BaseConversationMemory):
    """
    Simple buffer memory that stores all messages.
    
    Warning: Can grow unbounded. Use for short conversations.
    """
    
    def __init__(
        self,
        system_message: Optional[str] = None,
        return_messages: bool = True,
    ):
        """
        Initialize buffer memory.
        
        Args:
            system_message: Optional system message to prepend
            return_messages: Whether to return Message objects or dicts
        """
        self.messages: List[Message] = []
        self.system_message = system_message
        self.return_messages = return_messages
        
        if system_message:
            self.add_system_message(system_message)
    
    def add_message(self, message: Message) -> None:
        """Add message to buffer."""
        self.messages.append(message)
    
    def get_messages(self) -> List[Message]:
        """Get all messages."""
        return self.messages.copy()
    
    def clear(self) -> None:
        """Clear all messages."""
        self.messages.clear()
        if self.system_message:
            self.add_system_message(self.system_message)


# =============================================================================
# WINDOW MEMORY
# =============================================================================

class WindowMemory(BaseConversationMemory):
    """
    Window memory that keeps only the last N messages.
    
    Useful for limiting context while keeping recent history.
    """
    
    def __init__(
        self,
        window_size: int = 10,
        system_message: Optional[str] = None,
    ):
        """
        Initialize window memory.
        
        Args:
            window_size: Number of messages to keep
            system_message: Optional system message (always kept)
        """
        self.window_size = window_size
        self.system_message = system_message
        self.messages: List[Message] = []
        
        if system_message:
            self.add_system_message(system_message)
    
    def add_message(self, message: Message) -> None:
        """Add message, maintaining window size."""
        self.messages.append(message)
        
        # Keep system message + last N messages
        if len(self.messages) > self.window_size + 1:
            # Preserve system message if present
            if self.system_message and self.messages[0].role == MessageRole.SYSTEM:
                self.messages = [self.messages[0]] + self.messages[-(self.window_size):]
            else:
                self.messages = self.messages[-self.window_size:]
    
    def get_messages(self) -> List[Message]:
        """Get messages in window."""
        return self.messages.copy()
    
    def clear(self) -> None:
        """Clear messages."""
        self.messages.clear()
        if self.system_message:
            self.add_system_message(self.system_message)


# =============================================================================
# SUMMARY MEMORY
# =============================================================================

class SummaryMemory(BaseConversationMemory):
    """
    Memory that summarizes old messages.
    
    Keeps recent messages and summarizes older ones.
    """
    
    SUMMARY_PROMPT = """Summarize the following conversation history in a concise paragraph.
Focus on key information, decisions, and context that might be relevant for future messages.

Conversation:
{conversation}

Summary:"""
    
    def __init__(
        self,
        llm: Any,
        max_messages: int = 10,
        summarize_threshold: int = 15,
        system_message: Optional[str] = None,
    ):
        """
        Initialize summary memory.
        
        Args:
            llm: LLM for generating summaries
            max_messages: Messages to keep after summarization
            summarize_threshold: Trigger summarization at this count
            system_message: Optional system message
        """
        self.llm = llm
        self.max_messages = max_messages
        self.summarize_threshold = summarize_threshold
        self.system_message = system_message
        self.messages: List[Message] = []
        self.summary: Optional[str] = None
        
        if system_message:
            self.add_system_message(system_message)
    
    def add_message(self, message: Message) -> None:
        """Add message, summarizing if threshold reached."""
        self.messages.append(message)
        
        if len(self.messages) >= self.summarize_threshold:
            self._summarize()
    
    def _summarize(self) -> None:
        """Summarize older messages."""
        # Keep system message and recent messages
        start_idx = 1 if self.system_message else 0
        messages_to_summarize = self.messages[start_idx:-self.max_messages]
        
        if not messages_to_summarize:
            return
        
        # Format conversation
        conversation = "\n".join(
            f"{m.role.value}: {m.content}"
            for m in messages_to_summarize
        )
        
        # Include existing summary if any
        if self.summary:
            conversation = f"Previous summary: {self.summary}\n\n{conversation}"
        
        # Generate summary
        prompt = self.SUMMARY_PROMPT.format(conversation=conversation)
        response = self.llm.invoke(prompt)
        self.summary = response.content if hasattr(response, 'content') else str(response)
        
        # Keep only recent messages
        if self.system_message:
            self.messages = [self.messages[0]] + self.messages[-self.max_messages:]
        else:
            self.messages = self.messages[-self.max_messages:]
        
        logger.info(f"Summarized {len(messages_to_summarize)} messages")
    
    def get_messages(self) -> List[Message]:
        """Get messages with summary prepended if available."""
        messages = []
        
        if self.summary:
            messages.append(Message(
                role=MessageRole.SYSTEM,
                content=f"Previous conversation summary: {self.summary}",
            ))
        
        messages.extend(self.messages)
        return messages
    
    def clear(self) -> None:
        """Clear memory and summary."""
        self.messages.clear()
        self.summary = None
        if self.system_message:
            self.add_system_message(self.system_message)


# =============================================================================
# TOKEN-LIMITED MEMORY
# =============================================================================

class TokenLimitedMemory(BaseConversationMemory):
    """
    Memory limited by token count.
    
    Removes oldest messages when token limit exceeded.
    """
    
    def __init__(
        self,
        max_tokens: int = 4000,
        system_message: Optional[str] = None,
        tokenizer: Optional[Any] = None,
    ):
        """
        Initialize token-limited memory.
        
        Args:
            max_tokens: Maximum tokens to keep
            system_message: Optional system message
            tokenizer: Optional tokenizer (defaults to estimate)
        """
        self.max_tokens = max_tokens
        self.system_message = system_message
        self.tokenizer = tokenizer
        self.messages: List[Message] = []
        
        if system_message:
            self.add_system_message(system_message)
    
    def _count_tokens(self, text: str) -> int:
        """Count tokens in text."""
        if self.tokenizer:
            return len(self.tokenizer.encode(text))
        # Rough estimate: 4 characters per token
        return len(text) // 4
    
    def _total_tokens(self) -> int:
        """Calculate total tokens in memory."""
        return sum(self._count_tokens(m.content) for m in self.messages)
    
    def add_message(self, message: Message) -> None:
        """Add message, removing old ones if over limit."""
        self.messages.append(message)
        
        # Remove oldest messages until under limit
        start_idx = 1 if self.system_message else 0
        while self._total_tokens() > self.max_tokens and len(self.messages) > start_idx + 1:
            self.messages.pop(start_idx)
    
    def get_messages(self) -> List[Message]:
        """Get messages within token limit."""
        return self.messages.copy()
    
    def clear(self) -> None:
        """Clear messages."""
        self.messages.clear()
        if self.system_message:
            self.add_system_message(self.system_message)


# =============================================================================
# CONVERSATION MEMORY (UNIFIED)
# =============================================================================

class ConversationMemory:
    """
    Unified conversation memory with multiple strategies.
    
    Combines buffer, window, and summary approaches.
    """
    
    def __init__(
        self,
        strategy: str = "buffer",
        system_message: Optional[str] = None,
        llm: Optional[Any] = None,
        **kwargs,
    ):
        """
        Initialize conversation memory.
        
        Args:
            strategy: Memory strategy (buffer, window, summary, token)
            system_message: Optional system message
            llm: LLM for summary strategy
            **kwargs: Additional strategy-specific arguments
        """
        self.strategy = strategy
        
        if strategy == "buffer":
            self._memory = BufferMemory(system_message=system_message)
        elif strategy == "window":
            self._memory = WindowMemory(
                window_size=kwargs.get("window_size", 10),
                system_message=system_message,
            )
        elif strategy == "summary":
            if not llm:
                raise ValueError("LLM required for summary strategy")
            self._memory = SummaryMemory(
                llm=llm,
                max_messages=kwargs.get("max_messages", 10),
                summarize_threshold=kwargs.get("summarize_threshold", 15),
                system_message=system_message,
            )
        elif strategy == "token":
            self._memory = TokenLimitedMemory(
                max_tokens=kwargs.get("max_tokens", 4000),
                system_message=system_message,
            )
        else:
            raise ValueError(f"Unknown strategy: {strategy}")
    
    def add_message(self, message: Message) -> None:
        """Add message."""
        self._memory.add_message(message)
    
    def add_user_message(self, content: str) -> None:
        """Add user message."""
        self._memory.add_user_message(content)
    
    def add_assistant_message(self, content: str) -> None:
        """Add assistant message."""
        self._memory.add_assistant_message(content)
    
    def get_messages(self) -> List[Message]:
        """Get messages."""
        return self._memory.get_messages()
    
    def get_langchain_messages(self) -> List[BaseMessage]:
        """Get LangChain messages."""
        return self._memory.get_langchain_messages()
    
    def get_openai_messages(self) -> List[Dict[str, Any]]:
        """Get OpenAI format messages."""
        return self._memory.get_openai_messages()
    
    def clear(self) -> None:
        """Clear memory."""
        self._memory.clear()
    
    def get_stats(self) -> MemoryStats:
        """Get memory statistics."""
        messages = self.get_messages()
        return MemoryStats(
            total_messages=len(messages),
            total_tokens=sum(len(m.content) // 4 for m in messages),
            summary_count=1 if hasattr(self._memory, 'summary') and self._memory.summary else 0,
            oldest_message=messages[0].timestamp if messages else None,
            newest_message=messages[-1].timestamp if messages else None,
        )

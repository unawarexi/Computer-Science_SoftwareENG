"""
Tracing Module
==============
LLM observability and tracing.

This module provides:
- Call tracing
- LangSmith integration
- Performance monitoring
"""

import logging
import time
import uuid
from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Callable, Dict, List, Optional
from dataclasses import dataclass, field
from functools import wraps
from contextlib import contextmanager

logger = logging.getLogger("ai.eval.traces")


# =============================================================================
# TRACE DATA
# =============================================================================

@dataclass
class TraceSpan:
    """Single trace span."""
    id: str
    name: str
    start_time: datetime
    end_time: Optional[datetime] = None
    duration_ms: Optional[float] = None
    input_data: Dict[str, Any] = field(default_factory=dict)
    output_data: Dict[str, Any] = field(default_factory=dict)
    metadata: Dict[str, Any] = field(default_factory=dict)
    error: Optional[str] = None
    parent_id: Optional[str] = None
    children: List["TraceSpan"] = field(default_factory=list)
    
    def complete(self, output: Any = None, error: str = None) -> None:
        """Complete the span."""
        self.end_time = datetime.utcnow()
        self.duration_ms = (self.end_time - self.start_time).total_seconds() * 1000
        if output is not None:
            self.output_data["result"] = output
        if error:
            self.error = error
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return {
            "id": self.id,
            "name": self.name,
            "start_time": self.start_time.isoformat(),
            "end_time": self.end_time.isoformat() if self.end_time else None,
            "duration_ms": self.duration_ms,
            "input": self.input_data,
            "output": self.output_data,
            "metadata": self.metadata,
            "error": self.error,
            "parent_id": self.parent_id,
            "children": [c.to_dict() for c in self.children],
        }


@dataclass
class Trace:
    """Complete trace for a request."""
    id: str
    name: str
    start_time: datetime
    spans: List[TraceSpan] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)
    
    @property
    def duration_ms(self) -> Optional[float]:
        """Total trace duration."""
        if not self.spans:
            return None
        
        end_times = [s.end_time for s in self.spans if s.end_time]
        if not end_times:
            return None
        
        latest = max(end_times)
        return (latest - self.start_time).total_seconds() * 1000
    
    def add_span(self, span: TraceSpan) -> None:
        """Add span to trace."""
        self.spans.append(span)
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return {
            "id": self.id,
            "name": self.name,
            "start_time": self.start_time.isoformat(),
            "duration_ms": self.duration_ms,
            "spans": [s.to_dict() for s in self.spans],
            "metadata": self.metadata,
        }


# =============================================================================
# BASE TRACER
# =============================================================================

class BaseTracer(ABC):
    """Base class for tracers."""
    
    @abstractmethod
    def start_trace(self, name: str, **metadata) -> Trace:
        """Start a new trace."""
        pass
    
    @abstractmethod
    def start_span(
        self,
        trace: Trace,
        name: str,
        parent_id: Optional[str] = None,
        **input_data,
    ) -> TraceSpan:
        """Start a new span within a trace."""
        pass
    
    @abstractmethod
    def end_span(
        self,
        span: TraceSpan,
        output: Any = None,
        error: str = None,
    ) -> None:
        """End a span."""
        pass
    
    @abstractmethod
    def end_trace(self, trace: Trace) -> None:
        """End a trace."""
        pass


# =============================================================================
# IN-MEMORY TRACER
# =============================================================================

class Tracer(BaseTracer):
    """
    In-memory tracer for development.
    
    Stores traces locally for debugging.
    """
    
    def __init__(self, max_traces: int = 100):
        """Initialize tracer."""
        self.max_traces = max_traces
        self.traces: List[Trace] = []
        self._current_trace: Optional[Trace] = None
        self._current_span: Optional[TraceSpan] = None
    
    def start_trace(self, name: str, **metadata) -> Trace:
        """Start a new trace."""
        trace = Trace(
            id=str(uuid.uuid4()),
            name=name,
            start_time=datetime.utcnow(),
            metadata=metadata,
        )
        self._current_trace = trace
        return trace
    
    def start_span(
        self,
        trace: Trace,
        name: str,
        parent_id: Optional[str] = None,
        **input_data,
    ) -> TraceSpan:
        """Start a new span."""
        span = TraceSpan(
            id=str(uuid.uuid4()),
            name=name,
            start_time=datetime.utcnow(),
            input_data=input_data,
            parent_id=parent_id,
        )
        trace.add_span(span)
        self._current_span = span
        return span
    
    def end_span(
        self,
        span: TraceSpan,
        output: Any = None,
        error: str = None,
    ) -> None:
        """End a span."""
        span.complete(output=output, error=error)
        self._current_span = None
    
    def end_trace(self, trace: Trace) -> None:
        """End and store trace."""
        self.traces.append(trace)
        self._current_trace = None
        
        # Limit stored traces
        if len(self.traces) > self.max_traces:
            self.traces = self.traces[-self.max_traces:]
    
    def get_traces(self, limit: int = 10) -> List[Trace]:
        """Get recent traces."""
        return self.traces[-limit:]
    
    def get_trace(self, trace_id: str) -> Optional[Trace]:
        """Get trace by ID."""
        for trace in self.traces:
            if trace.id == trace_id:
                return trace
        return None
    
    def clear(self) -> None:
        """Clear all traces."""
        self.traces.clear()
    
    @contextmanager
    def trace(self, name: str, **metadata):
        """Context manager for tracing."""
        trace = self.start_trace(name, **metadata)
        try:
            yield trace
        except Exception as e:
            trace.metadata["error"] = str(e)
            raise
        finally:
            self.end_trace(trace)
    
    @contextmanager
    def span(self, name: str, **input_data):
        """Context manager for spans."""
        if not self._current_trace:
            yield None
            return
        
        parent_id = self._current_span.id if self._current_span else None
        span = self.start_span(
            self._current_trace,
            name,
            parent_id=parent_id,
            **input_data,
        )
        try:
            yield span
        except Exception as e:
            self.end_span(span, error=str(e))
            raise
        else:
            self.end_span(span)


# =============================================================================
# LANGSMITH TRACER
# =============================================================================

class LangSmithTracer(BaseTracer):
    """
    Tracer that sends data to LangSmith.
    
    Requires LANGCHAIN_API_KEY environment variable.
    """
    
    def __init__(
        self,
        project_name: str = "default",
        api_key: Optional[str] = None,
    ):
        """Initialize LangSmith tracer."""
        self.project_name = project_name
        self._client = None
        
        try:
            from langsmith import Client
            self._client = Client(api_key=api_key)
        except ImportError:
            logger.warning("langsmith not installed, tracing disabled")
        except Exception as e:
            logger.warning(f"LangSmith initialization failed: {e}")
    
    def start_trace(self, name: str, **metadata) -> Trace:
        """Start a new trace."""
        trace = Trace(
            id=str(uuid.uuid4()),
            name=name,
            start_time=datetime.utcnow(),
            metadata=metadata,
        )
        
        if self._client:
            try:
                # Create LangSmith run
                self._client.create_run(
                    name=name,
                    run_type="chain",
                    inputs=metadata,
                    project_name=self.project_name,
                    run_id=trace.id,
                )
            except Exception as e:
                logger.warning(f"Failed to create LangSmith run: {e}")
        
        return trace
    
    def start_span(
        self,
        trace: Trace,
        name: str,
        parent_id: Optional[str] = None,
        **input_data,
    ) -> TraceSpan:
        """Start a new span."""
        span = TraceSpan(
            id=str(uuid.uuid4()),
            name=name,
            start_time=datetime.utcnow(),
            input_data=input_data,
            parent_id=parent_id or trace.id,
        )
        trace.add_span(span)
        
        if self._client:
            try:
                self._client.create_run(
                    name=name,
                    run_type="tool",
                    inputs=input_data,
                    project_name=self.project_name,
                    run_id=span.id,
                    parent_run_id=span.parent_id,
                )
            except Exception as e:
                logger.warning(f"Failed to create LangSmith span: {e}")
        
        return span
    
    def end_span(
        self,
        span: TraceSpan,
        output: Any = None,
        error: str = None,
    ) -> None:
        """End a span."""
        span.complete(output=output, error=error)
        
        if self._client:
            try:
                self._client.update_run(
                    run_id=span.id,
                    outputs={"result": output} if output else None,
                    error=error,
                    end_time=span.end_time,
                )
            except Exception as e:
                logger.warning(f"Failed to update LangSmith span: {e}")
    
    def end_trace(self, trace: Trace) -> None:
        """End a trace."""
        if self._client:
            try:
                self._client.update_run(
                    run_id=trace.id,
                    end_time=datetime.utcnow(),
                    outputs={"spans": len(trace.spans)},
                )
            except Exception as e:
                logger.warning(f"Failed to update LangSmith trace: {e}")


# =============================================================================
# DECORATOR
# =============================================================================

def trace_call(name: Optional[str] = None, tracer: Optional[BaseTracer] = None):
    """
    Decorator to trace function calls.
    
    Args:
        name: Span name (defaults to function name)
        tracer: Tracer to use (defaults to global)
    """
    def decorator(func: Callable) -> Callable:
        span_name = name or func.__name__
        
        @wraps(func)
        async def async_wrapper(*args, **kwargs):
            _tracer = tracer or get_tracer()
            if not _tracer or not hasattr(_tracer, '_current_trace'):
                return await func(*args, **kwargs)
            
            with _tracer.span(span_name, args=str(args)[:100], kwargs=str(kwargs)[:100]):
                return await func(*args, **kwargs)
        
        @wraps(func)
        def sync_wrapper(*args, **kwargs):
            _tracer = tracer or get_tracer()
            if not _tracer or not hasattr(_tracer, '_current_trace'):
                return func(*args, **kwargs)
            
            with _tracer.span(span_name, args=str(args)[:100], kwargs=str(kwargs)[:100]):
                return func(*args, **kwargs)
        
        import asyncio
        if asyncio.iscoroutinefunction(func):
            return async_wrapper
        return sync_wrapper
    
    return decorator


# =============================================================================
# GLOBAL TRACER
# =============================================================================

_tracer: Optional[BaseTracer] = None


def get_tracer() -> Optional[BaseTracer]:
    """Get global tracer instance."""
    global _tracer
    return _tracer


def set_tracer(tracer: BaseTracer) -> None:
    """Set global tracer."""
    global _tracer
    _tracer = tracer


def init_tracer(
    backend: str = "memory",
    **kwargs,
) -> BaseTracer:
    """
    Initialize and set global tracer.
    
    Args:
        backend: Tracer backend ("memory" or "langsmith")
        **kwargs: Backend-specific arguments
        
    Returns:
        Initialized tracer
    """
    global _tracer
    
    if backend == "langsmith":
        _tracer = LangSmithTracer(**kwargs)
    else:
        _tracer = Tracer(**kwargs)
    
    return _tracer

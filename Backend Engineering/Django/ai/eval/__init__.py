"""
AI Evaluation Module
====================
Metrics and tracing for AI systems.

This module provides:
- Evaluation metrics
- LLM tracing and observability
- Performance monitoring
"""

from ai.eval.metrics import (
    Evaluator,
    AnswerRelevancy,
    Faithfulness,
    ContextRecall,
    ContextPrecision,
    evaluate_rag,
)
from ai.eval.traces import (
    Tracer,
    LangSmithTracer,
    trace_call,
    get_tracer,
)

__all__ = [
    # Metrics
    "Evaluator",
    "AnswerRelevancy",
    "Faithfulness",
    "ContextRecall",
    "ContextPrecision",
    "evaluate_rag",
    # Tracing
    "Tracer",
    "LangSmithTracer",
    "trace_call",
    "get_tracer",
]

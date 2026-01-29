"""
Evaluation Metrics
==================
Metrics for evaluating AI system quality.

This module provides:
- RAG evaluation metrics
- Answer quality metrics
- Retrieval metrics
"""

import logging
from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional
from dataclasses import dataclass, field

logger = logging.getLogger("ai.eval.metrics")


# =============================================================================
# BASE METRIC
# =============================================================================

@dataclass
class MetricResult:
    """Result from metric evaluation."""
    name: str
    score: float  # 0-1
    reason: str = ""
    metadata: Dict[str, Any] = field(default_factory=dict)


class BaseMetric(ABC):
    """Base class for evaluation metrics."""
    
    @property
    @abstractmethod
    def name(self) -> str:
        """Metric name."""
        pass
    
    @abstractmethod
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> MetricResult:
        """
        Evaluate and return score.
        
        Args:
            question: User question
            answer: Generated answer
            context: Retrieved context documents
            ground_truth: Expected answer (if available)
            
        Returns:
            MetricResult with score and details
        """
        pass


# =============================================================================
# ANSWER RELEVANCY
# =============================================================================

class AnswerRelevancy(BaseMetric):
    """
    Evaluate how relevant the answer is to the question.
    
    Uses LLM to score relevancy.
    """
    
    RELEVANCY_PROMPT = """Score how relevant the answer is to the question on a scale of 0-10.
Consider:
- Does the answer address the question directly?
- Is the information provided helpful?
- Is the response focused and not off-topic?

Question: {question}

Answer: {answer}

Score (0-10) and brief reason:"""
    
    def __init__(self, llm: Any):
        """Initialize with LLM for evaluation."""
        self.llm = llm
    
    @property
    def name(self) -> str:
        return "answer_relevancy"
    
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> MetricResult:
        """Evaluate answer relevancy."""
        prompt = self.RELEVANCY_PROMPT.format(
            question=question,
            answer=answer,
        )
        
        try:
            response = await self.llm.ainvoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            # Parse score (look for number at start)
            score = self._parse_score(content)
            
            return MetricResult(
                name=self.name,
                score=score / 10,  # Normalize to 0-1
                reason=content,
            )
        except Exception as e:
            logger.error(f"Relevancy evaluation failed: {e}")
            return MetricResult(name=self.name, score=0.5, reason=str(e))
    
    def _parse_score(self, text: str) -> float:
        """Parse numeric score from text."""
        import re
        match = re.search(r'(\d+(?:\.\d+)?)', text)
        if match:
            return min(float(match.group(1)), 10)
        return 5.0


# =============================================================================
# FAITHFULNESS
# =============================================================================

class Faithfulness(BaseMetric):
    """
    Evaluate if the answer is faithful to the provided context.
    
    Checks for hallucinations.
    """
    
    FAITHFULNESS_PROMPT = """Evaluate if the answer is faithful to the provided context.
A faithful answer only contains information that can be verified from the context.

Context:
{context}

Answer: {answer}

Score faithfulness from 0-10 where:
- 0 = Completely unfaithful (all hallucinated)
- 10 = Completely faithful (all verifiable)

Score and reason:"""
    
    def __init__(self, llm: Any):
        self.llm = llm
    
    @property
    def name(self) -> str:
        return "faithfulness"
    
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> MetricResult:
        """Evaluate faithfulness."""
        if not context:
            return MetricResult(
                name=self.name,
                score=0.5,
                reason="No context provided for faithfulness evaluation",
            )
        
        context_str = "\n\n".join(context[:5])  # Limit context
        prompt = self.FAITHFULNESS_PROMPT.format(
            context=context_str,
            answer=answer,
        )
        
        try:
            response = await self.llm.ainvoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            score = self._parse_score(content)
            
            return MetricResult(
                name=self.name,
                score=score / 10,
                reason=content,
            )
        except Exception as e:
            logger.error(f"Faithfulness evaluation failed: {e}")
            return MetricResult(name=self.name, score=0.5, reason=str(e))
    
    def _parse_score(self, text: str) -> float:
        import re
        match = re.search(r'(\d+(?:\.\d+)?)', text)
        if match:
            return min(float(match.group(1)), 10)
        return 5.0


# =============================================================================
# CONTEXT RECALL
# =============================================================================

class ContextRecall(BaseMetric):
    """
    Evaluate if retrieved context contains the needed information.
    
    Requires ground truth answer.
    """
    
    RECALL_PROMPT = """Given the ground truth answer, evaluate what fraction of information
in the ground truth can be found in the retrieved context.

Ground Truth Answer: {ground_truth}

Retrieved Context:
{context}

Score from 0-10:
- 0 = None of the needed information is in context
- 10 = All needed information is present

Score and reason:"""
    
    def __init__(self, llm: Any):
        self.llm = llm
    
    @property
    def name(self) -> str:
        return "context_recall"
    
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> MetricResult:
        """Evaluate context recall."""
        if not context or not ground_truth:
            return MetricResult(
                name=self.name,
                score=0.5,
                reason="Context and ground truth required for recall evaluation",
            )
        
        context_str = "\n\n".join(context[:5])
        prompt = self.RECALL_PROMPT.format(
            ground_truth=ground_truth,
            context=context_str,
        )
        
        try:
            response = await self.llm.ainvoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            score = self._parse_score(content)
            
            return MetricResult(
                name=self.name,
                score=score / 10,
                reason=content,
            )
        except Exception as e:
            logger.error(f"Context recall evaluation failed: {e}")
            return MetricResult(name=self.name, score=0.5, reason=str(e))
    
    def _parse_score(self, text: str) -> float:
        import re
        match = re.search(r'(\d+(?:\.\d+)?)', text)
        if match:
            return min(float(match.group(1)), 10)
        return 5.0


# =============================================================================
# CONTEXT PRECISION
# =============================================================================

class ContextPrecision(BaseMetric):
    """
    Evaluate how much of the retrieved context is relevant.
    
    Penalizes retrieving irrelevant information.
    """
    
    PRECISION_PROMPT = """Evaluate what fraction of the retrieved context is relevant
to answering the question.

Question: {question}

Retrieved Context:
{context}

Score from 0-10:
- 0 = None of the context is relevant
- 10 = All context is highly relevant

Score and reason:"""
    
    def __init__(self, llm: Any):
        self.llm = llm
    
    @property
    def name(self) -> str:
        return "context_precision"
    
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> MetricResult:
        """Evaluate context precision."""
        if not context:
            return MetricResult(
                name=self.name,
                score=0.5,
                reason="Context required for precision evaluation",
            )
        
        context_str = "\n\n".join(context[:5])
        prompt = self.PRECISION_PROMPT.format(
            question=question,
            context=context_str,
        )
        
        try:
            response = await self.llm.ainvoke(prompt)
            content = response.content if hasattr(response, 'content') else str(response)
            
            score = self._parse_score(content)
            
            return MetricResult(
                name=self.name,
                score=score / 10,
                reason=content,
            )
        except Exception as e:
            logger.error(f"Context precision evaluation failed: {e}")
            return MetricResult(name=self.name, score=0.5, reason=str(e))
    
    def _parse_score(self, text: str) -> float:
        import re
        match = re.search(r'(\d+(?:\.\d+)?)', text)
        if match:
            return min(float(match.group(1)), 10)
        return 5.0


# =============================================================================
# EVALUATOR
# =============================================================================

class Evaluator:
    """
    Unified evaluator for running multiple metrics.
    """
    
    def __init__(
        self,
        llm: Any,
        metrics: Optional[List[str]] = None,
    ):
        """
        Initialize evaluator.
        
        Args:
            llm: LLM for evaluation
            metrics: List of metric names to use
        """
        self.llm = llm
        
        # Available metrics
        self._metrics = {
            "answer_relevancy": AnswerRelevancy(llm),
            "faithfulness": Faithfulness(llm),
            "context_recall": ContextRecall(llm),
            "context_precision": ContextPrecision(llm),
        }
        
        # Select metrics to use
        if metrics:
            self.active_metrics = [self._metrics[m] for m in metrics if m in self._metrics]
        else:
            self.active_metrics = list(self._metrics.values())
    
    async def evaluate(
        self,
        question: str,
        answer: str,
        context: Optional[List[str]] = None,
        ground_truth: Optional[str] = None,
    ) -> Dict[str, MetricResult]:
        """
        Run all active metrics.
        
        Args:
            question: User question
            answer: Generated answer
            context: Retrieved context
            ground_truth: Expected answer
            
        Returns:
            Dict mapping metric name to result
        """
        results = {}
        
        for metric in self.active_metrics:
            result = await metric.evaluate(
                question=question,
                answer=answer,
                context=context,
                ground_truth=ground_truth,
            )
            results[metric.name] = result
        
        return results
    
    async def evaluate_batch(
        self,
        samples: List[Dict[str, Any]],
    ) -> List[Dict[str, MetricResult]]:
        """
        Evaluate multiple samples.
        
        Args:
            samples: List of dicts with question, answer, context, ground_truth
            
        Returns:
            List of evaluation results
        """
        results = []
        
        for sample in samples:
            result = await self.evaluate(
                question=sample.get("question", ""),
                answer=sample.get("answer", ""),
                context=sample.get("context"),
                ground_truth=sample.get("ground_truth"),
            )
            results.append(result)
        
        return results
    
    def aggregate_scores(
        self,
        results: List[Dict[str, MetricResult]],
    ) -> Dict[str, float]:
        """
        Aggregate scores across multiple samples.
        
        Args:
            results: List of evaluation results
            
        Returns:
            Dict with average score per metric
        """
        if not results:
            return {}
        
        aggregated = {}
        counts = {}
        
        for result in results:
            for metric_name, metric_result in result.items():
                if metric_name not in aggregated:
                    aggregated[metric_name] = 0.0
                    counts[metric_name] = 0
                
                aggregated[metric_name] += metric_result.score
                counts[metric_name] += 1
        
        return {
            name: score / counts[name]
            for name, score in aggregated.items()
        }


# =============================================================================
# CONVENIENCE FUNCTION
# =============================================================================

async def evaluate_rag(
    llm: Any,
    question: str,
    answer: str,
    context: List[str],
    ground_truth: Optional[str] = None,
) -> Dict[str, float]:
    """
    Quick RAG evaluation.
    
    Args:
        llm: LLM for evaluation
        question: User question
        answer: Generated answer
        context: Retrieved context
        ground_truth: Expected answer
        
    Returns:
        Dict with metric scores
    """
    evaluator = Evaluator(llm)
    results = await evaluator.evaluate(
        question=question,
        answer=answer,
        context=context,
        ground_truth=ground_truth,
    )
    
    return {name: result.score for name, result in results.items()}

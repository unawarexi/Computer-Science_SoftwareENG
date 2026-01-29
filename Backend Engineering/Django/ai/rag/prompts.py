"""
RAG Prompts
===========
Prompt templates for Retrieval-Augmented Generation.

This module provides:
- RAG prompt templates
- Context formatting
- Citation handling
- Multi-document synthesis prompts
"""

import logging
from typing import Any, Dict, List, Optional
from dataclasses import dataclass

from langchain_core.documents import Document
from langchain_core.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    PromptTemplate,
)

logger = logging.getLogger("ai.rag.prompts")


# =============================================================================
# RAG PROMPT TEMPLATES
# =============================================================================

# Basic RAG prompt
RAG_BASIC = """Answer the question based only on the following context:

{context}

Question: {question}

Answer:"""

# RAG with citations
RAG_CITATIONS = """Answer the question based on the context below. Include citations 
in the format [1], [2], etc. for each piece of information used.

Context:
{context}

Question: {question}

Provide a comprehensive answer with citations:"""

# RAG with verification
RAG_VERIFIED = """Based on the provided context, answer the question. 
If the context doesn't contain enough information, say "I cannot find sufficient 
information to answer this question."

Context:
{context}

Question: {question}

Answer (only from context):"""

# Multi-document synthesis
RAG_SYNTHESIS = """Synthesize information from multiple sources to answer the question.
Note any conflicts or differences between sources.

Sources:
{context}

Question: {question}

Synthesized answer:"""

# Conversational RAG
RAG_CONVERSATIONAL = """You are a helpful assistant. Use the following context 
and chat history to answer the question.

Context:
{context}

Chat History:
{chat_history}

Question: {question}

Answer:"""


# =============================================================================
# PROMPT TEMPLATES
# =============================================================================

@dataclass
class RAGPromptTemplate:
    """RAG prompt template with formatting utilities."""
    template: str
    name: str
    description: str
    required_vars: List[str]
    
    def format(self, **kwargs) -> str:
        """Format prompt with variables."""
        return self.template.format(**kwargs)
    
    def to_langchain(self) -> PromptTemplate:
        """Convert to LangChain prompt template."""
        return PromptTemplate(
            template=self.template,
            input_variables=self.required_vars,
        )


# Pre-built templates
TEMPLATES = {
    "basic": RAGPromptTemplate(
        template=RAG_BASIC,
        name="basic",
        description="Simple RAG prompt",
        required_vars=["context", "question"],
    ),
    "citations": RAGPromptTemplate(
        template=RAG_CITATIONS,
        name="citations",
        description="RAG with citation requirements",
        required_vars=["context", "question"],
    ),
    "verified": RAGPromptTemplate(
        template=RAG_VERIFIED,
        name="verified",
        description="RAG with verification and uncertainty handling",
        required_vars=["context", "question"],
    ),
    "synthesis": RAGPromptTemplate(
        template=RAG_SYNTHESIS,
        name="synthesis",
        description="Multi-document synthesis",
        required_vars=["context", "question"],
    ),
    "conversational": RAGPromptTemplate(
        template=RAG_CONVERSATIONAL,
        name="conversational",
        description="Conversational RAG with chat history",
        required_vars=["context", "chat_history", "question"],
    ),
}


def get_rag_prompt(name: str = "basic") -> RAGPromptTemplate:
    """Get RAG prompt template by name."""
    if name not in TEMPLATES:
        available = list(TEMPLATES.keys())
        raise ValueError(f"Unknown template '{name}'. Available: {available}")
    return TEMPLATES[name]


# =============================================================================
# CONTEXT FORMATTERS
# =============================================================================

class ContextFormatter:
    """Format retrieved documents into context string."""
    
    @staticmethod
    def format_basic(documents: List[Document]) -> str:
        """Basic formatting with document separation."""
        return "\n\n---\n\n".join(
            doc.page_content for doc in documents
        )
    
    @staticmethod
    def format_numbered(documents: List[Document]) -> str:
        """Format with source numbers for citations."""
        parts = []
        for i, doc in enumerate(documents, 1):
            source = doc.metadata.get("source", "Unknown")
            parts.append(f"[{i}] Source: {source}\n{doc.page_content}")
        return "\n\n".join(parts)
    
    @staticmethod
    def format_with_metadata(documents: List[Document]) -> str:
        """Format with full metadata."""
        parts = []
        for i, doc in enumerate(documents, 1):
            metadata_str = ", ".join(
                f"{k}: {v}" for k, v in doc.metadata.items()
                if k not in ("embedding", "chunk_id")
            )
            parts.append(
                f"Document {i} ({metadata_str}):\n{doc.page_content}"
            )
        return "\n\n---\n\n".join(parts)
    
    @staticmethod
    def format_xml(documents: List[Document]) -> str:
        """Format in XML style for Claude."""
        parts = []
        for i, doc in enumerate(documents, 1):
            source = doc.metadata.get("source", "unknown")
            parts.append(
                f'<document id="{i}" source="{source}">\n'
                f'{doc.page_content}\n'
                f'</document>'
            )
        return "\n\n".join(parts)


# =============================================================================
# RAG CHAIN BUILDER
# =============================================================================

class RAGChainBuilder:
    """Build complete RAG chains with LangChain."""
    
    def __init__(
        self,
        llm: Any,
        retriever: Any,
        prompt_template: str = "basic",
        context_formatter: str = "numbered",
    ):
        """
        Initialize RAG chain builder.
        
        Args:
            llm: LangChain LLM
            retriever: LangChain retriever
            prompt_template: Prompt template name
            context_formatter: Context formatting method
        """
        self.llm = llm
        self.retriever = retriever
        self.prompt_template = get_rag_prompt(prompt_template)
        
        # Get formatter
        formatter_map = {
            "basic": ContextFormatter.format_basic,
            "numbered": ContextFormatter.format_numbered,
            "metadata": ContextFormatter.format_with_metadata,
            "xml": ContextFormatter.format_xml,
        }
        self.format_context = formatter_map.get(
            context_formatter, ContextFormatter.format_numbered
        )
    
    def build_chain(self):
        """Build the RAG chain."""
        from langchain_core.runnables import RunnablePassthrough
        from langchain_core.output_parsers import StrOutputParser
        
        prompt = self.prompt_template.to_langchain()
        
        def format_docs(docs):
            return self.format_context(docs)
        
        chain = (
            {
                "context": self.retriever | format_docs,
                "question": RunnablePassthrough(),
            }
            | prompt
            | self.llm
            | StrOutputParser()
        )
        
        return chain
    
    def build_conversational_chain(self):
        """Build conversational RAG chain with memory."""
        from langchain_core.runnables import RunnablePassthrough
        from langchain_core.output_parsers import StrOutputParser
        
        prompt = ChatPromptTemplate.from_messages([
            ("system", "You are a helpful assistant. Use the following context "
                       "to answer questions.\n\nContext:\n{context}"),
            MessagesPlaceholder(variable_name="chat_history"),
            ("human", "{question}"),
        ])
        
        def format_docs(docs):
            return self.format_context(docs)
        
        chain = (
            {
                "context": lambda x: format_docs(
                    self.retriever.get_relevant_documents(x["question"])
                ),
                "chat_history": lambda x: x.get("chat_history", []),
                "question": lambda x: x["question"],
            }
            | prompt
            | self.llm
            | StrOutputParser()
        )
        
        return chain


# =============================================================================
# SPECIALIZED RAG PROMPTS
# =============================================================================

class SpecializedPrompts:
    """Specialized prompts for specific use cases."""
    
    # Code assistance
    CODE_RAG = """You are a coding assistant. Use the following documentation 
and code examples to answer the programming question.

Documentation and Examples:
{context}

Programming Question: {question}

Provide a detailed answer with code examples where appropriate:"""
    
    # Customer support
    SUPPORT_RAG = """You are a customer support assistant. Use the following 
knowledge base articles to help the customer.

Knowledge Base:
{context}

Customer Question: {question}

Provide a helpful, friendly response:"""
    
    # Legal/compliance
    LEGAL_RAG = """Based on the following policy documents, answer the question.
Be precise and cite specific sections. If the documents don't address the 
question, clearly state this.

Policy Documents:
{context}

Question: {question}

Response (with citations):"""
    
    # Research
    RESEARCH_RAG = """Analyze the following research materials to answer the question.
Identify key findings, note any contradictions, and provide a balanced summary.

Research Materials:
{context}

Research Question: {question}

Analysis:"""
    
    @classmethod
    def get_prompt(cls, use_case: str) -> str:
        """Get specialized prompt by use case."""
        prompts = {
            "code": cls.CODE_RAG,
            "support": cls.SUPPORT_RAG,
            "legal": cls.LEGAL_RAG,
            "research": cls.RESEARCH_RAG,
        }
        return prompts.get(use_case, RAG_BASIC)


# =============================================================================
# QUERY TRANSFORMATION
# =============================================================================

class QueryTransformer:
    """Transform queries for better retrieval."""
    
    HYPOTHETICAL_ANSWER_PROMPT = """Given the question, write a hypothetical 
answer that would be found in a relevant document. This will be used to 
find similar documents.

Question: {question}

Hypothetical document excerpt:"""
    
    STEP_BACK_PROMPT = """Given the specific question, generate a more general 
question that would help gather relevant background information.

Specific question: {question}

General background question:"""
    
    def __init__(self, llm: Any):
        """Initialize query transformer."""
        self.llm = llm
    
    def hypothetical_document(self, question: str) -> str:
        """Generate hypothetical document for HyDE retrieval."""
        prompt = self.HYPOTHETICAL_ANSWER_PROMPT.format(question=question)
        response = self.llm.invoke(prompt)
        return response.content if hasattr(response, 'content') else str(response)
    
    def step_back(self, question: str) -> str:
        """Generate step-back question for broader retrieval."""
        prompt = self.STEP_BACK_PROMPT.format(question=question)
        response = self.llm.invoke(prompt)
        return response.content if hasattr(response, 'content') else str(response)
    
    def decompose(self, question: str) -> List[str]:
        """Decompose complex question into sub-questions."""
        prompt = f"""Break down this complex question into simpler sub-questions:

Question: {question}

Sub-questions (one per line):"""
        
        response = self.llm.invoke(prompt)
        content = response.content if hasattr(response, 'content') else str(response)
        
        # Parse sub-questions
        sub_questions = []
        for line in content.strip().split("\n"):
            line = line.strip().lstrip("0123456789.-*) ")
            if line:
                sub_questions.append(line)
        
        return sub_questions

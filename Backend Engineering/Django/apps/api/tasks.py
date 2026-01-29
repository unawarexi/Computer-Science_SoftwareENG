"""
Celery Tasks
============
Background tasks for AI agent operations.
"""

import logging
from celery import shared_task
from django.conf import settings

logger = logging.getLogger("apps.api.tasks")


# =============================================================================
# DOCUMENT PROCESSING
# =============================================================================

@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={'max_retries': 3},
)
def process_document(self, document_id: str):
    """
    Process document for RAG ingestion.
    
    - Load document content
    - Split into chunks
    - Generate embeddings
    - Store in vector database
    """
    from apps.core.models import Document, DocumentChunk
    
    try:
        document = Document.objects.get(id=document_id)
        
        if document.is_processed:
            logger.info(f"Document {document_id} already processed")
            return
        
        logger.info(f"Processing document: {document.title}")
        
        # Import AI components
        from ai.rag import DocumentProcessor, ChunkConfig
        from ai.models import get_default_embeddings
        
        # Configure chunking
        config = ChunkConfig(
            chunk_size=1000,
            chunk_overlap=200,
        )
        
        processor = DocumentProcessor(
            chunk_config=config,
            embeddings_model=get_default_embeddings(),
        )
        
        # Process document
        processed = processor.process_text(
            text=document.content,
            source=document.source,
            metadata={
                'document_id': str(document.id),
                'title': document.title,
            },
        )
        
        # Create chunk records
        for i, chunk in enumerate(processed.chunks):
            DocumentChunk.objects.create(
                document=document,
                content=chunk.page_content,
                chunk_index=i,
                metadata=chunk.metadata,
            )
        
        # Update document status
        document.is_processed = True
        document.chunk_count = len(processed.chunks)
        document.save(update_fields=['is_processed', 'chunk_count'])
        
        logger.info(f"Document {document_id} processed: {document.chunk_count} chunks")
        
        # Trigger embedding task
        embed_document_chunks.delay(document_id)
        
    except Document.DoesNotExist:
        logger.error(f"Document {document_id} not found")
        raise
    except Exception as e:
        logger.error(f"Document processing failed: {e}")
        raise


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={'max_retries': 3},
)
def embed_document_chunks(self, document_id: str):
    """
    Generate embeddings for document chunks and store in vector DB.
    """
    from apps.core.models import Document, DocumentChunk
    
    try:
        document = Document.objects.get(id=document_id)
        chunks = document.chunks.all()
        
        if not chunks:
            logger.info(f"No chunks for document {document_id}")
            return
        
        logger.info(f"Embedding {chunks.count()} chunks for document {document_id}")
        
        from ai.models import get_default_embeddings
        
        embeddings_model = get_default_embeddings()
        
        # Get chunk contents
        texts = [chunk.content for chunk in chunks]
        
        # Generate embeddings (sync for simplicity)
        import asyncio
        
        async def embed():
            return await embeddings_model.aembed_documents(texts)
        
        vectors = asyncio.get_event_loop().run_until_complete(embed())
        
        # Store in vector database
        # This is a placeholder - implement based on your vector store
        # For example with ChromaDB:
        # 
        # import chromadb
        # client = chromadb.HttpClient(host='chromadb', port=8000)
        # collection = client.get_or_create_collection('documents')
        # collection.add(
        #     ids=[str(c.id) for c in chunks],
        #     embeddings=vectors,
        #     documents=texts,
        #     metadatas=[{'document_id': document_id, 'chunk_index': c.chunk_index} for c in chunks],
        # )
        
        logger.info(f"Embedded {len(vectors)} chunks for document {document_id}")
        
    except Document.DoesNotExist:
        logger.error(f"Document {document_id} not found")
        raise
    except Exception as e:
        logger.error(f"Embedding failed: {e}")
        raise


# =============================================================================
# AGENT TASK EXECUTION
# =============================================================================

@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={'max_retries': 2},
)
def execute_agent_task(self, task_id: str):
    """
    Execute an agent task.
    """
    from apps.core.models import AgentTask
    
    try:
        task = AgentTask.objects.get(id=task_id)
        
        if task.status != 'pending':
            logger.info(f"Task {task_id} is not pending, skipping")
            return
        
        # Start task
        task.start()
        
        logger.info(f"Executing task: {task.task_type}")
        
        from ai.agents import MainAgent
        
        # Create agent
        agent = MainAgent()
        
        # Run task based on type
        if task.task_type == 'chat':
            result = agent.run_sync(
                task.input_data.get('message', ''),
                history=task.input_data.get('history', []),
            )
        elif task.task_type == 'research':
            result = agent.run_sync(
                f"Research the following topic and provide a comprehensive summary: {task.description}"
            )
        elif task.task_type == 'code':
            result = agent.run_sync(
                f"Write code for: {task.description}\n\nRequirements: {task.input_data}"
            )
        else:
            result = agent.run_sync(task.description)
        
        # Complete task
        task.complete(output_data={
            'response': result.get('response', ''),
            'tool_calls': result.get('tool_calls', []),
        })
        
        # Update stats
        task.tools_used = result.get('tools_used', [])
        task.total_tokens = result.get('input_tokens', 0) + result.get('output_tokens', 0)
        task.save(update_fields=['tools_used', 'total_tokens'])
        
        logger.info(f"Task {task_id} completed")
        
    except AgentTask.DoesNotExist:
        logger.error(f"Task {task_id} not found")
        raise
    except Exception as e:
        logger.error(f"Task execution failed: {e}")
        
        try:
            task = AgentTask.objects.get(id=task_id)
            task.fail(str(e))
        except:
            pass
        
        raise


# =============================================================================
# CONVERSATION TASKS
# =============================================================================

@shared_task
def summarize_conversation(conversation_id: str):
    """
    Generate summary for a conversation.
    """
    from apps.core.models import Conversation
    
    try:
        conversation = Conversation.objects.get(id=conversation_id)
        messages = conversation.messages.all()[:50]
        
        if not messages:
            return
        
        from ai.models import get_llm
        
        llm = get_llm('gpt-4o-mini')
        
        # Format conversation
        formatted = "\n".join([
            f"{m.role}: {m.content[:500]}"
            for m in messages
        ])
        
        prompt = f"""Summarize this conversation in 2-3 sentences:

{formatted}

Summary:"""
        
        import asyncio
        
        async def summarize():
            response = await llm.ainvoke(prompt)
            return response.content
        
        summary = asyncio.get_event_loop().run_until_complete(summarize())
        
        conversation.summary = summary
        conversation.save(update_fields=['summary'])
        
        logger.info(f"Summarized conversation {conversation_id}")
        
    except Conversation.DoesNotExist:
        logger.error(f"Conversation {conversation_id} not found")
    except Exception as e:
        logger.error(f"Summarization failed: {e}")


# =============================================================================
# MAINTENANCE TASKS
# =============================================================================

@shared_task
def reset_monthly_token_usage():
    """
    Reset monthly token usage for all users.
    Run on the first of each month.
    """
    from django.contrib.auth import get_user_model
    
    User = get_user_model()
    count = User.objects.update(tokens_used_this_month=0)
    logger.info(f"Reset monthly token usage for {count} users")


@shared_task
def cleanup_old_tasks():
    """
    Clean up old completed tasks.
    """
    from datetime import timedelta
    from django.utils import timezone
    from apps.core.models import AgentTask
    
    cutoff = timezone.now() - timedelta(days=30)
    count, _ = AgentTask.objects.filter(
        status__in=['completed', 'cancelled'],
        completed_at__lt=cutoff,
    ).delete()
    
    logger.info(f"Cleaned up {count} old tasks")


@shared_task
def update_conversation_stats():
    """
    Update conversation statistics.
    """
    from apps.core.models import Conversation
    from django.db.models import Count, Sum
    
    conversations = Conversation.objects.filter(is_deleted=False)
    
    for conv in conversations:
        stats = conv.messages.aggregate(
            count=Count('id'),
            tokens=Sum('input_tokens') + Sum('output_tokens'),
        )
        
        conv.message_count = stats['count'] or 0
        conv.total_tokens = stats['tokens'] or 0
        conv.save(update_fields=['message_count', 'total_tokens'])
    
    logger.info(f"Updated stats for {conversations.count()} conversations")

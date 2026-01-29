"""
API Views
=========
REST API endpoints for AI agent interaction.
"""

import logging
from django.http import StreamingHttpResponse
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser

from apps.core.models import Conversation, Message, Document, AgentTask
from apps.core.serializers import (
    ConversationSerializer,
    ConversationListSerializer,
    MessageSerializer,
    DocumentSerializer,
    AgentTaskSerializer,
    ChatInputSerializer,
    ChatOutputSerializer,
    RAGQuerySerializer,
    DocumentUploadSerializer,
)

logger = logging.getLogger("apps.api.views")


# =============================================================================
# CONVERSATION VIEWS
# =============================================================================

class ConversationViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing conversations.
    """
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Conversation.objects.filter(
            user=self.request.user,
            is_deleted=False,
        )
    
    def get_serializer_class(self):
        if self.action == 'list':
            return ConversationListSerializer
        return ConversationSerializer
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def chat(self, request, pk=None):
        """
        Send a message to the conversation and get AI response.
        """
        conversation = self.get_object()
        
        serializer = ChatInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        # Check token limit
        if request.user.has_token_limit:
            return Response(
                {'error': 'Monthly token limit reached'},
                status=status.HTTP_402_PAYMENT_REQUIRED,
            )
        
        # Get chat parameters
        message_content = serializer.validated_data['message']
        model_name = serializer.validated_data.get('model_name', conversation.model_name)
        temperature = serializer.validated_data.get('temperature', conversation.temperature)
        stream = serializer.validated_data.get('stream', False)
        
        # Create user message
        user_message = Message.objects.create(
            conversation=conversation,
            role='user',
            content=message_content,
        )
        
        if stream:
            # Return streaming response
            return self._stream_response(
                conversation, message_content, model_name, temperature
            )
        
        # Get AI response
        try:
            from ai.agents import MainAgent
            
            agent = MainAgent(
                model_name=model_name,
                temperature=temperature,
            )
            
            # Get conversation history
            history = list(conversation.messages.values('role', 'content')[:20])
            
            # Run agent
            result = agent.run_sync(message_content, history=history)
            
            # Create assistant message
            assistant_message = Message.objects.create(
                conversation=conversation,
                role='assistant',
                content=result['response'],
                input_tokens=result.get('input_tokens', 0),
                output_tokens=result.get('output_tokens', 0),
                metadata=result.get('metadata', {}),
            )
            
            # Update conversation stats
            conversation.message_count = conversation.messages.count()
            conversation.total_tokens += result.get('input_tokens', 0) + result.get('output_tokens', 0)
            conversation.save(update_fields=['message_count', 'total_tokens'])
            
            # Update user token usage
            request.user.add_token_usage(
                result.get('input_tokens', 0) + result.get('output_tokens', 0)
            )
            
            output_serializer = ChatOutputSerializer({
                'conversation_id': conversation.id,
                'message_id': assistant_message.id,
                'content': result['response'],
                'role': 'assistant',
                'tool_calls': result.get('tool_calls', []),
                'tokens': {
                    'input': result.get('input_tokens', 0),
                    'output': result.get('output_tokens', 0),
                },
            })
            
            return Response(output_serializer.data)
            
        except Exception as e:
            logger.error(f"Chat error: {e}")
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
    
    def _stream_response(self, conversation, message, model_name, temperature):
        """Generate streaming response."""
        def generate():
            from ai.agents import MainAgent
            
            agent = MainAgent(
                model_name=model_name,
                temperature=temperature,
            )
            
            history = list(conversation.messages.values('role', 'content')[:20])
            
            for chunk in agent.stream(message, history=history):
                yield f"data: {chunk}\n\n"
            
            yield "data: [DONE]\n\n"
        
        return StreamingHttpResponse(
            generate(),
            content_type='text/event-stream',
        )
    
    @action(detail=True, methods=['post'])
    def clear(self, request, pk=None):
        """Clear conversation history."""
        conversation = self.get_object()
        conversation.messages.all().delete()
        conversation.message_count = 0
        conversation.summary = ''
        conversation.save(update_fields=['message_count', 'summary'])
        
        return Response({'status': 'cleared'})


# =============================================================================
# DOCUMENT VIEWS
# =============================================================================

class DocumentViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing documents in RAG system.
    """
    serializer_class = DocumentSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def get_queryset(self):
        return Document.objects.filter(
            user=self.request.user,
            is_deleted=False,
        )
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def upload(self, request):
        """Upload and process a document."""
        serializer = DocumentUploadSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        file = serializer.validated_data['file']
        title = serializer.validated_data.get('title', file.name)
        doc_type = serializer.validated_data.get('document_type', 'text')
        
        try:
            # Read file content
            content = file.read().decode('utf-8')
            
            # Create document
            document = Document.objects.create(
                user=request.user,
                title=title,
                content=content,
                source=file.name,
                document_type=doc_type,
                metadata=serializer.validated_data.get('metadata', {}),
            )
            
            # Queue for processing
            from apps.api.tasks import process_document
            process_document.delay(str(document.id))
            
            return Response(
                DocumentSerializer(document).data,
                status=status.HTTP_201_CREATED,
            )
            
        except Exception as e:
            logger.error(f"Document upload error: {e}")
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )
    
    @action(detail=True, methods=['post'])
    def process(self, request, pk=None):
        """Manually trigger document processing."""
        document = self.get_object()
        
        from apps.api.tasks import process_document
        process_document.delay(str(document.id))
        
        return Response({'status': 'processing'})
    
    @action(detail=False, methods=['post'])
    def query(self, request):
        """Query documents using RAG."""
        serializer = RAGQuerySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        query = serializer.validated_data['query']
        document_ids = serializer.validated_data.get('document_ids')
        top_k = serializer.validated_data.get('top_k', 5)
        include_sources = serializer.validated_data.get('include_sources', True)
        
        try:
            from ai.rag import VectorRetriever
            from ai.models import get_default_llm, get_default_embeddings
            
            # Get retriever
            # This would typically use your vector store
            # Simplified example here
            
            # For now, return a placeholder
            return Response({
                'query': query,
                'answer': 'RAG answer would go here',
                'sources': [] if not include_sources else [
                    {'document_id': 'xxx', 'content': 'source content', 'score': 0.9}
                ],
            })
            
        except Exception as e:
            logger.error(f"RAG query error: {e}")
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


# =============================================================================
# AGENT TASK VIEWS
# =============================================================================

class AgentTaskViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing agent tasks.
    """
    serializer_class = AgentTaskSerializer
    permission_classes = [IsAuthenticated]
    http_method_names = ['get', 'post', 'delete']
    
    def get_queryset(self):
        return AgentTask.objects.filter(
            user=self.request.user,
            is_deleted=False,
        )
    
    def perform_create(self, serializer):
        task = serializer.save(user=self.request.user)
        
        # Queue task for execution
        from apps.api.tasks import execute_agent_task
        execute_agent_task.delay(str(task.id))
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel a pending task."""
        task = self.get_object()
        
        if task.status in ['pending', 'running']:
            task.status = 'cancelled'
            task.save(update_fields=['status'])
            return Response({'status': 'cancelled'})
        
        return Response(
            {'error': 'Task cannot be cancelled'},
            status=status.HTTP_400_BAD_REQUEST,
        )
    
    @action(detail=True, methods=['post'])
    def retry(self, request, pk=None):
        """Retry a failed task."""
        task = self.get_object()
        
        if task.status == 'failed':
            task.status = 'pending'
            task.error_message = ''
            task.save(update_fields=['status', 'error_message'])
            
            from apps.api.tasks import execute_agent_task
            execute_agent_task.delay(str(task.id))
            
            return Response({'status': 'retrying'})
        
        return Response(
            {'error': 'Task cannot be retried'},
            status=status.HTTP_400_BAD_REQUEST,
        )

"""
Core Serializers
================
DRF serializers for core models.
"""

from rest_framework import serializers
from apps.core.models import (
    Conversation,
    Message,
    Document,
    DocumentChunk,
    AgentTask,
)


class MessageSerializer(serializers.ModelSerializer):
    """Serializer for Message model."""
    
    class Meta:
        model = Message
        fields = [
            'id', 'role', 'content', 'tool_call_id', 'tool_name',
            'input_tokens', 'output_tokens', 'metadata', 'created_at',
        ]
        read_only_fields = ['id', 'created_at']


class ConversationSerializer(serializers.ModelSerializer):
    """Serializer for Conversation model."""
    
    messages = MessageSerializer(many=True, read_only=True)
    
    class Meta:
        model = Conversation
        fields = [
            'id', 'title', 'summary', 'metadata', 'agent_type',
            'model_name', 'temperature', 'message_count', 'total_tokens',
            'messages', 'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'message_count', 'total_tokens', 'created_at', 'updated_at']


class ConversationListSerializer(serializers.ModelSerializer):
    """Lightweight serializer for conversation list."""
    
    class Meta:
        model = Conversation
        fields = [
            'id', 'title', 'summary', 'agent_type', 'message_count',
            'created_at', 'updated_at',
        ]


class DocumentSerializer(serializers.ModelSerializer):
    """Serializer for Document model."""
    
    class Meta:
        model = Document
        fields = [
            'id', 'title', 'content', 'source', 'document_type',
            'is_processed', 'chunk_count', 'metadata', 'created_at',
        ]
        read_only_fields = ['id', 'is_processed', 'chunk_count', 'created_at']


class DocumentChunkSerializer(serializers.ModelSerializer):
    """Serializer for DocumentChunk model."""
    
    class Meta:
        model = DocumentChunk
        fields = [
            'id', 'document', 'content', 'chunk_index',
            'vector_id', 'metadata',
        ]
        read_only_fields = ['id', 'vector_id']


class AgentTaskSerializer(serializers.ModelSerializer):
    """Serializer for AgentTask model."""
    
    duration_seconds = serializers.SerializerMethodField()
    
    class Meta:
        model = AgentTask
        fields = [
            'id', 'conversation', 'task_type', 'description',
            'input_data', 'output_data', 'status', 'error_message',
            'started_at', 'completed_at', 'duration_seconds',
            'tools_used', 'total_tokens', 'cost', 'created_at',
        ]
        read_only_fields = [
            'id', 'output_data', 'status', 'error_message',
            'started_at', 'completed_at', 'tools_used',
            'total_tokens', 'cost', 'created_at',
        ]
    
    def get_duration_seconds(self, obj):
        """Calculate task duration."""
        if obj.started_at and obj.completed_at:
            return (obj.completed_at - obj.started_at).total_seconds()
        return None


class ChatInputSerializer(serializers.Serializer):
    """Serializer for chat input."""
    
    message = serializers.CharField(max_length=10000)
    conversation_id = serializers.UUIDField(required=False, allow_null=True)
    model_name = serializers.CharField(max_length=100, required=False, default='gpt-4o-mini')
    temperature = serializers.FloatField(min_value=0, max_value=2, required=False, default=0.7)
    stream = serializers.BooleanField(required=False, default=False)


class ChatOutputSerializer(serializers.Serializer):
    """Serializer for chat output."""
    
    conversation_id = serializers.UUIDField()
    message_id = serializers.UUIDField()
    content = serializers.CharField()
    role = serializers.CharField()
    tool_calls = serializers.ListField(required=False)
    tokens = serializers.DictField(required=False)


class RAGQuerySerializer(serializers.Serializer):
    """Serializer for RAG query input."""
    
    query = serializers.CharField(max_length=5000)
    document_ids = serializers.ListField(
        child=serializers.UUIDField(),
        required=False,
    )
    top_k = serializers.IntegerField(min_value=1, max_value=20, required=False, default=5)
    include_sources = serializers.BooleanField(required=False, default=True)


class DocumentUploadSerializer(serializers.Serializer):
    """Serializer for document upload."""
    
    file = serializers.FileField()
    title = serializers.CharField(max_length=255, required=False)
    document_type = serializers.ChoiceField(
        choices=['text', 'pdf', 'docx', 'markdown', 'csv'],
        required=False,
        default='text',
    )
    metadata = serializers.JSONField(required=False, default=dict)

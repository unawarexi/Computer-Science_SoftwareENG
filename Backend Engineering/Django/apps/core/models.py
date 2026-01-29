"""
Core Models
===========
Base models and mixins used across the application.
"""

import uuid
from django.db import models
from django.utils import timezone


# =============================================================================
# BASE MODELS
# =============================================================================

class TimeStampedModel(models.Model):
    """
    Abstract base model with created/updated timestamps.
    """
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        abstract = True
        ordering = ['-created_at']


class UUIDModel(models.Model):
    """
    Abstract base model with UUID primary key.
    """
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    
    class Meta:
        abstract = True


class SoftDeleteModel(models.Model):
    """
    Abstract model for soft delete functionality.
    """
    is_deleted = models.BooleanField(default=False, db_index=True)
    deleted_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        abstract = True
    
    def delete(self, using=None, keep_parents=False):
        """Soft delete the object."""
        self.is_deleted = True
        self.deleted_at = timezone.now()
        self.save(update_fields=['is_deleted', 'deleted_at'])
    
    def hard_delete(self, using=None, keep_parents=False):
        """Permanently delete the object."""
        super().delete(using=using, keep_parents=keep_parents)
    
    def restore(self):
        """Restore soft-deleted object."""
        self.is_deleted = False
        self.deleted_at = None
        self.save(update_fields=['is_deleted', 'deleted_at'])


class BaseModel(UUIDModel, TimeStampedModel, SoftDeleteModel):
    """
    Combined base model with UUID, timestamps, and soft delete.
    """
    class Meta:
        abstract = True


# =============================================================================
# AI-RELATED MODELS
# =============================================================================

class Conversation(BaseModel):
    """
    Store conversation history for AI agents.
    """
    user = models.ForeignKey(
        'users.User',
        on_delete=models.CASCADE,
        related_name='conversations',
    )
    title = models.CharField(max_length=255, blank=True)
    summary = models.TextField(blank=True)
    metadata = models.JSONField(default=dict, blank=True)
    
    # Agent configuration
    agent_type = models.CharField(max_length=50, default='default')
    model_name = models.CharField(max_length=100, default='gpt-4o-mini')
    temperature = models.FloatField(default=0.7)
    
    # Stats
    message_count = models.PositiveIntegerField(default=0)
    total_tokens = models.PositiveIntegerField(default=0)
    
    class Meta:
        ordering = ['-updated_at']
        indexes = [
            models.Index(fields=['user', '-updated_at']),
        ]
    
    def __str__(self):
        return f"{self.user} - {self.title or 'Untitled'}"


class Message(BaseModel):
    """
    Individual message in a conversation.
    """
    ROLE_CHOICES = [
        ('system', 'System'),
        ('user', 'User'),
        ('assistant', 'Assistant'),
        ('tool', 'Tool'),
    ]
    
    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='messages',
    )
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    content = models.TextField()
    
    # For tool messages
    tool_call_id = models.CharField(max_length=100, blank=True)
    tool_name = models.CharField(max_length=100, blank=True)
    
    # Token tracking
    input_tokens = models.PositiveIntegerField(default=0)
    output_tokens = models.PositiveIntegerField(default=0)
    
    # Metadata
    metadata = models.JSONField(default=dict, blank=True)
    
    class Meta:
        ordering = ['created_at']
        indexes = [
            models.Index(fields=['conversation', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.role}: {self.content[:50]}"


class Document(BaseModel):
    """
    Document for RAG system.
    """
    user = models.ForeignKey(
        'users.User',
        on_delete=models.CASCADE,
        related_name='documents',
        null=True,
        blank=True,
    )
    title = models.CharField(max_length=255)
    content = models.TextField()
    source = models.CharField(max_length=500, blank=True)
    document_type = models.CharField(max_length=50, default='text')
    
    # Processing status
    is_processed = models.BooleanField(default=False)
    chunk_count = models.PositiveIntegerField(default=0)
    
    # Metadata
    metadata = models.JSONField(default=dict, blank=True)
    
    class Meta:
        indexes = [
            models.Index(fields=['user', 'is_processed']),
        ]
    
    def __str__(self):
        return self.title


class DocumentChunk(BaseModel):
    """
    Chunk of a document for vector storage.
    """
    document = models.ForeignKey(
        Document,
        on_delete=models.CASCADE,
        related_name='chunks',
    )
    content = models.TextField()
    chunk_index = models.PositiveIntegerField()
    
    # Vector storage reference
    vector_id = models.CharField(max_length=100, blank=True)
    
    # Metadata
    metadata = models.JSONField(default=dict, blank=True)
    
    class Meta:
        ordering = ['document', 'chunk_index']
        unique_together = ['document', 'chunk_index']
    
    def __str__(self):
        return f"{self.document.title} - Chunk {self.chunk_index}"


class AgentTask(BaseModel):
    """
    Track agent task execution.
    """
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('running', 'Running'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
        ('cancelled', 'Cancelled'),
    ]
    
    user = models.ForeignKey(
        'users.User',
        on_delete=models.CASCADE,
        related_name='agent_tasks',
    )
    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='tasks',
        null=True,
        blank=True,
    )
    
    # Task details
    task_type = models.CharField(max_length=50)
    description = models.TextField()
    input_data = models.JSONField(default=dict)
    output_data = models.JSONField(default=dict, blank=True)
    
    # Status
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    error_message = models.TextField(blank=True)
    
    # Timing
    started_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    # Resources
    tools_used = models.JSONField(default=list, blank=True)
    total_tokens = models.PositiveIntegerField(default=0)
    cost = models.DecimalField(max_digits=10, decimal_places=6, default=0)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', 'status']),
            models.Index(fields=['status', '-created_at']),
        ]
    
    def __str__(self):
        return f"{self.task_type} - {self.status}"
    
    def start(self):
        """Mark task as started."""
        self.status = 'running'
        self.started_at = timezone.now()
        self.save(update_fields=['status', 'started_at'])
    
    def complete(self, output_data=None):
        """Mark task as completed."""
        self.status = 'completed'
        self.completed_at = timezone.now()
        if output_data:
            self.output_data = output_data
        self.save(update_fields=['status', 'completed_at', 'output_data'])
    
    def fail(self, error_message):
        """Mark task as failed."""
        self.status = 'failed'
        self.error_message = error_message
        self.completed_at = timezone.now()
        self.save(update_fields=['status', 'error_message', 'completed_at'])

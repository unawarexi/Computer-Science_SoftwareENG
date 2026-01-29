"""
User Serializers
================
DRF serializers for user models.
"""

from django.contrib.auth import get_user_model
from rest_framework import serializers
from apps.users.models import APIKey


User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model."""
    
    class Meta:
        model = User
        fields = [
            'id', 'email', 'full_name', 'avatar_url',
            'default_model', 'default_temperature',
            'total_tokens_used', 'total_conversations',
            'monthly_token_limit', 'tokens_used_this_month',
            'preferences', 'date_joined', 'last_login',
        ]
        read_only_fields = [
            'id', 'total_tokens_used', 'total_conversations',
            'tokens_used_this_month', 'date_joined', 'last_login',
        ]


class UserCreateSerializer(serializers.ModelSerializer):
    """Serializer for user registration."""
    
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ['email', 'password', 'password_confirm', 'full_name']
    
    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({
                'password_confirm': 'Passwords do not match.'
            })
        return data
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        return User.objects.create_user(**validated_data)


class UserUpdateSerializer(serializers.ModelSerializer):
    """Serializer for user profile updates."""
    
    class Meta:
        model = User
        fields = [
            'full_name', 'avatar_url', 'default_model',
            'default_temperature', 'preferences',
        ]


class ChangePasswordSerializer(serializers.Serializer):
    """Serializer for password change."""
    
    old_password = serializers.CharField()
    new_password = serializers.CharField(min_length=8)
    new_password_confirm = serializers.CharField()
    
    def validate(self, data):
        if data['new_password'] != data['new_password_confirm']:
            raise serializers.ValidationError({
                'new_password_confirm': 'Passwords do not match.'
            })
        return data


class APIKeySerializer(serializers.ModelSerializer):
    """Serializer for APIKey model."""
    
    class Meta:
        model = APIKey
        fields = [
            'id', 'name', 'key_prefix', 'scopes',
            'created_at', 'last_used_at', 'expires_at', 'is_active',
        ]
        read_only_fields = ['id', 'key_prefix', 'created_at', 'last_used_at']


class APIKeyCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating API keys."""
    
    key = serializers.CharField(read_only=True)
    
    class Meta:
        model = APIKey
        fields = ['name', 'scopes', 'expires_at', 'key']
        read_only_fields = ['key']
    
    def create(self, validated_data):
        key, prefix, key_hash = APIKey.generate_key()
        
        api_key = APIKey.objects.create(
            user=self.context['request'].user,
            key_prefix=prefix,
            key_hash=key_hash,
            **validated_data,
        )
        
        # Attach the key for response (only shown once)
        api_key.key = key
        return api_key


class LoginSerializer(serializers.Serializer):
    """Serializer for login."""
    
    email = serializers.EmailField()
    password = serializers.CharField()


class TokenSerializer(serializers.Serializer):
    """Serializer for token response."""
    
    access = serializers.CharField()
    refresh = serializers.CharField()

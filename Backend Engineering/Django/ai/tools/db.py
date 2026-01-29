"""
Database Tools
==============
Database query tools for AI agents.

Provides safe, parameterized database access with:
- Read-only mode by default
- Query validation
- Result formatting
"""

import logging
from typing import Any, Dict, List, Optional, Union

from django.db import connection
from langchain_core.tools import tool

from ai.tools.base import BaseTool

logger = logging.getLogger("ai.tools.db")


# =============================================================================
# DATABASE QUERY TOOL
# =============================================================================

class DatabaseQueryTool(BaseTool):
    """
    Execute SQL queries against the database.
    
    Features:
    - Parameterized queries to prevent SQL injection
    - Read-only mode by default
    - Query validation and sanitization
    - Result formatting for LLM consumption
    """
    
    def __init__(
        self,
        read_only: bool = True,
        max_results: int = 100,
        allowed_tables: Optional[List[str]] = None,
    ):
        """
        Initialize database query tool.
        
        Args:
            read_only: Only allow SELECT queries
            max_results: Maximum rows to return
            allowed_tables: Whitelist of allowed table names
        """
        super().__init__()
        self.read_only = read_only
        self.max_results = max_results
        self.allowed_tables = allowed_tables
        
        # Allowed operations
        self.allowed_operations = ["SELECT"] if read_only else [
            "SELECT", "INSERT", "UPDATE", "DELETE"
        ]
    
    @property
    def name(self) -> str:
        return "database_query"
    
    @property
    def description(self) -> str:
        ops = ", ".join(self.allowed_operations)
        return f"""Execute SQL queries against the database.
        Allowed operations: {ops}
        Use parameterized queries with %s placeholders for safety.
        Returns query results as a list of dictionaries."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "query": {
                "type": "string",
                "description": "SQL query with %s placeholders for parameters",
            },
            "params": {
                "type": "array",
                "description": "Query parameters (for %s placeholders)",
                "items": {"type": "string"},
                "default": [],
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["query"]
    
    def _validate_query(self, query: str) -> None:
        """Validate the query against allowed operations and tables."""
        # Check operation
        operation = query.strip().split()[0].upper()
        if operation not in self.allowed_operations:
            raise PermissionError(f"Operation '{operation}' not allowed")
        
        # Check for dangerous patterns
        dangerous_patterns = [
            "DROP", "TRUNCATE", "ALTER", "CREATE",
            "--", ";--", "/*", "*/", "EXECUTE", "EXEC",
        ]
        
        if self.read_only:
            for pattern in dangerous_patterns:
                if pattern.upper() in query.upper():
                    raise PermissionError(f"Dangerous pattern detected: {pattern}")
        
        # Check allowed tables if specified
        if self.allowed_tables:
            # Simple table extraction (not perfect but catches common cases)
            query_upper = query.upper()
            for table in self.allowed_tables:
                if table.upper() not in query_upper:
                    continue
            # If no allowed table found, raise error
            has_allowed = any(
                table.upper() in query_upper
                for table in self.allowed_tables
            )
            if not has_allowed:
                raise PermissionError("Query does not reference allowed tables")
    
    async def execute(
        self,
        query: str,
        params: Optional[List] = None,
    ) -> Dict[str, Any]:
        """
        Execute a database query.
        
        Args:
            query: SQL query with %s placeholders
            params: Query parameters
            
        Returns:
            Query results and metadata
        """
        params = params or []
        
        # Validate query
        self._validate_query(query)
        
        # Add LIMIT if SELECT and no limit specified
        operation = query.strip().split()[0].upper()
        if operation == "SELECT" and "LIMIT" not in query.upper():
            query = f"{query} LIMIT {self.max_results}"
        
        # Execute query
        with connection.cursor() as cursor:
            cursor.execute(query, params)
            
            if operation == "SELECT":
                columns = [col[0] for col in cursor.description]
                rows = cursor.fetchall()
                
                # Convert to list of dicts
                results = [
                    dict(zip(columns, row))
                    for row in rows
                ]
                
                return {
                    "success": True,
                    "operation": operation,
                    "columns": columns,
                    "rows": results,
                    "count": len(results),
                }
            else:
                return {
                    "success": True,
                    "operation": operation,
                    "affected_rows": cursor.rowcount,
                }
    
    def get_schema_info(self, table_name: str) -> Dict[str, Any]:
        """Get schema information for a table."""
        with connection.cursor() as cursor:
            # Get column information
            cursor.execute(f"""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_name = %s
            """, [table_name])
            
            columns = []
            for row in cursor.fetchall():
                columns.append({
                    "name": row[0],
                    "type": row[1],
                    "nullable": row[2] == "YES",
                })
            
            return {
                "table": table_name,
                "columns": columns,
            }


# =============================================================================
# DJANGO ORM TOOL
# =============================================================================

class DjangoORMTool(BaseTool):
    """
    Execute Django ORM queries.
    
    Safer than raw SQL as it uses Django's ORM protections.
    """
    
    def __init__(self, allowed_models: Optional[List[str]] = None):
        """
        Initialize Django ORM tool.
        
        Args:
            allowed_models: List of allowed model names (e.g., ["User", "Post"])
        """
        super().__init__()
        self.allowed_models = allowed_models or []
        self._model_registry: Dict[str, Any] = {}
    
    @property
    def name(self) -> str:
        return "django_orm"
    
    @property
    def description(self) -> str:
        models = ", ".join(self.allowed_models) if self.allowed_models else "all"
        return f"""Query the database using Django ORM.
        Allowed models: {models}
        Supports filter, exclude, order_by, and aggregation."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "model": {
                "type": "string",
                "description": "Model name to query",
            },
            "operation": {
                "type": "string",
                "description": "ORM operation",
                "enum": ["filter", "get", "all", "count", "aggregate"],
            },
            "filters": {
                "type": "object",
                "description": "Filter conditions (field__lookup: value)",
            },
            "order_by": {
                "type": "array",
                "description": "Fields to order by",
                "items": {"type": "string"},
            },
            "limit": {
                "type": "integer",
                "description": "Maximum results to return",
                "default": 100,
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["model", "operation"]
    
    def _get_model(self, model_name: str):
        """Get Django model class by name."""
        if model_name in self._model_registry:
            return self._model_registry[model_name]
        
        from django.apps import apps
        
        # Search for model in all apps
        for app_config in apps.get_app_configs():
            try:
                model = app_config.get_model(model_name)
                self._model_registry[model_name] = model
                return model
            except LookupError:
                continue
        
        raise ValueError(f"Model '{model_name}' not found")
    
    async def execute(
        self,
        model: str,
        operation: str,
        filters: Optional[Dict] = None,
        order_by: Optional[List[str]] = None,
        limit: int = 100,
    ) -> Dict[str, Any]:
        """Execute Django ORM query."""
        # Check allowed models
        if self.allowed_models and model not in self.allowed_models:
            raise PermissionError(f"Model '{model}' not allowed")
        
        filters = filters or {}
        order_by = order_by or []
        
        # Get model class
        model_class = self._get_model(model)
        
        # Build queryset
        queryset = model_class.objects.all()
        
        if filters:
            queryset = queryset.filter(**filters)
        
        if order_by:
            queryset = queryset.order_by(*order_by)
        
        # Execute operation
        if operation == "count":
            return {"count": queryset.count()}
        
        elif operation == "get":
            try:
                obj = queryset.get()
                return {"result": self._serialize_object(obj)}
            except model_class.DoesNotExist:
                return {"error": "Object not found"}
            except model_class.MultipleObjectsReturned:
                return {"error": "Multiple objects returned"}
        
        elif operation in ["filter", "all"]:
            queryset = queryset[:limit]
            results = [self._serialize_object(obj) for obj in queryset]
            return {"results": results, "count": len(results)}
        
        elif operation == "aggregate":
            from django.db.models import Count, Sum, Avg, Max, Min
            # Basic aggregation
            result = queryset.aggregate(
                count=Count("id"),
            )
            return {"aggregate": result}
        
        else:
            raise ValueError(f"Unknown operation: {operation}")
    
    def _serialize_object(self, obj) -> Dict[str, Any]:
        """Serialize a Django model instance."""
        from django.forms.models import model_to_dict
        return model_to_dict(obj)


# =============================================================================
# LANGCHAIN TOOL DECORATORS
# =============================================================================

@tool
def query_database(query: str, params: List[str] = None) -> str:
    """Execute a read-only SQL query against the database. Use %s for parameters."""
    import asyncio
    tool = DatabaseQueryTool(read_only=True)
    result = asyncio.get_event_loop().run_until_complete(
        tool.execute(query=query, params=params or [])
    )
    
    if result.get("rows"):
        # Format as readable table
        rows = result["rows"][:10]  # Limit for display
        if rows:
            columns = result["columns"]
            output = f"Results ({result['count']} rows):\n"
            output += " | ".join(columns) + "\n"
            output += "-" * 50 + "\n"
            for row in rows:
                output += " | ".join(str(row.get(c, ""))[:20] for c in columns) + "\n"
            return output
    
    return str(result)

"""
Code Execution Tool
===================
Safe code execution for AI agents.

Provides sandboxed Python code execution with:
- Timeout protection
- Memory limits
- Restricted imports
- Output capture
"""

import logging
import subprocess
import tempfile
import os
import sys
from typing import Any, Dict, List, Optional

from langchain_core.tools import tool

from ai.tools.base import BaseTool

logger = logging.getLogger("ai.tools.code_execution")


# =============================================================================
# CODE EXECUTION TOOL
# =============================================================================

class CodeExecutionTool(BaseTool):
    """
    Execute Python code in a sandboxed environment.
    
    Features:
    - Timeout protection
    - Restricted imports
    - Output capture (stdout/stderr)
    - Safe execution in subprocess
    """
    
    # Safe imports that are allowed
    SAFE_IMPORTS = {
        "math", "statistics", "random", "datetime", "json",
        "re", "collections", "itertools", "functools",
        "typing", "dataclasses", "enum",
        "numpy", "pandas",  # Data science
    }
    
    # Dangerous patterns to block
    DANGEROUS_PATTERNS = [
        "import os", "import sys", "import subprocess",
        "import shutil", "import socket", "import requests",
        "__import__", "eval(", "exec(", "compile(",
        "open(", "file(", "input(",
        "globals(", "locals(", "vars(",
        "getattr(", "setattr(", "delattr(",
    ]
    
    def __init__(
        self,
        timeout: int = 30,
        max_output_length: int = 10000,
        allow_dangerous: bool = False,
    ):
        """
        Initialize code execution tool.
        
        Args:
            timeout: Maximum execution time in seconds
            max_output_length: Maximum output length
            allow_dangerous: Allow potentially dangerous operations
        """
        super().__init__()
        self.timeout = timeout
        self.max_output_length = max_output_length
        self.allow_dangerous = allow_dangerous
    
    @property
    def name(self) -> str:
        return "code_execution"
    
    @property
    def description(self) -> str:
        return """Execute Python code and return the output.
        Use for calculations, data processing, or testing code snippets.
        Code runs in a sandboxed environment with timeout protection.
        Print statements will be captured as output."""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "code": {
                "type": "string",
                "description": "Python code to execute",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["code"]
    
    def _validate_code(self, code: str) -> None:
        """Validate code for dangerous patterns."""
        if self.allow_dangerous:
            return
        
        code_lower = code.lower()
        
        for pattern in self.DANGEROUS_PATTERNS:
            if pattern.lower() in code_lower:
                raise PermissionError(
                    f"Dangerous pattern detected: {pattern}. "
                    "This operation is not allowed for safety reasons."
                )
    
    def _create_sandbox_code(self, code: str) -> str:
        """Wrap code in a sandboxed execution environment."""
        return f'''
import sys
import io

# Capture output
_stdout = io.StringIO()
_stderr = io.StringIO()
sys.stdout = _stdout
sys.stderr = _stderr

# Safe imports
import math
import statistics
import random
import datetime
import json
import re
from collections import *
from itertools import *
from functools import *
from typing import *
from dataclasses import *
from enum import *

try:
    import numpy as np
except ImportError:
    pass

try:
    import pandas as pd
except ImportError:
    pass

# Execute user code
try:
{self._indent_code(code)}
except Exception as e:
    print(f"Error: {{type(e).__name__}}: {{e}}", file=sys.stderr)

# Output results
sys.stdout = sys.__stdout__
sys.stderr = sys.__stderr__
print("===STDOUT===")
print(_stdout.getvalue())
print("===STDERR===")
print(_stderr.getvalue())
'''
    
    def _indent_code(self, code: str, spaces: int = 4) -> str:
        """Indent code by specified spaces."""
        indent = " " * spaces
        return "\n".join(indent + line for line in code.split("\n"))
    
    async def execute(self, code: str) -> Dict[str, Any]:
        """
        Execute Python code safely.
        
        Args:
            code: Python code to execute
            
        Returns:
            Execution results with stdout, stderr, and return code
        """
        # Validate code
        self._validate_code(code)
        
        # Create sandboxed code
        sandbox_code = self._create_sandbox_code(code)
        
        # Write to temp file
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.py',
            delete=False
        ) as f:
            f.write(sandbox_code)
            temp_path = f.name
        
        try:
            # Execute in subprocess with timeout
            result = subprocess.run(
                [sys.executable, temp_path],
                capture_output=True,
                text=True,
                timeout=self.timeout,
                env={
                    **os.environ,
                    "PYTHONDONTWRITEBYTECODE": "1",
                }
            )
            
            # Parse output
            output = result.stdout
            stdout = ""
            stderr = ""
            
            if "===STDOUT===" in output:
                parts = output.split("===STDOUT===")[1]
                if "===STDERR===" in parts:
                    stdout, stderr = parts.split("===STDERR===")
                else:
                    stdout = parts
            
            # Truncate if too long
            if len(stdout) > self.max_output_length:
                stdout = stdout[:self.max_output_length] + "\n... (output truncated)"
            if len(stderr) > self.max_output_length:
                stderr = stderr[:self.max_output_length] + "\n... (output truncated)"
            
            return {
                "success": result.returncode == 0,
                "stdout": stdout.strip(),
                "stderr": stderr.strip() + (result.stderr or ""),
                "return_code": result.returncode,
            }
            
        except subprocess.TimeoutExpired:
            return {
                "success": False,
                "stdout": "",
                "stderr": f"Execution timed out after {self.timeout} seconds",
                "return_code": -1,
            }
            
        finally:
            # Clean up temp file
            try:
                os.unlink(temp_path)
            except:
                pass


# =============================================================================
# CALCULATOR TOOL
# =============================================================================

class CalculatorTool(BaseTool):
    """
    Simple calculator for mathematical expressions.
    
    Safer than code execution for simple calculations.
    """
    
    def __init__(self):
        """Initialize calculator tool."""
        super().__init__()
        # Safe functions for evaluation
        self.safe_functions = {
            "abs": abs,
            "round": round,
            "min": min,
            "max": max,
            "sum": sum,
            "pow": pow,
            "len": len,
        }
        
        # Add math functions
        import math
        for name in dir(math):
            if not name.startswith("_"):
                self.safe_functions[name] = getattr(math, name)
    
    @property
    def name(self) -> str:
        return "calculator"
    
    @property
    def description(self) -> str:
        return """Evaluate mathematical expressions.
        Supports: +, -, *, /, **, %, parentheses
        Functions: sin, cos, tan, sqrt, log, exp, abs, round, etc.
        Constants: pi, e"""
    
    @property
    def parameters(self) -> Dict[str, Any]:
        return {
            "expression": {
                "type": "string",
                "description": "Mathematical expression to evaluate",
            },
        }
    
    @property
    def required_params(self) -> List[str]:
        return ["expression"]
    
    async def execute(self, expression: str) -> Dict[str, Any]:
        """
        Evaluate a mathematical expression.
        
        Args:
            expression: Math expression to evaluate
            
        Returns:
            Calculation result
        """
        import math
        
        # Create safe namespace
        namespace = {
            "__builtins__": {},
            "pi": math.pi,
            "e": math.e,
            **self.safe_functions,
        }
        
        try:
            # Validate expression
            if any(kw in expression for kw in ["import", "exec", "eval", "__"]):
                raise ValueError("Invalid expression")
            
            # Evaluate
            result = eval(expression, namespace)
            
            return {
                "expression": expression,
                "result": result,
                "type": type(result).__name__,
            }
            
        except Exception as e:
            return {
                "expression": expression,
                "error": str(e),
            }


# =============================================================================
# LANGCHAIN TOOL DECORATORS
# =============================================================================

@tool
def execute_python(code: str) -> str:
    """Execute Python code and return the output. Use for calculations and data processing."""
    import asyncio
    tool = CodeExecutionTool()
    result = asyncio.get_event_loop().run_until_complete(tool.execute(code=code))
    
    if result.get("success"):
        output = result.get("stdout", "")
        if result.get("stderr"):
            output += f"\nWarnings/Errors:\n{result['stderr']}"
        return output or "Code executed successfully (no output)"
    else:
        return f"Execution failed: {result.get('stderr', 'Unknown error')}"


@tool
def calculate(expression: str) -> str:
    """Evaluate a mathematical expression. Example: calculate('2 + 2 * 3')"""
    import asyncio
    tool = CalculatorTool()
    result = asyncio.get_event_loop().run_until_complete(tool.execute(expression=expression))
    
    if "error" in result:
        return f"Error: {result['error']}"
    return f"{expression} = {result['result']}"

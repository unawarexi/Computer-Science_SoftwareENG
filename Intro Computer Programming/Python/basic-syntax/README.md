# RULES 

# Python Rules

These are some fundamental rules and best practices for writing clean and effective Python code.

## 1. Indentation

Use 4 spaces per indentation level. This enhances code readability.

```python
# Good
def example_function():
    if x > 0:
        print("Positive")
    else:
        print("Non-positive")

# Bad - Avoid using tabs for indentation
def example_function():
    if x > 0:
        print("Positive")
	else:
        print("Non-positive")
```


## 2. Naming Conventions
Follow PEP 8 naming conventions. Use descriptive names for variables, functions, and modules.

```python
# Good
def calculate_area(radius):
    return 3.14 * radius**2
```

## Variable Names
- A variable can have a short name (like x and y) or a more descriptive name (age, carname, total_volume). Rules for Python variables:
- A variable name must start with a letter or the underscore character
- A variable name cannot start with a number
- A variable name can only contain alpha-numeric characters and underscores (A-z, 0-9, and _ )
- Variable names are case-sensitive (age, Age and AGE are three different variables)
- A variable name cannot be any of the Python keywords.


## DATATYPES 

- 1. Built-in Data Types

Variables can store data of different types, and different types can do different things.

Python has the following data types built-in by default, in these categories:

- Text Type:	`str`
- Numeric Types:	`int, float, complex`
- Sequence Types:	`list, tuple, range`
- Mapping Type:	`dict`
- Set Types:	`set, frozenset`
- Boolean Type:	`bool`
- Binary Types:	`bytes, bytearray, memoryview`
- None Type:	`NoneType`

## METHODS 
EVery data type comes with an in-built function in which you can manipulate 

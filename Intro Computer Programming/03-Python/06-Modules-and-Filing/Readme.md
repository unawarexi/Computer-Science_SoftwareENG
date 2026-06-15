# ERROR Handling 


### Common Types of Errors in Python Error Handling

| Error Type            | Description                                                         | Resolution                                                                     |
|-----------------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------|
| SyntaxError           | Occurs due to incorrect syntax in the code.                         | Review code for syntax errors and correct them.                                |
| IndentationError      | Arises from incorrect indentation in the code.                      | Ensure consistent and proper indentation throughout the code.                  |
| NameError             | Happens when a name used is not found in the current scope.         | Define the name or check the scope where the name is expected to be found.     |
| TypeError             | Occurs when an operation is performed on an object of inappropriate type. | Check data types involved in the operation and convert them if necessary.      |
| ValueError            | Happens when a function receives an argument with an inappropriate value. | Validate input values before processing them in the function.                 |
| KeyError              | Occurs when a dictionary key is not found.                         | Verify the existence of the key in the dictionary before accessing it.         |
| IndexError            | Occurs when attempting to access an index that is out of range.     | Ensure that the index is within the bounds of the sequence being accessed.     |
| FileNotFoundError     | Occurs when a file or directory is requested but cannot be found.   | Double-check the file or directory path to ensure it exists and is accessible. |
| IOError               | Occurs when an I/O operation (e.g., file operation) fails.          | Verify file permissions, existence, and proper handling of file operations.    |
| ImportError           | Happens when a requested module cannot be found.                    | Install the missing module using pip or ensure it's available in the environment.|
| AttributeError        | Occurs when an attribute reference or assignment fails.             | Check the object and verify if the attribute exists or is accessible.          |
| ZeroDivisionError     | Happens when division or modulo operation is performed with zero as the divisor. | Avoid division or modulo operations with zero as the divisor.               |
| RuntimeError          | Generic error for runtime issues not covered by other error types.   | Review the runtime context and code logic to identify and fix the issue.        |
| KeyboardInterrupt     | Occurs when the user interrupts the execution (e.g., Ctrl+C).        | Implement appropriate error handling or handle KeyboardInterrupt gracefully.  |
| NotImplementedError  | Occurs when an abstract method is not implemented in a subclass.     | Implement the missing method in the subclass to resolve the error.             |
| FileExistsError       | Occurs when trying to create a file that already exists.            | Provide a different filename or handle the situation based on application logic.|
| PermissionError       | Occurs when trying to perform an operation without the required permissions. | Adjust file permissions or grant necessary permissions to resolve the error.  |
| JSONDecodeError       | Occurs when decoding JSON fails due to invalid JSON syntax.         | Ensure that the JSON data being decoded is valid and properly formatted.       |
| ModuleNotFoundError   | Occurs when a module could not be found.                            | Install the missing module using pip or verify the module path and import statement. |
| AssertionError        | Happens when an assert statement fails.                             | Review the condition specified in the assert statement and correct it if necessary. |
| EOFError              | Occurs when the input() function hits an end-of-file condition.     | Check for input stream termination conditions and handle them appropriately.    |
| NotImplementedError  | Occurs when an abstract method needs to be implemented in a subclass. | Implement the missing method in the subclass to resolve the error.             |
| UnicodeError          | Occurs when a Unicode-related encoding or decoding error occurs.    | Ensure proper encoding and decoding of Unicode data, handle exceptions appropriately. |
| RecursionError        | Occurs when the maximum recursion depth is exceeded.                | Review recursive functions and optimize or refactor them to avoid infinite recursion. |
| TimeoutError          | Occurs when a function call times out due to reaching the maximum time limit. | Increase timeout duration or optimize the function to complete within the time limit. |
| ConnectionError       | Occurs when a connection cannot be established or is lost.          | Check network connectivity, verify connection parameters, and handle connection errors. |
| MemoryError           | Occurs when the program runs out of memory.                         | Optimize memory usage, free unused resources, or increase system memory.         |
| NotImplementedError  | Occurs when an abstract method is not implemented in a subclass.    | Implement the missing method in the subclass to resolve the error.              |
| SyntaxWarning         | Indicates potential issues with syntax that may cause runtime errors. | Review code for potential syntax issues and address them to prevent runtime errors. |
| DeprecationWarning    | Warns about deprecated features that will be removed in future versions. | Update code to use recommended alternatives to deprecated features.          |
| RuntimeWarning        | Indicates potential issues during runtime that may not be errors but should be considered. | Review runtime warnings and take appropriate actions based on the context.    |
| FutureWarning         | Warns about constructs that will change semantics in future versions. | Update code to use constructs that are compatible with future versions.       |
| UserWarning           | Indicates warnings generated by user code.                          | Review user-generated warnings and take appropriate actions based on the context. |
| ImportWarning         | Indicates potential issues with imported modules or packages.       | Review import statements and imported modules for potential issues or conflicts. |
| ResourceWarning       | Indicates warnings about resource usage (e.g., unclosed files or sockets). | Close resources properly or handle resource management to avoid warnings.      |
| UnboundLocalError     | Occurs when a local variable is referenced before assignment.       | Ensure variables are initialized before use or define them in the appropriate scope. |
| UnboundLocalError     | Occurs when a local variable is referenced before assignment.       | Ensure variables are initialized before use or define them in the appropriate scope. |
| MemoryError           | Occurs when the program runs out of memory.                         | Optimize memory usage, free unused resources, or increase system memory.         |
| AttributeError        | Occurs when an object does not have the attribute being referenced. | Check the object and verify if the attribute exists or is accessible.          |
| NotImplementedError  | Occurs when an abstract method is not implemented in a subclass.    | Implement the missing method in the subclass to resolve the error.              |
| FileNotFoundError     | Occurs when a file or directory is requested but cannot be found.   | Double-check the file or directory path to ensure it exists and is accessible. |
| ImportError           | Happens when a requested module cannot be found.                    | Install the missing module using pip or ensure it's available in the environment.|
| KeyboardInterrupt     | Occurs when the user interrupts the execution (e.g., Ctrl+C).        | Implement appropriate error handling or handle KeyboardInterrupt gracefully.  |
| NotImplementedError  | Occurs when an abstract method is not implemented in a subclass.    | Implement the missing method in the subclass to resolve the error.              |


# Working with CSV Files in Python

- CSV (Comma-Separated Values) files are a popular format for storing and exchanging data in a structured format. 
- Python provides `built-in modules` for reading from and writing to CSV files, making it easy to work with tabular data.

## Reading CSV Files

To read data from a CSV file in Python, you can use the `csv` module. Here's a simple example of how to read from a CSV file:

```python
import csv

# Open the CSV file in read mode
with open('data.csv', 'r') as file:
    # Create a CSV reader object
    reader = csv.reader(file)

    # Iterate over each row in the CSV file
    for row in reader:
        print(row)
```

### Writing to CSV Files
To write data to a CSV file in Python, you can also use the `csv module`. Here's an example of how to write to a CSV file:

```python
import csv

# Sample data to write to the CSV file
data = [
    ['Name', 'Age', 'City'],
    ['John', 30, 'New York'],
    ['Alice', 25, 'Los Angeles'],
    ['Bob', 35, 'Chicago']
]

# Open the CSV file in write mode
with open('output.csv', 'w', newline='') as file:
    # Create a CSV writer object
    writer = csv.writer(file)

    # Write data to the CSV file
    for row in data:
        writer.writerow(row)

print("Data has been written to output.csv")
```

### Additional Features
- Reading and Writing with Dictionaries: Python's csv.DictReader and csv.DictWriter classes allow you to read and write CSV files using dictionaries, which can be more convenient when dealing with labeled data.
- Custom Delimiters and Quote Characters: The csv.reader and csv.writer classes support custom delimiters and quote characters, allowing you to work with CSV files that use different separators and quoting conventions.



# Working with JSON in Python

- JSON (JavaScript Object Notation) is a lightweight data-interchange format commonly used for exchanging data between a server and a web application. 
- Python provides built-in support for working with JSON through the `json` module, making it easy to `serialize/deserialize` Python objects to/from JSON format.

### Serializing Python Objects to JSON

To serialize Python objects (such as dictionaries, lists, or custom objects) into JSON format, you can use the `json.dumps()` function. Here's an example:

```python
import json

# Python dictionary to serialize to JSON
data = {
    'name': 'John',
    'age': 30,
    'city': 'New York'
}

# Serialize the dictionary to JSON format
json_data = json.dumps(data)

print(json_data)

Output:

json
{"name": "John", "age": 30, "city": "New York"}
```

### Deserializing JSON to Python Objects
To deserialize JSON data into Python objects, you can use the `json.loads()` function. Here's how you can deserialize JSON data into a Python dictionary:

```python
import json

# JSON data to deserialize
json_data = '{"name": "Alice", "age": 25, "city": "Los Angeles"}'

# Deserialize JSON data to a Python dictionary
data = json.loads(json_data)

print(data)
Output:

{'name': 'Alice', 'age': 25, 'city': 'Los Angeles'}
```


### Reading and Writing JSON Files
Python also provides functions for reading from and writing to JSON files using the json.dump() and json.load() functions. Here's an example:

```python
import json

# Python dictionary to write to a JSON file
data = {
    'name': 'Bob',
    'age': 35,
    'city': 'Chicago'
}

# Write data to a JSON file
with open('data.json', 'w') as file:
    json.dump(data, file)

# Read data from the JSON file
with open('data.json', 'r') as file:
    loaded_data = json.load(file)

print(loaded_data)
Output:

{'name': 'Bob', 'age': 35, 'city': 'Chicago'}
```
### Additional Features
- Working with Nested Data: JSON supports nested data structures, allowing you to represent complex hierarchical data.

- Custom Serialization and Deserialization: The json.dumps() and json.loads() functions provide options for custom serialization and deserialization using the default and object_hook parameters, respectively.

- JSON Schema Validation: Python libraries such as jsonschema provide functionality for validating JSON data against a defined schema.


# Regular Expressions (Regex) 

Regular expressions (regex) are powerful tools for pattern matching and text manipulation. In Python, you can use the `re` module to work with regular expressions. This README provides a detailed guide on using regex in Python.

## Introduction to Regular Expressions

- Regular expressions are sequences of characters that define a search pattern. 
- They are useful for searching, validating, and manipulating text strings. 
- In Python, you can use the `re` module to work with regular expressions.

### Basic Patterns

- **Literal Characters:** Matches the characters exactly as specified.
- **Character Classes:** Matches any one of a set of characters.
- **Anchors:** Specifies the position of a match in a string.
- **Quantifiers:** Specifies the number of occurrences of a character.
- **Grouping Constructs:** Groups multiple tokens together and creates a single entity.

### Using the re Module

To use regular expressions in Python, you need to import the `re` module:

```python
import re
```

#### uses of Basic Patterns in Regular Expressions (Regex)

| Pattern            | Description                                                                  | Example             | Matches                                                      |
|--------------------|------------------------------------------------------------------------------|---------------------|--------------------------------------------------------------|
| Literal Characters | Matches the characters exactly as specified.                                | `pattern = 'cat'`   | 'cat' in 'catch', 'cats', 'concatenate'                      |
| Character Classes  | Matches any one of a set of characters.                                      | `pattern = '[aeiou]'` | 'a' in 'cat', 'e' in 'best', 'i' in 'sit'                  |
| Anchors            | Specifies the position of a match in a string.                               | `pattern = '^start'`| 'start' at the beginning of a string                         |
| Quantifiers        | Specifies the number of occurrences of a character.                           | `pattern = 'a{2,4}'`| 'aa', 'aaa', or 'aaaa'                                       |
| Grouping Constructs| Groups multiple tokens together and creates a single entity.                  | `pattern = '(abc)+'`| 'abc', 'abcabc', 'abcabcabc', etc.                          |

Each pattern has its specific purpose in matching strings based on certain criteria. Understanding these basic patterns is fundamental in effectively using regular expressions for text processing and pattern matching tasks.


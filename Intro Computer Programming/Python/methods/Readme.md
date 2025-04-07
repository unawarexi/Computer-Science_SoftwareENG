# Dictionary methods 

| Dictionary Method                             | Description                                                                                                      |
|------------------------------------|------------------------------------------------------------------------------------------------------------------|
| clear()                            | Removes all items from the dictionary.                                                                           |
| copy()                             | Returns a shallow copy of the dictionary.                                                                        |
| fromkeys(seq, value=None)          | Creates a new dictionary with keys from seq and values set to value.                                              |
| get(key, default=None)             | Returns the value for key if key is in the dictionary, else default.                                              |
| items()                            | Returns a view object that displays a list of a dictionary's (key, value) tuple pairs.                            |
| keys()                             | Returns a view object that displays a list of the dictionary's keys.                                              |
| values()                           | Returns a view object that displays a list of the dictionary's values.                                             |
| pop(key, default=None)             | Removes the item with the specified key and returns its value or default if key is not found.                     |
| popitem()                          | Removes and returns an arbitrary (key, value) pair from the dictionary.                                           |
| setdefault(key, default=None)      | Returns the value of the key. If the key does not exist, inserts the key with the specified value (default).     |
| update(iterable)                   | Updates the dictionary with elements from another dictionary object or from an iterable of key-value pairs.     |
| len(dict)                          | Returns the number of items in the dictionary.                                                                   |


# Math methods 

| Math Function                   | Description                                                                                                 |
|----------------------------|-------------------------------------------------------------------------------------------------------------|
| abs(x)                     | Returns the absolute value of x.                                                                           |
| int(x)                     | Converts x to an integer.                                                                                  |
| float(x)                   | Converts x to a floating-point number.                                                                     |
| complex(real, imag)        | Creates a complex number.                                                                                   |
| round(x, n)                | Rounds x to n digits after the decimal point.                                                               |
| pow(x, y, z)               | Returns x to the power y; if z is present, returns x to the power y modulo z.                                |
| divmod(x, y)               | Returns the quotient and remainder of x divided by y as a tuple (x // y, x % y).                             |
| hex(x)                     | Converts an integer to a lowercase hexadecimal string prefixed with '0x'.                                    |
| oct(x)                     | Converts an integer to an octal string prefixed with '0o'.                                                   |
| bin(x)                     | Converts an integer to a binary string prefixed with '0b'.                                                   |
| sum(iterable, start)       | Returns the sum of an iterable with an optional starting value.                                              |
| min(iterable)              | Returns the smallest item in an iterable.                                                                   |
| max(iterable)              | Returns the largest item in an iterable.                                                                    |


# string methods 

| String Method                           | Description                                                                                   |
|----------------------------------|-----------------------------------------------------------------------------------------------|
| str.capitalize()                | Converts the first character of a string to uppercase and the rest to lowercase.             |
| str.upper()                     | Converts all characters in the string to uppercase.                                           |
| str.lower()                     | Converts all characters in the string to lowercase.                                           |
| str.title()                     | Converts the first character of each word in the string to uppercase and the rest to lowercase.|
| str.swapcase()                  | Converts uppercase characters to lowercase and vice versa.                                    |
| str.strip()                     | Removes leading and trailing whitespace (or specified characters) from the string.            |
| str.lstrip()                    | Removes leading whitespace (or specified characters) from the string.                          |
| str.rstrip()                    | Removes trailing whitespace (or specified characters) from the string.                         |
| str.startswith(prefix)          | Returns `True` if the string starts with the specified prefix.                                 |
| str.endswith(suffix)            | Returns `True` if the string ends with the specified suffix.                                   |
| str.count(substring)            | Returns the number of non-overlapping occurrences of a substring in the string.               |
| str.find(substring)             | Returns the lowest index of the substring in the string, or -1 if not found.                   |
| str.index(substring)            | Similar to `find()`, but raises a `ValueError` if the substring is not found.                 |
| str.replace(old, new)          | Replaces occurrences of a substring with another substring.                                   |
| str.split(separator)            | Splits the string into a list of substrings based on the specified separator.                 |
| str.join(iterable)              | Joins elements of an iterable (e.g., a list) into a single string using the string as a separator.|
| str.isalnum()                   | Returns `True` if all characters in the string are alphanumeric.                              |
| str.isalpha()                   | Returns `True` if all characters in the string are alphabetic.                                 |
| str.isdigit()                   | Returns `True` if all characters in the string are digits.                                     |
| str.islower()                   | Returns `True` if all characters in the string are lowercase.                                  |
| str.isupper()                   | Returns `True` if all characters in the string are uppercase.                                  |
| str.isspace()                   | Returns `True` if all characters in the string are whitespace.                                 |
| str.encode(encoding)            | Returns a bytes object encoding the string using the specified encoding.                      |
| str.format()                    | Formats the string using placeholders and substitutions.                                       |
| str.isnumeric()                 | Returns `True` if all characters in the string are numeric.                                     |
| str.partition(separator)        | Splits the string into a 3-tuple based on the first occurrence of the separator.              |
| str.rpartition(separator)       | Splits the string into a 3-tuple based on the last occurrence of the separator.               |
| str.zfill(width)                | Pads the string with zeros to the specified width.                                             |


# List Methods


| Lists Method                | Description                                                                                               |
|-----------------------|-----------------------------------------------------------------------------------------------------------|
| append(x)             | Adds an item to the end of the list.                                                                      |
| extend(iterable)      | Extends the list by appending elements from the iterable.                                                  |
| insert(i, x)          | Inserts an item at a specified position.                                                                  |
| remove(x)             | Removes the first occurrence of an item from the list.                                                    |
| pop([i])              | Removes and returns the item at the specified position. If no index is specified, removes and returns the last item in the list. |
| clear()               | Removes all items from the list.                                                                          |
| index(x[, start[, end]]) | Returns the index of the first occurrence of an item in the list. Raises a ValueError if the item is not found. |
| count(x)              | Returns the number of occurrences of an item in the list.                                                  |
| sort(key=None, reverse=False) | Sorts the items of the list in place.                                                               |
| reverse()             | Reverses the elements of the list in place.                                                               |
| copy()                | Returns a shallow copy of the list.                                                                       |



# Methods for Tuples:

| Tuple Method                | Description                                                                                               |
|-----------------------|-----------------------------------------------------------------------------------------------------------|
| count(x)              | Returns the number of occurrences of a value in the tuple.                                                 |
| index(x[, start[, end]]) | Returns the index of the first occurrence of a value in the tuple. Raises a ValueError if the value is not found. |

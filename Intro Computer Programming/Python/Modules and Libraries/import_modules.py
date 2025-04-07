print('imported my_module')

test = 'Test_string'

def find_index(to_search, target):
    '''finds the index of a value in a sequence'''
    for i, value in enumerate(to_search):
        if value == target:
            return i
    return -1


"""
1.Built-in Functions: These are functions that are available without the need for an explicit import.

2.Built-in Types: Modules related to fundamental data types.
datetime: Date and time handling.
math: Mathematical functions.
random: Random number generation.
collections: Data structures like lists, dictionaries, etc.
itertools: Tools for working with iterators and combinatorial functions.

3.File and Directory Access: Modules for file and directory manipulation.
os: Operating system interface.
shutil: High-level file operations.
pathlib: Object-oriented filesystem paths


4.Data Persistence and Serialization:
pickle: Serialization and deserialization of Python objects.
json: JSON encoding and decoding.
sqlite3: SQLite database access.


5.Networking and Internet:
socket: Low-level networking.
http: HTTP client and server libraries.
urllib: URL handling and HTTP client functions.


6.GUI Programming:
tkinter: Standard GUI library for Python.
turtle: Turtle graphics for educational purposes.


7.Multithreading and Multiprocessing:
threading: Thread-based parallelism.
multiprocessing: Process-based parallelism.


8.Debugging and Profiling:
pdb: The Python Debugger.
cProfile: Performance analysis.


9.Regular Expressions:
re: Regular expression operations.

10.Command Line Arguments and Environment:
argparse: Command-line parsing.
os.environ: Environment variables.

11.Unit Testing:
unittest: Unit testing framework.
doctest: Testing through interactive documentation.

12.Utilities:
sys: System-specific parameters and functions.
time: Time-related functions.
subprocess: Subprocess management.
logging: Logging facility.

13.Data Compression and Archiving:
zipfile: Work with ZIP archives.
gzip, bz2: Compression formats.

14.Internationalization and Localization:
locale: Internationalization support.
gettext: Multilingual internationalization.

15.Security:
hashlib: Hash functions.
ssl: SSL/TLS support.
This is just a small subset of the Python Standard Library modules and their functions. Each module provides a range of classes and functions tailored to specific tasks. 
To learn more about a particular module and its functions, you can refer to the official Python documentation: https://docs.python.org/3/library/
"""


# A Module is a file that contains code to perform a specific task.
# A module is a file that contains constants,variables,functions or classes
"""
* Built-In Modules : Modules that are offered by the programming language.
* Third Party Modules : Modulels that are created by other programmers.
* Self Created Modules : Modules that are designed/created by the programmer.
"""

#HOW TO USE A MODULE
"""
* Import the module by name
    >>> import math
    >>> import math as mt
    >>> from math import mean
"""

# BUILT-IN MODULES
"""
- math
- statistics
- random
- datetime
- calendar
- smtpd
- urllib
- socket
"""

import math
# print(math.sqrt(64))
# print(math.isqrt(64))
# print(math.sin(60))

import random
# Helps to perform randomization within your program.
numbers = [3,2,98,0,45,23,13,199,302,0]

lucky_number = random.choice(numbers)
lucky_number = random.randint(0,100)
# print(lucky_number)

import datetime
# print(datetime.datetime.now())
# print(datetime.date.today())

import calendar
# print(calendar.month(theyear=2019, themonth=10))
# print(calendar.month(theyear=2023, themonth=10))

# THIRD PARTY MODULES
"""
- requests
- docx
- beautifulsoup
- pypdf
- qrcode

HOW TO USE:
* first download the module from the web.
    >>> pip install [name of module]
    >>> pip install requests
* import the module for use.
"""

# SELF CREATED MODULES
# import utility
from utility import generate_10_digit, generate_digit

# value = generate_10_digit()
value = generate_digit(10)
print(value)
"""
File Handling Best Practices
Use Context Managers (with Statement): Use the with statement to ensure that files are properly closed after use, even if an exception occurs.
Handle Exceptions: Always handle exceptions when reading from or writing to files to gracefully handle errors and prevent program crashes.
Close Files Explicitly: If you're not using the with statement, make sure to close files explicitly using the close() method to release system resources. 
"""

# To read a file in python we first make use of the open() method which helps to open the 
# file for us either for updating or creating a file.

# The open() funtion takes in two arguement; 
# 1. The File path
# 2. The Mode at which you want to open the file.
""" 
FILE MODES:
 r - Reading a file
 r+ -> Reading and Writing to a file
 w -> Writing to a file(creates the file if it does'nt exist before)
 w+ -> Writing and Reading to a file
 a -> Writing to a file(appends the writings to the end of the file)
 a+ -> 
 x -> Creating a file(fails if the file already exists)
"""

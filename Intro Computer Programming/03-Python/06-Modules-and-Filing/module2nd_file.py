import import_modules
import sys
"""
if you want to access only a specific func. from the main_module file use:
   " from import_modules import find_index"
   this would only access the func. "find_index" and nothing else
NOTE: if you want to use this method then to access other non-primitive datatype
    e.g find_index, test and so on "use comma to seperate"

the import import_modules gives access to everything
the path responsible for python searching for imported modules is called "sys"
NOTE: you can use "import import_modules as imp_mod"  to shorten the len.
"""
courses = ['history', 'arts', 'biology', 'geography']

index = import_modules.find_index(courses, 'biology')
#print(index)

print(sys.path)

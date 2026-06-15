# ==================== FUNCTIONS """
#  functions are sets block of instructions 
# used to solve specific tasks
# we use the "def" to declare a python func.
#  functions allow us to reuse code without repeating ourselves
# 
# """

def hello_world():
    pass  # this pass is to leave the func. empty without showing any error

print(hello_world()) # this is executing an empty func.


def hello_worldly():
    print(" the first function ")  # this pass is a block of instruction

hello_worldly() # this is executing the func

# ==================== arguments and params =================
"""
the first "greeting is a parameter
the "hello" is the argument
NOTE: A PARAM is like a placeholder in a function thatg recieves any argument passsed
the greeting param is in a local scope ; meaning it's within a function not global
"""


def magician(greeting):
    return "{} magician.".format(greeting)

print(magician("hello"))


"""
this is a multiple param in a function
the "name serves as a default incase there is no value for greeting"
but if the "name" is assigned another value it'll take the new value
"""
def magicians(greeting, name = "you"):
    return "{} {}".format(greeting, name)

print(magicians("hello"))

"""
this allows us to print abituary number of positional or keywowrd args
i.e meaning the amount of times a value would occur throughout.
  e.g student name or course; 
args print out positional arguments
kwargs print out an arguments with "keys"
NOTE: this one accepts values as args and print them as tuple and dict.
"""
def students_info(*args, **kwargs):
    print(args)
    print(kwargs)
students_info('math', 'art', name = "arcadian", age=22)

  #=========== another example
"""
in this example the * and ** is acting a an unpacker
NOTE: it's not a must to name it args or kwargs but it is advisable, what is usefulis the "* and **"
"""  
courses = ["arts", "science"] # this is a list
info = {"name": "aurelia", "age": "40"} # this is a dict; contains keys and "{}"

students_info(*courses, **info)




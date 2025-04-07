# using comparison operator 

# the "==" sign is used to denote direct in values comparison
# but the "is" is used to check if the both values is same everywhere
"""
e.g a = [1,2,3], b = [1,2,3]
 a == b # would give us true because the value is same 
 a is b # would not give us true because a is not b; it uses "id" to check

"""
language = "java"

if language == "python":
 print ("language is python")
elif language == "java":
    print ("language is java")
else:
    print ("language is unknown")


# USING BOOLENS 
"""
the "and" gives true only when all is true
the "OR" gives true if one of the value is true
the "NOT" gives true if the comparison turns out true
  it turns true to false and vice versa
"""

user = "admin"
logged_in = True

# and
if user == "admin" and logged_in:
    print("Admin page")
else:
    print("bad credentials"),


users = "admin"
logged_init = True

# or 
if users == "admin" or logged_init:
    print("Admin page")
else:
    print("bad credentials")



user = "admin"
logged_in = False

# not
if not logged_in:
    print("please log in")
else:
    print("welcome")
    
    
#----------------------------------- more

"""
Conditionals in programming is a process of altering flow/execution
of a program. 
A conditional statement executes a block of code depending on
whether a condition is true of false.

SYNTAX: 
if condition statement:
    block_of_code...
elif condition statement: [optional...]
    block_of_code...
else: [optional...]
    block_of_code...
"""

age = 25
has_pvc = False

# Using only the if statement
# if age > 18:
#     print("You can place your vote!")

# Using the if and else statemen
# if age >= 18 and has_pvc:
#     print("You can place your vote!")
# elif age >= 90:
#     print("You cannot place your vote!")
#     print("You have exceed the age.")
# else:
#     print("You cannot place your vote!")
#     print("Grow Up Kid!")

print('\n')

# Nested if statement
# if age >= 18:
#     if has_pvc:
#         print("You can place your vote!")
#     else:
#         print("Go get your PVC!")
# elif age >= 90:
#     print("You cannot place your vote!")
#     print("You have exceed the age.")
# else:
#     print("You cannot place your vote!")


# Short-hand for if and else statement
#SYNTAX:
# on_true_statement if condition else on_false_statement

# if has_pvc:
#     print("You can place your vote!")
# else:
#     print("Go get your PVC!")

print("You can place your vote!") if has_pvc else print("Go get your PVC!")



"""Assignment

1. Learn how to use python input() method.
2. Simulate the behaviour of an ATM.

"""
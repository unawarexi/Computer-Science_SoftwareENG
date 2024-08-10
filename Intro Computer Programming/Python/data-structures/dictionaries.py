"""
a dictioninary is used 
a dictionary uses "{}" as brackets
"""


students = {"name": 'john',"age":25, "courses":['math', 'english', 'geology']}
print(students.get("course", "Not_Found"))

"""
use the .get method to display value of "none" instead of error 
this is useful when you make a mistake by requesting a  key that doesn't exist
the not found would display if it doesn't find any matching key
"""


# ======================== ADDDING and removing A VALUE TO THE DICTIONARY ==================
"""
you add value by using the update() method
you remove usinf del or pop 
  NOTE: the pop removes it from the dict but displays it as a new value
"""
colledge = {"name": 'john',"age":25, "courses":['math', 'english', 'geology']}
colledge.update({"name": "elisha", "phone": '555-55', "age":29})

age = colledge.pop("age")
print(age) #this explains the pop() method

print(colledge)

"""
this is looping throung the dictionary to get both the keys and the values
"""
for key, value in colledge.items():
    print(key, value)
    
    
# Dictionary
"""
- A Collection of other datatypes.
- It is mutable.
- It is Ordered.
- It is an Hashable datatype.
- It is created using the curly bracket {} or dict method
- Unlike like list and tuple, items in a dictionary are accessed by key
- Dictionary accepts data using a key and value format 
"""

student1 = {'firstname': 'David', 'lastname': 'Onye', 'age': 56, 'complexion': 'dark'}

#tuple method of makinf dict
student2 = dict((
    ('firstname', 'David'), 
    ('lastname', 'Onye'), 
    ('age', 56), 
    ('complexion', 'dark')
))

# print(student1)
# print(student2)


# Accessing items in a dictionary : we make use of the key
# print(student1['firstname'])

# Update items in a dictionary.
# print(student1)
# student1['lastname'] = 'Onyedikachi'
# student1['lasname'] = 'Onyedikachi'
# print(student1)

# Add an item to a dictionary
student1['gender'] = 'Male'

student1['test'] = {'1st-test': 100, '2nd-test': 68, '3rd-test': 100}

# print(student1['test']['2nd-test'])

# Dictionary Method
# print(student1.items(), '\n')
# print(student1.keys(), '\n')
# print(student1.values())

print(student1.pop("test"))
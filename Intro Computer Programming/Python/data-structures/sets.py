"""
 A set is an unordered collection with no duplicate elements.
 Basic uses include membership testing and eliminating duplicate entries. 
 Set objects also support mathematical operations like union, intersection, difference, and symmetric difference.

Curly braces or the set() function can be used to create sets. 
NOTE: to create an empty set you have to use set(), not {}; the latter creates an empty dictionary
"""

basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
print(basket)                      # show that duplicates have been removed


'orange' in basket                 # fast membership testing
'crabgrass' in basket

# Demonstrate set operations on unique letters from two words

a = set('abracadabra')
b = set('alacazam')
a                                  # unique letters in a
{'a', 'r', 'b', 'c', 'd'}
a - b                              # letters in a but not in b
{'r', 'd', 'b'}
a | b                              # letters in a or b or both
{'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
a & b                              # letters in both a and b
{'a', 'c'}
a ^ b                              # letters in a or b but not both
{'r', 'd', 'b', 'm', 'z', 'l'}


# SETS
"""
- A collection of datatype
- It is immutable.
- It is Unordered.
- It is homogenous and heterogenous
- Sets must not contain any mutable
- It is created with the curly bracket {} or set()
"""

nums = {67,98,2,45,1,0,23,13,4}
strings = {'Peter','Tinubu','Atiku'}

print(nums)
# print(strings)

# for items in nums:
#     print(items)
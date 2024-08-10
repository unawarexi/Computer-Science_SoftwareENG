"""
1. clear(): Removes all items from the dictionary.
2. copy(): Returns a shallow copy of the dictionary.
3. fromkeys(seq, value=None): Creates a new dictionary with keys from seq and values set to value.
get(key, default=None): Returns the value for key if key is in the dictionary, else default.
items(): Returns a view object that displays a list of a dictionary's (key, value) tuple pairs.
keys(): Returns a view object that displays a list of the dictionary's keys.
values(): Returns a view object that displays a list of the dictionary's values.
pop(key, default=None): Removes the item with the specified key and returns its value or default if key is not found.
popitem(): Removes and returns an arbitrary (key, value) pair from the dictionary.
setdefault(key, default=None): Returns the value of the key. If the key does not exist, inserts the key with the specified value (default).
update(iterable): Updates the dictionary with elements from another dictionary object or from an iterable of key-value pairs.
len(dict): Returns the number of items in the dictionary.  
"""

andrew = ["man", 26, "tall", "6ft", "software engineer", ]


#===================== adding to a list using methods ====================

# append adds items to the end of the list
andrew.append("brother")

#inserts add items to a particular position
andrew.insert(1, "king")


print(andrew)


#===================== Removing a list using methods ====================

# pop() removes items at the end of the list
andrew.pop()

#removes a particular item from the list
andrew.pop(1)


print(andrew)

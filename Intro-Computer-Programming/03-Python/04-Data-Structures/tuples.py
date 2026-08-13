# TUPLE
"""
- A collection of other datatypes.
- Tuples are immutable datatypes.
- Tuples are also ordered datatype.
- Tuples are created using the parenthesis () or the tuple method.
- Items in a tuple can be homogenous or heterogenous.
- Items in a tuple are accessed either with positive or negative index.
- A tuple is simply restricted list.
"""

gender1 = ('Male','Fmale','Others', 'Not Specified') # Method 1
gender2 = tuple(['Male','Female','Others']) # Method 2 : Helps convert a list to a tuple

print(gender1)
print(gender2)

# :Accessing an Items in a Tuple
# print(gender1[2])

# :Slicing a Tuple
# print(gender1[2:4])
# a = gender1[1:3]

# :Update items in tuple : Cannot be done, because it is immutable.
# gender1[1] = 'Female'
# print(gender1)


# Tuple Methods
# gender1.count('Male')
# gender1.index("Others")

# Joining Tuples
a = (1,2,3)
b = (4,5,6)

d = a + b
print(d)




filename = "Downloads/music/swift.mp3"

# this isn't dynamic
print(filename.split(".")[0].split("/")[2]) 

#this is dynamic
print(filename.split("/")[-1].split(".")[0])
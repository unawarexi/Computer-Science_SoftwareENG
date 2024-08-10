"""
it can access multiple simple datatype
it is represnted in [] and seprated by commas
you can access the values using indexing

1. changing an items
2. accessing items
3. list slicing
"""

andrew = ["man", 26, "tall", "6ft", "software engineer", ]

#================ ACCESSING A LIST  ===========================

#================= """
# print out a particular value and ignore the rest without []

print(andrew[-1])
print(andrew[3])



#================  list mutuability ================================
# yoh change the any value in the list using the indexing to spot
# assigning the new varaible

andrew[-1] = "web-developer"
print(andrew)



#================  list SLCING ================================

#================= """
# print out a set particular value and ignore the rest
# it displays in a []

print(andrew[0:3])

#================= """
# print out a single value in the single datatype 
# it doesn't displays in a []
# e.g "man" and it prints only "a" in "man"

print(andrew[0][1])


# ============ USING NEGATIVE INDEXING  =====================
# GETS the last 3 items 
print(andrew[ -3:])

# gets only a particular set item and 
#displays in [] from negative
print(andrew[ -3: -1])


#=============== REVERSING A LIST ===========================
print(andrew[::-1])

# reverses a partcular set from end 
print(andrew[ -3:][::-1])






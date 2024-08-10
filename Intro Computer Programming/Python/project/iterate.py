people = ["ademola", "winner", "perpetual", "chris", "andrew", "coworker"]

# ------------------ question  ------------------------

for peeps in people:
    if peeps == "andrew":
       
        print("found the result")
        break
    else:
        print(peeps.upper())



# ------------------ question 2 ------------------------
""" 
perform the operation 256 * 98999 avoid using the * operator
HINT: use iteration 
"""

a = 256
b = 98999

answer = 0
increase = 0


""" 
i encountered a problem which involed indentation
place you output statements in accordance to it's respective block
"""
# for x in range(b):
#     answer += a
# print(answer)

while increase <  b:
    answer += a
    increase += 1
print("\n", answer)
    
# =========================== for AND WHILE LOOPS"""
#  for loops is basically used for a certain amount of time
# """"

"""
there's a fiunction known as break and continue
NOTE: the break statement ends the loop
but the continue statement skips to the next iterable

"""
nums = [1,2,3,4,5,6,7,8,9]
for num in nums:
    if num == 5:
        print("found!")
        break    # breaks out of the loop after found
    print(num)
    
for num in nums:
    if num == 5:
        print("found!")
        continue    # skips to the next iterable
    #print(num)
    
    
# =================== NESTED LOOPS ==================== 
"""
this run the first loop across the second loop once and deliver
then repeats the same thing for each item in the first loop to each item in the second loop
"""
   
for num in nums:
    for letters in "abc":
        #print((num), (letters))


# ======================================== WHILE LOOPS======================="""
#  while loops is basically used for an infinite amount of time
#  while loops needs 1. an increment to avoid continous loops
# """"



"""
 you can set an infinite loop to wait till it gets the desired result before breaking out
 to do this change the comparison to true; e.g
 while true:  # this would wait this whenever it gets 5 before executing
    if x == 5:
        break
    print (x)
    x += 1  
"""
x = 0
while x < 10:
    if x == 5:
        break
    print (x)
    x += 1   # this will add one everytime it runs through the loop
    

for i in range(4):
    print(i, end=" ")
    

# Operators are symbols that perform an operation/task on a given input/operand.
"""
Types of Operators
1. Arithmetic
2. Assignment
3. Comparison
4. Logical
5. Membership
6. Identity
"""

# Arithmetic Operators : Numbers,String,etc
"""
+   Addition
-   Subtraction
*   Multiplication
/   Division
//  Division Floor
%   Modulus/Remainder
**  Exponential
"""

# Note: The operators + and * can also be used on strings.
# print('Hello' + ' ' + 'World')
# print('Triplet ' * 3)

# print(5/2) #Returns a Float
# print(5//2) #Returns an Integer

# print(5%2) #Returns an Integer

# print(5**2) #Returns a Float or an Integer

# Assignment Operators
""" 
     Example    Same as
=    a = 6
+=   a += 6     a = a + 6
-=   a -= 6     a = a - 6
*=   a *= 6     a = a * 6
/=   a /= 6     a = a / 6
//=  a //= 6    a = a // 6
%=   a %= 6     a = a % 6
**=  a **= 6    a = a **6
"""
# a = 4 
# a += 6
# print(a)

# Comparison Operators : Boolean
"""
==      Equality
!=      Inequality
>       Greater than
>=      Greater than or equal to
<       Lesser than
<=      Lesser than or equal to
"""
# b = 45
# print(b >= 45)

# Logical Operators : Boolean
"""
and
or
not
"""
t = True
f = False
# print(f"{t} and {t} : ", t and t)
# print(f"{f} and {f} : ", f and f)
# print(f"{t} and {f} : ", t and f)
# print(f"{f} and {t} : ", f and t)

# print(f"{t} or {t} : ", t or t)
# print(f"{f} or {f} : ", f or f)
# print(f"{t} or {f} : ", t or f)
# print(f"{f} or {t} : ", f or t)

# print(f"not {t} : ", not t)
# print(f"not {f} : ", not f)

# Membership Operator : Boolean
"""
in
not in

Note: It is case-sensitive
"""
essay = """
My name is Adamu Adamu, I hail from Bornu State in Northen part of Nigeria.
I study linguistics at the University of Benin.
"""

# print("badass" in essay)
# print("bornu" in essay.lower()) # approach 1
# print("bornu" in essay or "Bornu" in essay) # approach 2

# print("Jack" not in essay)

# Identity Operators : Boolean
"""
is
is not
"""

a = 5
b = 5
c = [1,2,3]
d = [1,2,3]

# print(f'{a} is {b}:', a is b)
# print(f'{c} is {d}:', c is d)
# print(f'{c} is {c}:', c is c)


# Note: The "is" operator checks for the variable's object identity while the
# "==" operator checks for the equality of the values stored on the variable.
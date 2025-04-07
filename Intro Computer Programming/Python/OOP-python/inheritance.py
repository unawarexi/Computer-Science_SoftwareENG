from classes import Person
# INHERITANCE
class Employee(Person):
    def __init__(self, role=None):
        self._role = role  
        # Encapsulation
        # The _ helps python interpreter identify role as an encapsulated attribute
        # While it does'nt have any special feature it performs on it, it flags a 
        # message to other programmers to restrict direct action on it.

    # Polymorphism
    # Here the inherited talking method was used in describing an employee.
    def about(self, words):
        return super().talking(words)


employee1 = Employee(role="staff")
employee1.name = "Micheal Todd"
employee1.height = "5.6ft"

print('\t', employee1.name)
employee1.talking("I just got a job in the company")
employee1.about("""
    I am a passionate individual with over 4 years experience managing teams for
    increased productivity. I have a degree in Management Science from the University
    of Ibadan. 
""")
// Inheritance Example
class Animal {
  void move() {
    print("The animal moves");
  }
}

// use extends to get qualities from parent class
class Dog extends Animal {
  // this is a sub-class
  void bark() {
    print("The dog barks");
  }
}

// Function to demonstrate Inheritance
void demonstrateInheritance() {
  Dog dog = Dog();
  dog.move(); // Inherited method
  dog.bark(); // Child class method
}

void main() {
  demonstrateInheritance();
}

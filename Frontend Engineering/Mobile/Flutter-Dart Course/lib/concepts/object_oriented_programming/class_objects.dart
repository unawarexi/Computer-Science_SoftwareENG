/**
 * Dart OOP examples based on the README.md
 * Demonstrating Classes, Inheritance, Encapsulation, Polymorphism, and more.
 */

// Class and Object example
class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Method
  void greet() {
    print("Hello, my name is $name and I am $age years old.");
  }
}

// Function to demonstrate Class and Object
void demonstratePerson() {
  Person p = Person("Alice", 30);
  p.greet();
}

void main() {
  // Call demonstration functions
  demonstratePerson();
}

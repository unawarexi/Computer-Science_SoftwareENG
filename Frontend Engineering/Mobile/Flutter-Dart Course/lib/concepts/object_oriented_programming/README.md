# Object-Oriented Programming in Dart

## Overview
Dart is an object-oriented programming language that supports key OOP principles such as **Classes**, **Objects**, **Inheritance**, **Polymorphism**, **Abstraction**, and **Encapsulation**. In Dart, everything is an object, including basic types like `int` and `String`.

This documentation will explain the core concepts of Object-Oriented Programming in Dart, with code examples provided in the `oop.dart` file.

---

## Table of Contents
1. [Classes and Objects](#classes-and-objects)
2. [Constructors](#constructors)
3. [Methods](#methods)
4. [Inheritance](#inheritance)
5. [Polymorphism](#polymorphism)
6. [Encapsulation](#encapsulation)
7. [Abstraction](#abstraction)
8. [Getters and Setters](#getters-and-setters)
9. [Static Members](#static-members)
10. [Mixins](#mixins)

---

## 1. Classes and Objects
### **Class**: A blueprint for creating objects (instances).
### **Object**: An instance of a class.
### **Constructors**: Constructors are special methods invoked when creating an object. Dart provides several types of constructors:

- **Default Constructor**
- **Named Constructor**
- **Factory Constructor**
### **Methods**: Methods are functions defined inside a class that operate on its data.


```dart
// Defining a class
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

// Creating an object (instance of the class)
void main() {
  Person p = Person("Alice", 30);
  p.greet(); // Output: Hello, my name is Alice and I am 30 years old.
}
```

## 2. Inheritance
Inheritance allows one class to inherit properties and methods from another class, promoting code reuse.


## 3. Polymorphism
Polymorphism allows one method to take on different behaviors depending on the object that calls it.

## 4. Encapsulation
Encapsulation is the concept of restricting access to certain data and methods in a class by using private members `(prefix with _)`.

```dart
class BankAccount {
  // Private fields
  String _accountNumber;
  double _balance;

  BankAccount(this._accountNumber, this._balance);

  // Public method to get balance
  double getBalance() {
    return _balance;
  }

  // Private method
  void _setBalance(double amount) {
    _balance = amount;
  }
}
```

## 5. Abstraction
Abstraction is the process of hiding the internal implementation of a feature and only exposing the necessary functionality. In Dart, we use abstract classes to define abstract methods.
```dart
// Abstract class
abstract class Shape {
  // Abstract method
  double area();
}

// Concrete class
class Circle extends Shape {
  double radius;
  Circle(this.radius);

  // Implementing the abstract method
  @override
  double area() {
    return 3.14 * radius * radius;
  }
}
```

## 6. Getters and Setters
Getters and Setters allow controlled access to class properties. Dart supports both normal and custom getters and setters.

```dart
class Rectangle {
  double width, height;

  Rectangle(this.width, this.height);

  // Custom getter
  double get area => width * height;

  // Custom setter
  set widthValue(double value) {
    width = value < 0 ? 0 : value;
  }
}
```

## 7. Static Members
Static members belong to the class rather than an instance. They are accessed via the class name.
```dart
class MathOperations {
  static double pi = 3.14;

  // Static method
  static double calculateCircleArea(double radius) {
    return pi * radius * radius;
  }
}

void main() {
  print(MathOperations.pi); // Access static field
  print(MathOperations.calculateCircleArea(5)); // Call static method
}
```

## 8. Mixins
Mixins provide a way to share methods and properties between classes without using inheritance. Dart allows a class to use multiple mixins.

## Conclusion
Dart offers a wide range of OOP features that allow for clean, reusable, and organized code. Understanding concepts like inheritance, polymorphism, encapsulation, and abstraction will help you write more maintainable and scalable applications.
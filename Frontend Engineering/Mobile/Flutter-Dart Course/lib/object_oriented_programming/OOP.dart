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

// Constructors Example
class Car {
  String brand;
  int year;

  // Default constructor
  Car(this.brand, this.year);

  // Named constructor
  Car.fromBrand(this.brand) : year = 2020;

  // Factory constructor
  factory Car.defaultCar() {
    return Car('Toyota', 2022);
  }
}

// Inheritance Example
class Animal {
  void move() {
    print("The animal moves");
  }
}

class Dog extends Animal {
  void bark() {
    print("The dog barks");
  }
}

// Polymorphism Example
class AnimalPolymorphic {
  void sound() {
    print("The animal makes a sound");
  }
}

class Cat extends AnimalPolymorphic {
  @override
  void sound() {
    print("The cat meows");
  }
}

// Encapsulation Example
class BankAccount {
  String _accountNumber; // Private field
  double _balance; // Private field

  BankAccount(this._accountNumber, this._balance);

  // Public method to get balance
  double getBalance() {
    return _balance;
  }

  // Private method to set balance
  void _setBalance(double amount) {
    _balance = amount;
  }
}

// Abstract class Example
abstract class Shape {
  double area(); // Abstract method
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() {
    return 3.14 * radius * radius;
  }
}

// Getters and Setters Example
class Rectangle {
  double width, height;

  Rectangle(this.width, this.height);

  // Getter for area
  double get area => width * height;

  // Setter for width
  set widthValue(double value) {
    width = value < 0 ? 0 : value; // Prevent negative width
  }
}

// Static Members Example
class MathOperations {
  static double pi = 3.14;

  // Static method to calculate circle area
  static double calculateCircleArea(double radius) {
    return pi * radius * radius;
  }
}

// Mixin Example
mixin CanFly {
  void fly() {
    print("Flying...");
  }
}

mixin CanSwim {
  void swim() {
    print("Swimming...");
  }
}

class Bird with CanFly, CanSwim {}

// Function to demonstrate Class and Object
void demonstratePerson() {
  Person p = Person("Alice", 30);
  p.greet();
}

// Function to demonstrate Constructors
void demonstrateCar() {
  Car car1 = Car('BMW', 2021);
  Car car2 = Car.fromBrand('Honda');
  Car car3 = Car.defaultCar();

  print("Car 1: ${car1.brand}, Year: ${car1.year}");
  print("Car 2: ${car2.brand}, Year: ${car2.year}");
  print("Car 3: ${car3.brand}, Year: ${car3.year}");
}

// Function to demonstrate Inheritance
void demonstrateInheritance() {
  Dog dog = Dog();
  dog.move(); // Inherited method
  dog.bark(); // Child class method
}

// Function to demonstrate Polymorphism
void demonstratePolymorphism() {
  AnimalPolymorphic animal = AnimalPolymorphic();
  animal.sound(); // Output: The animal makes a sound

  AnimalPolymorphic cat = Cat();
  cat.sound(); // Output: The cat meows (polymorphism)
}

// Function to demonstrate Encapsulation
void demonstrateEncapsulation() {
  BankAccount account = BankAccount("123456", 1000.0);
  print("Balance: ${account.getBalance()}");
}

// Function to demonstrate Abstraction
void demonstrateAbstraction() {
  Circle circle = Circle(5);
  print("Area of Circle: ${circle.area()}");
}

// Function to demonstrate Getters and Setters
void demonstrateGettersAndSetters() {
  Rectangle rectangle = Rectangle(10, 5);
  print("Area of Rectangle: ${rectangle.area}");
  rectangle.widthValue = -5; // Trying to set negative width
  print("Updated Width: ${rectangle.width}");
  print("Area of Rectangle after update: ${rectangle.area}");
}

// Function to demonstrate Static Members
void demonstrateStaticMembers() {
  print("Value of Pi: ${MathOperations.pi}");
  print(
      "Area of Circle with radius 5: ${MathOperations.calculateCircleArea(5)}");
}

// Function to demonstrate Mixins
void demonstrateMixins() {
  Bird bird = Bird();
  bird.fly(); // Output: Flying...
  bird.swim(); // Output: Swimming...
}

void main() {
  // Call demonstration functions
  demonstratePerson();
  demonstrateCar();
  demonstrateInheritance();
  demonstratePolymorphism();
  demonstrateEncapsulation();
  demonstrateAbstraction();
  demonstrateGettersAndSetters();
  demonstrateStaticMembers();
  demonstrateMixins();
}

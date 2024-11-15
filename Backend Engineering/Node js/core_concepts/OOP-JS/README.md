# Object-Oriented Programming (OOP) in JavaScript

## Table of Contents
- [Introduction](#introduction)
- [Core Concepts](#core-concepts)
  - [Classes](#classes)
  - [Objects](#objects)
  - [Constructors](#constructors)
  - [Methods](#methods)
  - [Inheritance](#inheritance)
  - [Encapsulation](#encapsulation)
  - [Polymorphism](#polymorphism)
  - [Abstraction](#abstraction)
- [OOP Best Practices](#oop-best-practices)
- [Examples](#examples)
  - [Class and Object Example](#class-and-object-example)
  - [Inheritance Example](#inheritance-example)
  - [Encapsulation Example](#encapsulation-example)
  - [Polymorphism Example](#polymorphism-example)
  - [Abstraction Example](#abstraction-example)
- [Conclusion](#conclusion)

## Introduction
Object-Oriented Programming (OOP) is a programming paradigm that revolves around the concept of objects. JavaScript, being a multi-paradigm language, supports OOP and enables the creation of reusable, modular code.

OOP principles in JavaScript allow you to model real-world entities and their interactions. The core pillars of OOP are **Encapsulation**, **Inheritance**, **Polymorphism**, and **Abstraction**.

## Core Concepts


### Explanation:
- **Classes** provide the structure for your objects.
- **Objects** are instances of classes.
- **Encapsulation** hides internal details, promoting controlled access.
- **Inheritance** allows code reuse by extending functionality.
- **Polymorphism** lets you redefine methods in derived classes.
- **Abstraction** hides unnecessary complexity, exposing only what's necessary.

This `README.md` serves as a detailed guide and cheat sheet for understanding OOP in JavaScript.


### Classes
In JavaScript, classes are blueprints for creating objects. They define properties (variables) and methods (functions) that the object will have.

```javascript
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  greet() {
    console.log(`Hello, my name is ${this.name}.`);
  }
}
```

### Objects
An object is an instance of a class. Objects hold data (state) and methods (behavior).

```javascript
const john = new Person('John', 30);
john.greet(); // Output: Hello, my name is John.
```
### Constructors
The constructor is a special method for initializing objects. It gets called when an instance of a class is created.

```javascript
class Car {
  constructor(brand, model) {
    this.brand = brand;
    this.model = model;
  }
}
```

### Methods
Methods define behaviors of an object and are functions inside a class.

```javascript
class Animal {
  speak() {
    console.log('The animal makes a sound.');
  }
}
```

## Inheritance
Inheritance allows a class to inherit properties and methods from another class, promoting code reusability.

```javascript
class Dog extends Animal {
  speak() {
    console.log('The dog barks.');
  }
}

const dog = new Dog();
dog.speak(); // Output
```
## Encapsulation
Encapsulation is the bundling of data and methods that operate on that data within one unit, often restricting direct access to some components.

```javascript
class BankAccount {
  #balance = 0; // private field

  deposit(amount) {
    this.#balance += amount;
  }

  getBalance() {
    return this.#balance;
  }
}

const account = new BankAccount();
account.deposit(100);
console.log(account.getBalance()); // Output: 100
```

## Polymorphism
Polymorphism allows objects of different classes to be treated as objects of a common superclass. It enables method overriding and overloading.

```javascript
class Shape {
  area() {
    return 0;
  }
}

class Circle extends Shape {
  constructor(radius) {
    super();
    this.radius = radius;
  }

  area() {
    return Math.PI * this.radius ** 2;
  }
}

const shapes = [new Shape(), new Circle(5)];

shapes.forEach(shape => console.log(shape.area()));
// Output: 0 (for Shape), 78.54 (for Circle)
```

## Abstraction
Abstraction is the concept of hiding complex implementation details and showing only the necessary parts.

```javascript
class RemoteControl {
  pressPowerButton() {
    console.log('Power button pressed.');
  }
}
```

## OOP Best Practices
- **Encapsulate Data**: Use private fields to prevent direct access to object properties.
- **Favor Composition Over Inheritance**: Composition allows greater flexibility by including behaviors instead of inheriting them.
- **Use Polymorphism Appropriately**: Make sure method overriding is meaningful and does not introduce unnecessary complexity.
- **Avoid Large Classes**: Break down large classes into smaller, manageable units.

# 02 - Basic Design Principles

Building on the architectural mindset, we need a set of guiding principles to write clean, maintainable, and robust code. The most famous set of principles in Object-Oriented Design is the **SOLID** principles.

## The SOLID Principles

SOLID is an acronym for five design principles intended to make software designs more understandable, flexible, and maintainable.

1. **Single Responsibility Principle (SRP)**
   - *A class should have one, and only one, reason to change.*
   - **Meaning:** Each class or module should focus on a single task or responsibility. If a class handles both database connections and UI rendering, it violates SRP.

2. **Open/Closed Principle (OCP)**
   - *Software entities should be open for extension, but closed for modification.*
   - **Meaning:** You should be able to add new functionality to a system without altering existing, tested code. This is often achieved using interfaces and abstract classes.

3. **Liskov Substitution Principle (LSP)**
   - *Subtypes must be substitutable for their base types.*
   - **Meaning:** If you replace a parent class with a child class, the program should not break. The child class must honor the contract established by the parent.

4. **Interface Segregation Principle (ISP)**
   - *Clients should not be forced to depend upon interfaces that they do not use.*
   - **Meaning:** It's better to have many small, specific interfaces than one large, general-purpose interface. Don't force a class to implement methods it doesn't need.

5. **Dependency Inversion Principle (DIP)**
   - *High-level modules should not depend on low-level modules. Both should depend on abstractions.*
   - **Meaning:** Code should depend on interfaces or abstract classes rather than concrete implementations. This decouples the system and makes it easier to test and swap components.

## Practice Exercises

1. **SRP Check:** Take a look at a recent project you built. Find a class that is over 300 lines long. Can you identify multiple responsibilities? Try splitting it into two or more smaller classes.
2. **OCP Implementation:** Write a simple program that calculates the area of different shapes (Circle, Rectangle). Design it in a way that adding a new shape (like Triangle) doesn't require modifying the `AreaCalculator` class.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) or explore [03 - OOP vs Functional Paradigms](./03-OOP-functional-paradigms.md).

# 03 - OOP & Functional Paradigms

As an architect, you need to choose the right paradigm for the problem at hand. The two most dominant paradigms in modern software engineering are Object-Oriented Programming (OOP) and Functional Programming (FP).

## Comparing OOP and FP

| Feature | Object-Oriented Programming (OOP) | Functional Programming (FP) |
| :--- | :--- | :--- |
| **Core Concept** | Objects that encapsulate state and behavior. | Pure functions and immutable data. |
| **State** | Mutable state is common. Objects change over time. | Immutable state. Instead of changing data, new data is created. |
| **Execution** | Imperative (telling the computer *how* to do things). | Declarative (telling the computer *what* to do). |
| **Best Used For** | Systems with complex interactions between entities (e.g., UI components, game engines). | Systems requiring high concurrency, data transformations, and mathematical modeling. |

*Note: Many modern languages (like JavaScript, Python, C#, and Java) support both paradigms, allowing you to mix and match as needed.*

## Clean Code Basics

Regardless of the paradigm you choose, your code must be clean. Clean code is code that is easy to read, understand, and modify by other human beings.

- **Meaningful Names:** Name variables, functions, and classes intuitively. A variable named `elapsedTimeInDays` is better than `d`.
- **Small Functions:** Functions should do one thing, do it well, and do it only. They should ideally be short (under 20 lines).
- **Fewer Comments, Expressive Code:** Don't use comments to explain bad code. Rewrite the code to be self-explanatory.
- **Formatting:** Consistent indentation and grouping of related code blocks make code visually easier to parse.

## Common Design Patterns

Design patterns are proven, reusable solutions to commonly occurring problems in software design.

- **Singleton:** Ensures a class has only one instance and provides a global point of access to it. (Use sparingly!)
- **Factory Method:** Provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.
- **Observer:** Defines a one-to-many dependency between objects so that when one object changes state, all its dependents are notified automatically (very common in UI frameworks).
- **Strategy:** Defines a family of algorithms, encapsulates each one, and makes them interchangeable at runtime.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) or proceed to [04 - Developer Craftsmanship](./04-developer-craftsmanship.md).

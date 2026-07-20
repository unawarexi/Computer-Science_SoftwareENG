# 07 - Behavioral Design Patterns

Behavioral design patterns are concerned with algorithms and the assignment of responsibilities between objects. They characterize complex control flow that's difficult to follow at runtime.

## Key Behavioral Patterns

### 1. Observer (Publish/Subscribe)
Defines a one-to-many dependency so that when one object changes state, all its dependents are notified and updated automatically.
- **Use Case:** A `NewsletterPublisher` that notifies multiple `Subscriber` objects whenever a new article is released.

### 2. Strategy
Defines a family of algorithms, encapsulates each one, and makes them interchangeable. Strategy lets the algorithm vary independently from the clients that use it.
- **Use Case:** A navigation app that allows routing via Car, Bike, or Walking. Each routing algorithm is a Strategy.

### 3. State
Allows an object to alter its behavior when its internal state changes. The object will appear to change its class.
- **Use Case:** A Vending Machine with states: `Idle`, `HasCoin`, `Dispensing`. The behavior of "press button" changes drastically depending on the current state.

### 4. Command
Encapsulates a request as an object, thereby letting you parameterize clients with different requests, queue or log requests, and support undoable operations.
- **Use Case:** Implementing "Undo" / "Redo" functionality in a text editor.

### 5. Chain of Responsibility
Avoids coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain.
- **Use Case:** Authentication and Authorization middleware in a web server. If one handler validates the user, it passes the request to the next handler.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) or finish this module with [08 - Anti-Patterns and Refactoring](./08-anti-patterns-refactoring.md).

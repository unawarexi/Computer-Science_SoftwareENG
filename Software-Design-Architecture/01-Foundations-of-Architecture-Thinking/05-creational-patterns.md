# 05 - Creational Design Patterns

In object-oriented design, creational patterns deal with object creation mechanisms. They try to create objects in a manner suitable to the situation. Instead of instantiating objects directly using constructors (which can hardcode dependencies), these patterns give us more flexibility.

## Why Use Creational Patterns?
Direct object creation (`new Object()`) can lead to tight coupling. Creational patterns decouple the system from how its objects are created, composed, and represented.

## Key Creational Patterns

### 1. Singleton
Ensures a class has only one instance and provides a global point of access to it.
- **Use Case:** Managing shared resources like a database connection pool or an application logger.
- **Caution:** Singletons introduce global state, making unit testing difficult. Use them sparingly.

### 2. Factory Method
Defines an interface for creating an object, but lets subclasses decide which class to instantiate.
- **Use Case:** When a class cannot anticipate the type of objects it needs to create. For example, a `DocumentCreator` that can create `PDFDocument` or `WordDocument` subclasses.

### 3. Abstract Factory
Provides an interface for creating families of related or dependent objects without specifying their concrete classes.
- **Use Case:** Building a UI toolkit where you need to create macOS-style buttons/checkboxes or Windows-style buttons/checkboxes, ensuring they are always used together.

### 4. Builder
Separates the construction of a complex object from its representation so that the same construction process can create different representations.
- **Use Case:** When an object requires a lot of initialization parameters (e.g., creating an `HttpRequest` with headers, body, method, and URL).

### 5. Prototype
Specifies the kinds of objects to create using a prototypical instance, and creates new objects by copying this prototype.
- **Use Case:** When creating a new object is computationally expensive, but copying an existing one is cheap.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) or explore [06 - Structural Design Patterns](./06-structural-patterns.md).

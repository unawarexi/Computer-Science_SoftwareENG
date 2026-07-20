# 06 - Structural Design Patterns

Structural design patterns deal with object composition. They ease design by identifying a simple way to realize relationships between entities. They help ensure that when parts of a system change, the entire structure doesn't need to be overhauled.

## Key Structural Patterns

### 1. Adapter
Allows classes with incompatible interfaces to work together. It acts as a bridge between two independent interfaces.
- **Use Case:** You have an existing `XmlParser` but a new library only accepts JSON. You build an Adapter to wrap the XML parser so it outputs JSON.

### 2. Facade
Provides a unified interface to a set of interfaces in a subsystem. It defines a higher-level interface that makes the subsystem easier to use.
- **Use Case:** A complex video conversion library with dozens of classes. A `VideoConverterFacade` provides a simple `convert(video, format)` method.

### 3. Proxy
Provides a surrogate or placeholder for another object to control access to it.
- **Use Case:** Lazy initialization (Virtual Proxy), access control (Protection Proxy), or logging requests (Logging Proxy).

### 4. Bridge
Decouples an abstraction from its implementation so that the two can vary independently.
- **Use Case:** A `Shape` class (abstraction) and a `Renderer` class (implementation). You can have `Circle` and `Square`, rendered by `VectorRenderer` or `RasterRenderer` without exploding the number of classes.

### 5. Composite
Composes objects into tree structures to represent part-whole hierarchies. It lets clients treat individual objects and compositions of objects uniformly.
- **Use Case:** A file system where `File` and `Directory` share a common interface (`FileSystemItem`), allowing you to calculate size or delete them uniformly.

### 6. Decorator
Attaches additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.
- **Use Case:** Adding features like scrolling or borders to a GUI window at runtime without creating new classes for `ScrollingWindow` or `BorderedWindow`.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) or proceed to [07 - Behavioral Design Patterns](./07-behavioral-patterns.md).

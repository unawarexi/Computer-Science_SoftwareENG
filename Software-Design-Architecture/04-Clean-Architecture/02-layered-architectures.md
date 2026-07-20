# 02 - Layered Architectures

Clean Architecture is an umbrella term for several architectural patterns that share the same objective: separation of concerns by dividing the software into layers. 

## 1. Hexagonal Architecture (Ports and Adapters)
Invented by Alistair Cockburn, this architecture ensures that the application is isolated from external frameworks and technologies.
- **Core (Domain):** Contains the business logic.
- **Ports:** Interfaces defined by the Core that dictate how it wants to communicate with the outside world.
- **Adapters:** Implementations of these ports that translate between the external system (like a database or web framework) and the Core. 
- *Why Hexagonal?* The "hexagon" is just a visual metaphor to show that there are multiple ways to enter/exit the application (multiple ports), rather than just a top-down layer approach.

## 2. Onion Architecture
Proposed by Jeffrey Palermo, this architecture builds on similar principles but heavily emphasizes the use of Dependency Injection.
- **Concentric Circles:** The architecture is structured in concentric layers (like an onion). The Domain Model is at the very center.
- **Direction of Coupling:** All dependencies always point inwards towards the center. The core does not know about the outer layers.

## 3. Building Modular Projects
When building a modular project, these architectures guide your folder and module structure. A typical layout might look like this:

- `/domain` (Entities, Business Rules)
- `/application` (Use Cases, Interfaces/Ports)
- `/infrastructure` (Database Implementations, External API clients)
- `/presentation` (Controllers, UI, Web Framework)

By strictly enforcing boundaries between these modules, you ensure that a change in the Database (Infrastructure) does not ripple into your Business Rules (Domain).

---
**Next Step:** Learn how to enforce these boundaries in [03 - The Dependency Rule](./03-dependency-rule.md).

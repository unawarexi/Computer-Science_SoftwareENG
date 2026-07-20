# 03 - The Dependency Rule

The secret sauce that makes Clean Architecture work is **The Dependency Rule**. 

## What is the Dependency Rule?
> *Source code dependencies must only point INWARD, toward higher-level policies.*

This means that code in an inner circle can know **nothing at all** about code in an outer circle.
- The inner circle (Domain) cannot import or use classes from the outer circle (Database/UI).
- Data formats used in an outer circle should not be used by an inner circle.

## Applying SOLID at the Architecture Level

The Dependency Rule is heavily reliant on the **Dependency Inversion Principle (DIP)** from SOLID.

### How it works in practice:
Imagine your Use Case (inner layer) needs to save data to a Database (outer layer). According to the Dependency Rule, the Use Case cannot import the Database class. 

How do we solve this?
1. The **Use Case** defines an interface (e.g., `UserRepository`).
2. The **Database layer** creates a class (e.g., `SqlUserRepository`) that implements this interface.
3. At runtime, the application wires them together (usually via Dependency Injection).

The Use Case only knows about the *interface*, not the *implementation*. The dependency has been inverted!

### Crossing Boundaries
When data crosses a boundary (e.g., from a Controller to a Use Case), it should always be in the form most convenient for the **inner circle**.
- Do not pass HTTP Request objects directly into your Use Cases.
- Map the HTTP Request into a plain Data Transfer Object (DTO) and pass that inward.

This strict enforcement of boundaries ensures your core business logic remains pristine and testable.

---
**Congratulations!** You now understand the foundations of Clean Architecture. Head back to the [Main Syllabus](./README.md).

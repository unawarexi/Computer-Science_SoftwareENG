# 08 - Anti-Patterns and Advanced Refactoring

While design patterns are templates for good solutions, **anti-patterns** are templates for bad solutions—common responses to recurring problems that are usually ineffective and risk being highly counterproductive.

## Common Architecture Smells and Anti-Patterns

1. **God Object (The Blob)**
   - **What it is:** A single class or module that controls everything and knows too much. It becomes a massive, unmaintainable bottleneck.
   - **How to Refactor:** Apply the **Single Responsibility Principle (SRP)**. Break the God object into smaller, focused classes.

2. **Spaghetti Code**
   - **What it is:** Code with a complex, tangled control structure (lots of `GOTO` statements, exceptions used for control flow, or deeply nested callbacks).
   - **How to Refactor:** Break code down into smaller functions. Use early returns (guard clauses) to reduce nesting. Apply the **Command** or **Strategy** pattern to simplify logic.

3. **Golden Hammer**
   - **What it is:** "If all you have is a hammer, everything looks like a nail." Relying on a familiar technology or pattern to solve every problem, even when it's not appropriate.
   - **How to Refactor:** Expand your architectural toolkit. Choose the right tool for the job. (e.g., Don't use a massive SQL database for simple key-value caching).

4. **Copy-Paste Programming**
   - **What it is:** Duplicating code blocks instead of creating reusable abstractions.
   - **How to Refactor:** Apply the **DRY (Don't Repeat Yourself)** principle. Extract duplicated logic into a shared utility function, a base class, or a new component.

## Refactoring Strategies

Refactoring is the process of improving the internal structure of code without altering its external behavior.

- **Extract Method:** Turn a fragment of code into a method whose name explains the purpose of the method.
- **Replace Conditional with Polymorphism:** If you have huge `switch` statements checking object types, use subclasses and overridden methods instead (often enabled by the Strategy or State patterns).
- **Introduce Parameter Object:** Group multiple parameters that naturally go together into a single object.

Always ensure you have **Automated Tests** in place before starting a major refactoring session!

---

**Next Step:** You have completed the Foundations module! Head back to the [Main Syllabus](./README.md) and prepare to dive into Clean Architecture.

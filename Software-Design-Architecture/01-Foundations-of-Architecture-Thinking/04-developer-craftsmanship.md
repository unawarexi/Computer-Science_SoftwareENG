# 04 - Developer Craftsmanship

Software architecture is not just about high-level diagrams; it is also rooted in the day-to-day discipline of writing excellent code. Developer craftsmanship is about taking pride in your work and adhering to pragmatic guidelines.

## Pragmatic Guidelines

Beyond SOLID, developers follow several acronym-based principles to keep the codebase healthy.

1. **KISS (Keep It Simple, Stupid)**
   - Systems work best when they are kept simple rather than made complex.
   - Avoid over-engineering. Write the simplest code that solves the current problem.

2. **DRY (Don't Repeat Yourself)**
   - Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
   - If you see the exact same block of code in three different places, abstract it into a reusable function or class.

3. **YAGNI (You Aren't Gonna Need It)**
   - Always implement things when you actually need them, never when you just foresee that you need them.
   - Don't build elaborate features or abstractions for hypothetical future use cases. It wastes time and adds unnecessary complexity.

4. **Law of Demeter (Principle of Least Knowledge)**
   - A module should not know about the inner workings of the objects it manipulates.
   - "Talk to your friends, not to strangers." Avoid long chains of method calls like `user.getAccount().getProfile().getAddress().getZipCode()`.

## Refactoring and Code Quality

**Refactoring** is the process of restructuring existing computer code without changing its external behavior. It improves the nonfunctional attributes of the software.

- **When to Refactor:** When you are adding a feature, when you are fixing a bug, or during dedicated code-review sessions. Following the "Boy Scout Rule": *Always leave the code better than you found it.*
- **Code Smells:** These are indicators that your code might need refactoring. Examples include duplicate code, long methods, large classes, and deep nesting.
- **Automated Testing:** You cannot safely refactor code without a solid suite of automated tests (Unit Tests, Integration Tests). Tests ensure that your changes haven't broken existing functionality.

---

**Next Step:** Head back to the [Main Syllabus](./README.md) to review the course structure!

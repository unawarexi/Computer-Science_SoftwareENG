# Rust Variables - Everything You Need to Know

Rust is a statically-typed, memory-safe language that takes **variables** seriously. This guide covers how variables work, how to declare them, and all the cool features Rust offers for managing them.

## What Is a Variable?

A **variable** stores a value in memory that your program can use. In Rust:

- Variables are **immutable by default**
- You must use `mut` to make them **mutable**

## Variable Declaration

### Immutable Variable (Default)

```rust
let name = "Alice";
```

You cannot change name later.

### Mutable Variable

```rust
let mut age = 25;
age = 26; // ✅ allowed
```

Use `mut` when you want to change the value later.

## Type Inference and Annotation

Rust can infer types:

```rust
let score = 90; // inferred as i32
```

You can also explicitly annotate:

```rust
let score: u8 = 90;
```

## Shadowing

You can redeclare a variable with the same name:

```rust
let name = "Alice";
let name = name.len(); // name is now a number (usize)

println!("Name length: {}", name);
```

This is called shadowing and is different from mutability.

## Constants

Constants are:

- Always immutable
- Declared with `const`
- Must include type annotations
- Use ALL_CAPS by convention

```rust
const PI: f64 = 3.1415;
```

Constants are evaluated at compile time.

## Scopes and Lifetimes

Rust uses block scope:

```rust
fn main() {
    let x = 5;
    {
        let y = 10;
        println!("{}", y); // works
    }
    // println!("{}", y); // ❌ won't compile
}
```

Variables declared inside `{}` are only accessible inside those braces.

## Variable Rules Summary

| Rule | Example |
|------|---------|
| Immutable by default | `let x = 5;` |
| Use mut for mutability | `let mut x = 5;` |
| Type is inferred unless specified | `let x: i32 = 5;` |
| Constants use const | `const MAX: u32 = 100;` |
| Shadowing allowed | `let x = x + 1;` |
| Scoped to {} blocks | Only visible inside block |

## Best Practices

- Use `let` without `mut` unless mutation is required
- Use `const` for fixed values like settings or limits
- Use shadowing to transform values without mutability
- Name variables clearly and use snake_case

## Example

```rust
fn main() {
    const MAX_SCORE: u32 = 100;

    let name = "Bob";
    let mut score = 90;

    score += 5;

    let name = name.len(); // shadowing

    println!("{} scored {}/{}", name, score, MAX_SCORE);
}
```

## Summary

| Feature | Keyword | Mutable | Scoped? | Notes |
|---------|---------|---------|---------|-------|
| Variable | `let` | ❌ / ✅ | ✅ | Default is immutable |
| Constant | `const` | ❌ | Global | Must have type |
| Shadowed Variable | `let` | ✅ | ✅ | New variable, same name |

## Want More?

Check out: variables in The Rust Book

Try using `let` with different types and play with `mut`, `const`, and shadowing.
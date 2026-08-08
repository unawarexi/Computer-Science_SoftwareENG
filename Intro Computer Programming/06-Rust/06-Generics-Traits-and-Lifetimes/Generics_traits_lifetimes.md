# Rust: Generic Types, Traits, and Lifetimes

This guide provides an in-depth explanation of Generic Types, Traits, and Lifetimes in Rust. These are core features that help you write safe, flexible, and reusable code.

## Table of Contents

1. [Generic Types](#generic-types)
2. [Traits](#traits)
3. [Lifetimes](#lifetimes)
4. [Putting It All Together](#putting-it-all-together)
5. [Summary](#summary)
6. [Tips for Learning](#tips-for-learning)

## Generic Types

### What are Generics?

Generics allow you to write code that works with any data type, without repeating yourself.

### Why Use Generics?

- Avoid code duplication
- Make your code more flexible and reusable
- Maintain type safety

### Example: Without Generics

```rust
fn print_i32(x: i32) {
    println!("{}", x);
}

fn print_str(x: &str) {
    println!("{}", x);
}
```

This approach requires multiple versions for different types.

### With Generics

```rust
fn print_any<T: std::fmt::Display>(x: T) {
    println!("{}", x);
}
```

- `T` is a generic type parameter
- `T: Display` is a trait bound that says `T` must implement the `Display` trait
- Now works for `i32`, `&str`, `f64`, etc.

### Generic Struct Example

```rust
struct Point<T> {
    x: T,
    y: T,
}

let int_point = Point { x: 1, y: 2 };
let float_point = Point { x: 1.0, y: 2.0 };
```

### Multiple Generics

```rust
struct Point<T, U> {
    x: T,
    y: U,
}
```

## Traits

### What is a Trait?

A trait is like an interface — it defines shared behavior. You can implement traits for your own types to give them specific functionality.

### Declaring a Trait

```rust
trait Speak {
    fn speak(&self);
}
```

### Implementing a Trait

```rust
struct Dog;
struct Cat;

impl Speak for Dog {
    fn speak(&self) {
        println!("Woof!");
    }
}

impl Speak for Cat {
    fn speak(&self) {
        println!("Meow!");
    }
}
```

### Using Traits (Polymorphism)

```rust
fn make_them_speak(animal: &impl Speak) {
    animal.speak();
}
```

### Trait Bounds in Generics

```rust
fn shout<T: Speak>(thing: T) {
    thing.speak();
}
```

### Traits with Default Methods

```rust
trait Greet {
    fn greet(&self) {
        println!("Hello!");
    }
}
```

## Lifetimes

### What are Lifetimes?

Lifetimes tell the compiler how long references should be valid. Rust doesn't have a garbage collector, so it uses lifetimes to track and enforce memory safety at compile time.

### Problem Without Lifetimes

```rust
fn get_str<'a>(x: &'a String) -> &'a str {
    x.as_str()
}
```

Rust needs to know:
- How long is the return value valid?
- Is it safe to return this reference?

### Lifetime Annotation Syntax

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

- `'a` is a lifetime parameter
- `'a` means both `x` and `y` must live at least as long as `'a`

### Structs with Lifetimes

```rust
struct Excerpt<'a> {
    part: &'a str,
}
```

### Lifetime Elision (Automatic Inference)

Rust can often infer lifetimes. Here's a rule of thumb:

```rust
fn name(x: &str) -> &str {
    x
}
```

This works because there's a 1-to-1 input → output reference relationship. However, for multiple inputs, you may need to explicitly annotate lifetimes.

### The 'static Lifetime

`'static` means the reference lives for the entire duration of the program. Common with string literals:

```rust
let s: &'static str = "I live forever!";
```

## Putting It All Together

Here's an example combining generics, traits, and lifetimes:

```rust
trait Describe {
    fn describe(&self) -> String;
}

struct Person<'a> {
    name: &'a str,
}

impl<'a> Describe for Person<'a> {
    fn describe(&self) -> String {
        format!("Person named {}", self.name)
    }
}

fn print_description<T: Describe>(item: T) {
    println!("{}", item.describe());
}
```

## Summary

| Concept   | Purpose                           | Syntax Example                              |
|-----------|-----------------------------------|---------------------------------------------|
| Generics  | Reusable code over types          | `fn add<T>(a: T, b: T)`                     |
| Traits    | Shared behavior & polymorphism    | `trait Speak { fn speak(&self); }`          |
| Lifetimes | Memory safety for references      | `fn longest<'a>(x: &'a str, y: &'a str)`   |

## Tips for Learning

- Use generics to reduce code duplication
- Use traits for polymorphic behavior
- Use lifetimes to handle references safely
- If it gets confusing, use concrete types first, then generalize
- Let the compiler be your friend — Rust will guide you with helpful errors
# Rust Data Types — Explained for Students

In Rust, every value has a type, and the compiler uses that to:

- Know how much memory to allocate
- Know what operations are allowed
- Keep your code safe and fast

Rust divides its data types into two main categories:

1. **Scalar Types** → hold a single value
2. **Compound Types** → group multiple values

## 1. Scalar Types (Single Value)

These are the building blocks. They store just one thing, like a number or character.

| Type | Example | What It Stores |
|------|---------|----------------|
| i32 | -42 | Signed integer (4 bytes) |
| u64 | 42 | Unsigned integer (8 bytes) |
| f32, f64 | 3.14 | Floating-point numbers |
| bool | true, false | Boolean values |
| char | 'A', '🐍' | A single Unicode character |

### Integer Types (signed & unsigned)

| Type | Size | Signed? |
|------|------|---------|
| i8 / u8 | 1 byte | Yes / No |
| i16 / u16 | 2 bytes | Yes / No |
| i32 / u32 | 4 bytes | Yes / No |
| i64 / u64 | 8 bytes | Yes / No |
| i128/ u128 | 16 bytes | Yes / No |
| isize/usize | pointer size | Yes / No |

**Tip:** Use i32 and f64 by default — they're efficient and safe.

### Example:

```rust
fn main() {
    let age: u32 = 25;
    let pi: f64 = 3.1415;
    let is_rust_fun: bool = true;
    let letter: char = 'R';

    println!("Age: {}, Pi: {}, Fun: {}, Letter: {}", age, pi, is_rust_fun, letter);
}
```

## 2. Compound Types (Grouped Values)

These types hold more than one value, usually of different kinds.

### Tuple

Fixed-size group of different types.

```rust
let person: (String, u8, bool) = ("Alice".to_string(), 30, true);
let (name, age, is_happy) = person;
println!("{} is {} and happy? {}", name, age, is_happy);
```

Access by index:

```rust
println!("{}", person.0); // "Alice"
```

### Array

Fixed-size collection of the same type.

```rust
let scores: [i32; 3] = [90, 85, 78];
println!("First score: {}", scores[0]);
```

Arrays are useful when you know the size at compile time.

### Slice

A view into a part of an array or vector.

```rust
let slice = &scores[0..2]; // refers to [90, 85]
```

## Other Important Types

### String Types

| Type | Description |
|------|-------------|
| &str | String slice (borrowed, fixed) |
| String | Heap-allocated, growable |

```rust
let name: &str = "Bob";
let full_name: String = String::from("Bob Rustacean");
```

### Structs (custom data types)

```rust
struct Person {
    name: String,
    age: u8,
}

let bob = Person {
    name: "Bob".to_string(),
    age: 28,
};
```

### Enums

Used to represent one of many options:

```rust
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

let dir = Direction::Up;
```

## Type Inference & Annotations

Rust can infer types:

```rust
let x = 42; // inferred as i32
let pi = 3.14; // inferred as f64
```

You can also explicitly annotate:

```rust
let name: &str = "Alice";
```

## Ownership & Types

Rust links types to its powerful ownership system. For example:

```rust
let name = String::from("Alice");
let name2 = name; // name is moved!

// println!("{}", name); // ❌ will not compile
```

## Summary Table

| Category | Type | Purpose |
|----------|------|---------|
| Scalar | i32, u64 | Integers (signed/unsigned) |
| Scalar | f64 | Floating-point numbers |
| Scalar | bool | true / false |
| Scalar | char | Unicode characters like 'A', '❤' |
| Compound | tuple | Mixed fixed-size collection |
| Compound | array | Fixed-size same-type collection |
| Compound | slice | Reference to part of an array |
| String | String, &str | Text types (heap vs. slice) |
| Custom | struct | Custom structured types |
| Custom | enum | Define types with multiple possible forms |

## Want to Practice?

Try writing functions that:

- Take a tuple and return a greeting
- Work with an array of scores
- Accept and return strings
- Define a struct for Student
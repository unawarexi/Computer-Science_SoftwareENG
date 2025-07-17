# Rust Error Handling: `panic!`, `Result`, and Best Practices

Rust offers powerful tools for handling errors safely and predictably. In this guide, you'll learn about:

- Why Rust has two types of errors
- What `panic!` does and when to use it
- How `Result` works and why it's preferred
- When to panic and when to handle errors gracefully
- How to create your own errors

## What Is Error Handling?

In any programming language, errors can happen:
- A file might not exist
- A network might be down
- A user might input invalid data

Rust divides errors into **two categories**:

1. **Recoverable Errors** — These are expected and can be handled. (`Result`)
2. **Unrecoverable Errors** — These indicate bugs or critical issues. (`panic!`)

## `panic!` — Unrecoverable Errors

A `panic!` **crashes your program immediately** and prints an error message. It's Rust's way of saying:

> "Something went terribly wrong and I can't recover from this."

### Example:
```rust
fn main() {
    panic!("Oh no! This is a critical error!");
}
```

### When to use `panic!`:
- You're writing a prototype or a quick script
- You encounter a bug that should never happen
- You're in test code and want to fail fast
- An invariant is broken (e.g., index out of bounds)

### Avoid `panic!`:
- In production code for expected errors (e.g., file not found)
- In library code (you don't want to crash other people's apps)

## `Result<T, E>` — Recoverable Errors

Rust's Result enum is defined as:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

- `Ok(T)` means success
- `Err(E)` means failure

### Example: Reading a file
```rust
use std::fs::File;

fn main() {
    let file_result = File::open("config.txt");

    match file_result {
        Ok(file) => {
            println!("File opened successfully!");
            // Use the file
        },
        Err(e) => {
            println!("Error opening file: {:?}", e);
            // Maybe retry or exit gracefully
        }
    }
}
```

## Error Handling Shortcuts

### `.unwrap()` and `.expect()`
These are quick-and-dirty ways to get the value or panic:

```rust
let file = File::open("config.txt").unwrap(); // panics on error
let file = File::open("config.txt").expect("Failed to open config file");
```

**Use in:**
- Demos
- Prototypes
- Controlled environments

**Avoid in:**
- Production code

### Propagating Errors with `?`
Instead of nesting multiple match statements, Rust allows you to bubble up errors:

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_config() -> Result<String, io::Error> {
    let mut file = File::open("config.txt")?; // if this fails, return Err
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}
```

The `?` operator:
- Returns early if there's an `Err`
- Unwraps the `Ok` automatically

## Creating Your Own Error Types

```rust
use std::fmt;

#[derive(Debug)]
enum MyError {
    NotFound,
    InvalidInput,
}

impl fmt::Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MyError::NotFound => write!(f, "Item not found"),
            MyError::InvalidInput => write!(f, "Invalid input"),
        }
    }
}
```

Now you can return `Result<T, MyError>` from your functions.

## When to Panic vs. When to Use Result

| Situation | Use Result | Use `panic!` |
|-----------|------------|--------------|
| File not found | Yes | No |
| Invalid index (bug in code) | No | Yes |
| User inputs wrong format | Yes | No |
| Critical assumption broken | No | Yes |
| Writing library code | Yes | No |
| Temporary script/debugging | No | Yes |

## Summary

| Feature | Purpose | Best For |
|---------|---------|----------|
| `panic!()` | Crash immediately | Unrecoverable, logic bugs |
| `Result` | Handle errors gracefully | File I/O, parsing, network, etc. |
| `.unwrap()` | Crash if Err | Prototyping or guaranteed success |
| `?` | Propagate errors automatically | Clean error bubbling in functions |

## Final Advice

- Prefer `Result` over `panic!` unless you're sure the error is unrecoverable
- Use `.expect()` and `.unwrap()` sparingly
- Handle errors explicitly in critical applications
- Make your own error types to better describe what went wrong

## Resources

- [Rust Book - Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
- [Rust API Documentation](https://doc.rust-lang.org/std/)
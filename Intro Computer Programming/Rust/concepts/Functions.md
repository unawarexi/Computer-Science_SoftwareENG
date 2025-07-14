# Rust Functions — A Beginner's Guide

Functions in Rust are the **building blocks** of programs. They let you organize logic into **reusable**, **clean**, and **testable** pieces of code.

## What Is a Function?

A **function** is a reusable block of code that performs a task.

In Rust, every function starts with the keyword `fn`.

## Basic Function Syntax

```rust
fn function_name() {
    // code goes here
}
```

### Example:

```rust
fn greet() {
    println!("Hello, Rust!");
}
```

Call it like this:

```rust
fn main() {
    greet();
}
```

## Functions with Parameters

You can pass values into functions using parameters:

```rust
fn greet(name: &str) {
    println!("Hello, {}!", name);
}
```

Call it:

```rust
greet("Alice");
```

## Functions That Return Values

Use `->` to declare the return type.

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b  // no semicolon here! (returns this value)
}
```

**Warning:** If you add a semicolon, it becomes a statement, not a return value.

Call it like:

```rust
let result = add(5, 3); // result = 8
```

## Returning Early with return

```rust
fn is_even(n: i32) -> bool {
    if n % 2 == 0 {
        return true;
    }

    false
}
```

You can use `return` early or rely on the last expression.

## Function Naming Convention

- Use snake_case (`my_function`)
- Function names should be descriptive
- Keep them short and clear

## Function with Multiple Parameters

```rust
fn print_user(name: &str, age: u8) {
    println!("{} is {} years old", name, age);
}
```

## Function with No Parameters and No Return

```rust
fn splash_screen() {
    println!("Welcome to the Rust App!");
}
```

## Main Function — The Entry Point

Every Rust program starts from:

```rust
fn main() {
    // your program begins here
}
```

## Function Summary Table

| Feature | Example | Description |
|---------|---------|-------------|
| Basic function | `fn greet() {}` | No parameters or return |
| With parameters | `fn add(a: i32, b: i32) -> i32 {}` | Accepts values |
| Return value | `-> i32` | Type after `->` is the return type |
| No return value | `fn print() {}` or `-> ()` | Default return is unit `()` |
| With return early | `return value;` | Exits immediately |
| Last expression | `a + b` (no `;`) | Rust returns last line automatically |

## Why Functions Matter

- Reuse code
- Improve readability
- Make testing easier
- Organize large codebases

## Practice Time

Try writing these:

1. A function that multiplies two numbers
2. A function that returns the bigger of two values
3. A function that checks if a number is prime
4. A function that prints a welcome message with a name

## More Resources

- Rust Book — Functions
- Rust Playground to test code live
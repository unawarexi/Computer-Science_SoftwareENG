# Rust Operators – A Complete Guide

Operators in Rust are **symbols or keywords** used to perform operations on values and variables — like math, comparison, or logic.

This guide covers:

- Arithmetic Operators
- Comparison Operators
- Logical Operators
- Assignment Operators
- Bitwise Operators
- Other Special Operators

---

## 1. Arithmetic Operators

Used to do math with numbers.

| Operator | Description        | Example      | Result |
|----------|--------------------|--------------|--------|
| `+`      | Addition            | `5 + 3`      | `8`    |
| `-`      | Subtraction         | `5 - 3`      | `2`    |
| `*`      | Multiplication      | `5 * 3`      | `15`   |
| `/`      | Division            | `10 / 2`     | `5`    |
| `%`      | Remainder (modulo)  | `10 % 3`     | `1`    |

```rust
fn main() {
    let sum = 4 + 5;
    let product = 3 * 3;
    println!("Sum: {}, Product: {}", sum, product);
}
```

## 2. Comparison Operators

Used to compare two values. Always returns a bool (true or false).

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | Equal to | `5 == 5` | `true` |
| `!=` | Not equal to | `5 != 4` | `true` |
| `>` | Greater than | `5 > 3` | `true` |
| `<` | Less than | `3 < 5` | `true` |
| `>=` | Greater than or equal | `5 >= 5` | `true` |
| `<=` | Less than or equal | `4 <= 5` | `true` |

```rust
fn main() {
    let age = 18;
    println!("Is adult? {}", age >= 18);
}
```

## 3. Logical Operators

Used to combine boolean expressions.

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `&&` | AND | `true && false` | `false` |
| `\|\|` | OR | `true \|\| false` | `true` |
| `!` | NOT | `!true` | `false` |

```rust
fn main() {
    let logged_in = true;
    let has_permission = false;

    if logged_in && has_permission {
        println!("Access granted!");
    } else {
        println!("Access denied.");
    }
}
```

## 4. Assignment Operators

Used to assign and update values.

| Operator | Meaning | Example | Equivalent |
|----------|---------|---------|------------|
| `=` | Assignment | `let x = 5;` | Set value |
| `+=` | Add & assign | `x += 2` | `x = x + 2` |
| `-=` | Subtract & assign | `x -= 1` | `x = x - 1` |
| `*=` | Multiply & assign | `x *= 2` | `x = x * 2` |
| `/=` | Divide & assign | `x /= 2` | `x = x / 2` |
| `%=` | Modulo & assign | `x %= 3` | `x = x % 3` |

## 5. Bitwise Operators (Advanced)

Used for low-level operations on binary data.

| Operator | Meaning | Example | Description |
|----------|---------|---------|-------------|
| `&` | Bitwise AND | `a & b` | Both bits must be 1 |
| `\|` | Bitwise OR | `a \| b` | At least one bit is 1 |
| `^` | Bitwise XOR | `a ^ b` | One bit is 1 only |
| `<<` | Left shift | `a << 2` | Shift bits left |
| `>>` | Right shift | `a >> 1` | Shift bits right |

## 6. Other Operators

### `as` – Type Casting

```rust
let x = 5;
let y = x as f64; // cast to float
```

### `..` and `..=` – Ranges

```rust
for i in 1..5 { // 1 to 4
    println!("{}", i);
}

for i in 1..=5 { // 1 to 5
    println!("{}", i);
}
```

## Operator Precedence

Operators are evaluated in a specific order (just like math):

1. Arithmetic: `*` `/` `%` before `+` `-`
2. Comparison: `==`, `!=`, `>`, `<`
3. Logical: `!` then `&&` then `||`

You can use parentheses `()` to control order:

```rust
let result = (5 + 2) * 3; // = 21
```

## Summary Table

| Category | Examples | Used For |
|----------|----------|----------|
| Arithmetic | `+`, `-`, `*`, `/`, `%` | Math operations |
| Comparison | `==`, `!=`, `>`, `<` | Checking equality or order |
| Logical | `&&`, `\|\|`, `!` | Boolean logic |
| Assignment | `=`, `+=`, `*=` | Updating variables |
| Bitwise | `&`, `\|`, `<<`, `>>` | Binary operations |
| Casting | `as` | Type conversions |
| Ranges | `..`, `..=` | Iteration or slicing |

## Practice Exercises

1. Write a program that checks if a number is even or odd.
2. Use logical operators to simulate user authentication.
3. Practice arithmetic by building a basic calculator.
4. Use a for loop with `..=` to sum numbers 1 to 100.

## Resources

- [The Rust Book - Operators and Control Flow](https://doc.rust-lang.org/book/ch03-05-control-flow.html)
- [Rust Playground](https://play.rust-lang.org/)
- [Rust Reference on Operators](https://doc.rust-lang.org/reference/expressions.html#expression-precedence)
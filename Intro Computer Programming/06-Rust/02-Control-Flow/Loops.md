# Rust Loops & Control Flow — Explained for Students

In Rust, **loops and control flow** allow you to repeat actions, iterate over data, and make decisions in your program.

This guide covers:

- `loop`
- `while`
- `for`
- `break`, `continue`
- Nested loops
- Loop labels

---

## 1. `loop` — Infinite Loop

A `loop` runs forever unless you explicitly `break` out of it.

```rust
fn main() {
    let mut counter = 0;

    loop {
        println!("Count: {}", counter);
        counter += 1;

        if counter == 3 {
            break; // Exit loop
        }
    }
}
```

**Use loop when:**
- You want to loop until something happens
- You don't know how many times to loop in advance

## 2. `while` Loop — Condition-based

`while` loops as long as a condition is true.

```rust
fn main() {
    let mut number = 5;

    while number > 0 {
        println!("Countdown: {}", number);
        number -= 1;
    }

    println!("Liftoff!");
}
```

**Use while when:**
- You want to loop based on a changing condition
- You might not loop at all

## 3. `for` Loop — Iteration

`for` loops over collections, arrays, ranges, etc.

```rust
fn main() {
    let nums = [10, 20, 30];

    for num in nums {
        println!("Number: {}", num);
    }
}
```

Using a range:

```rust
for i in 1..5 {
    println!("i: {}", i); // 1 to 4 (exclusive)
}
```

```rust
for i in 1..=5 {
    println!("i: {}", i); // 1 to 5 (inclusive)
}
```

**Use for when:**
- You know how many items to iterate through
- You want to loop through arrays, ranges, or collections

## 4. `break` and `continue`

### `break`: Stops the loop completely

```rust
for i in 0..10 {
    if i == 5 {
        break;
    }
    println!("i = {}", i);
}
```

### `continue`: Skips to the next iteration

```rust
for i in 0..5 {
    if i == 2 {
        continue;
    }
    println!("i = {}", i);
}
```

## 5. Loop with a Return Value

You can use `loop` to return a value:

```rust
fn main() {
    let mut count = 0;

    let result = loop {
        count += 1;
        if count == 5 {
            break count * 2; // Returns 10
        }
    };

    println!("Result: {}", result);
}
```

## 6. Labeled Loops (For Nested Loops)

Use loop labels to break or continue outer loops:

```rust
fn main() {
    'outer: for i in 1..=3 {
        for j in 1..=3 {
            if i == 2 && j == 2 {
                break 'outer; // Exit both loops
            }
            println!("i: {}, j: {}", i, j);
        }
    }
}
```

## Summary Table

| Loop Type | Syntax | Best Used When... |
|-----------|--------|-------------------|
| `loop` | `loop { ... }` | You want an infinite loop or manual exit |
| `while` | `while condition` | You loop while a condition is true |
| `for` | `for item in items` | You loop over data or range |
| `break` | inside any loop | To exit the loop |
| `continue` | inside any loop | To skip to the next iteration |
| Labeled | `'label: loop` | Exiting nested loops |

## Practice Ideas

1. Loop from 1 to 10 and print even numbers
2. Use a while loop to guess a random number
3. Use a for loop to iterate through a string's characters
4. Create a loop that asks the user for input until they type "exit"

## Resources

- [The Rust Book - Loops](https://doc.rust-lang.org/book/ch03-05-control-flow.html#repetition-with-loops)
- [Rust by Example - Loops](https://doc.rust-lang.org/rust-by-example/flow_control/loop.html)
- [Rust Playground](https://play.rust-lang.org/)
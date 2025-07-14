# 🦀 `match` in Rust — Pattern Matching Explained for Students

The `match` keyword in Rust is one of the most powerful and expressive tools for **control flow** and **pattern matching**. It works like a **supercharged switch statement** from other languages — but **safer and more flexible**.

---

## 📦 What Is `match`?

> `match` lets you compare a value against a series of patterns and execute code based on which pattern matches.

### Basic Syntax

```rust
match value {
    pattern1 => expression1,
    pattern2 => expression2,
    _ => default_expression,
}
🔹 Example: Match a Number
rust
Copy
Edit
fn main() {
    let number = 3;

    match number {
        1 => println!("One!"),
        2 => println!("Two!"),
        3 => println!("Three!"),
        _ => println!("Something else!"),
    }
}
number is matched against different cases.

_ is the catch-all pattern (like else).

✅ Match Is Exhaustive
You must handle all possible cases. If not, the compiler will throw an error.

This is what makes Rust safe. You can’t “forget” a case.

🔄 Matching Multiple Patterns
rust
Copy
Edit
fn main() {
    let day = "Sat";

    match day {
        "Sat" | "Sun" => println!("Weekend!"),
        "Mon" => println!("Back to work."),
        _ => println!("Just another day."),
    }
}
| means "or". This handles multiple patterns in one arm.

🧾 Matching Ranges
rust
Copy
Edit
fn main() {
    let age = 16;

    match age {
        0..=12 => println!("Child"),
        13..=19 => println!("Teenager"),
        _ => println!("Adult"),
    }
}
..= is an inclusive range.

Great for handling numeric ranges.

🔐 Match with Enums
This is where match really shines in Rust.

rust
Copy
Edit
enum Direction {
    North,
    South,
    East,
    West,
}

fn main() {
    let dir = Direction::North;

    match dir {
        Direction::North => println!("Up!"),
        Direction::South => println!("Down!"),
        Direction::East => println!("Right!"),
        Direction::West => println!("Left!"),
    }
}
🧰 Match and Binding with Option<T>
Rust doesn't have null. Instead, it uses Option.

rust
Copy
Edit
fn main() {
    let name: Option<String> = Some(String::from("Rust"));

    match name {
        Some(n) => println!("Name is: {}", n),
        None => println!("No name provided."),
    }
}
Option<T> is either Some(value) or None.

✂️ Destructuring in Match
You can extract values using pattern matching:

rust
Copy
Edit
enum Message {
    Hello(String),
    Quit,
}

fn main() {
    let msg = Message::Hello(String::from("Rust"));

    match msg {
        Message::Hello(name) => println!("Hello, {}", name),
        Message::Quit => println!("Quit message"),
    }
}
🔁 Match as an Expression (Return Values)
You can return a value from match:

rust
Copy
Edit
fn get_grade(score: u8) -> &'static str {
    match score {
        90..=100 => "A",
        80..=89 => "B",
        70..=79 => "C",
        _ => "F",
    }
}
❓ Match Guards (if in match)
Use if in a pattern for extra conditions:

rust
Copy
Edit
let number = 7;

match number {
    x if x % 2 == 0 => println!("Even"),
    _ => println!("Odd"),
}
🧠 Summary Table
Feature	Syntax	Use Case
Basic Match	match x { 1 => ..., _ => ... }	Control flow by value
Multiple Patterns	`1	2 => ...`
Ranges	1..=10 => ...	Match numeric ranges
Enums	Some(x) => ...	Handle enum variants
Destructuring	Some(value)	Extract values
Guards	x if x > 5 => ...	Add conditions to patterns
Return Value	let result = match ...	Match as an expression


## 🧩 Bonus: `if let` and `let else` — Cleaner Control Flow in Rust

Rust provides some **shortcut syntax** for matching values when `match` would be too verbose. These are especially helpful when you only care about **one specific case**.

---

### 🔍 `if let` – Focused Pattern Matching

```rust
let some_value = Some(5);

if let Some(x) = some_value {
    println!("Found a value: {}", x);
}
✅ Why use if let?
It's cleaner than match when you only care about one pattern.

It ignores all other cases by default.

rust
Copy
Edit
// Instead of this full match:
match some_value {
    Some(x) => println!("Found: {}", x),
    None => (), // Must write this even if we don’t care
}

// Use this:
if let Some(x) = some_value {
    println!("Found: {}", x);
}
💬 Optional else with if let
rust
Copy
Edit
if let Some(x) = some_value {
    println!("Value: {}", x);
} else {
    println!("No value found");
}
You can still handle the fallback using else.

⛔ if let Limitation
It only matches one specific pattern. If you want to match multiple or different patterns, use match.

🔐 let else – Early Exit if Pattern Doesn’t Match
Rust 1.65+ introduced let else to early return or exit when a pattern doesn’t match.

rust
Copy
Edit
fn get_username(id: Option<String>) {
    let Some(name) = id else {
        println!("No username provided!");
        return;
    };

    println!("Hello, {}!", name);
}
✅ Why use let else?
It's great for early exits (like return, break, or panic!) when a pattern fails to match.

Prevents unnecessary nesting.

🧠 When to Use What?
Use Case	Syntax	Benefit
Matching one pattern	if let	Clean and concise
Early return on failed pattern	let else	Avoids deep nesting
Full pattern matching	match	Exhaustive and flexible

🧪 Practice Task Ideas
Use if let to extract a value from Option<i32>.

Use let else in a function to return early if input is None.

Rewrite a match block into if let where appropriate.



✅ Practice Ideas
Match Option<i32> to handle user input

Write a function that returns a grade using match

Handle an enum with multiple variants

Use match with tuples: match (x, y)



📚 Resources
📖 Rust Book: Match

📘 Enums & Pattern Matching

🧪 Rust Playground

💬 TL;DR
match is like a smarter, safer switch that:

Requires you to cover every possible case

Supports pattern matching, destructuring, guards, and more

Works great with enums and Option/Result types

Understanding match is key to idiomatic Rust!


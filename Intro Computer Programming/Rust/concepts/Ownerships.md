# Rust Ownership — The Core of Memory Safety

Rust's most important feature is **ownership**. It's how Rust guarantees **memory safety without a garbage collector**.

If you understand ownership, you'll understand **why Rust is fast, safe, and strict** about how you use memory.

---

## What Is Ownership?

> In Rust, every value has a **single owner** — a variable that controls it.  
> When that owner goes out of scope, the value is **automatically dropped** (freed).

---

## Ownership Rules

1. **Each value has one owner**.
2. **A value can only have one owner at a time**.
3. **When the owner goes out of scope, the value is dropped**.

---

## Example: Ownership in Action

```rust
fn main() {
    let name = String::from("Rust");

    println!("{}", name); // ✅ name owns the String
}
```

`name` owns the String.

When `main()` ends, `name` goes out of scope → memory is freed.

## Moving Ownership

If you assign a variable to another, ownership moves (not copied by default):

```rust
fn main() {
    let name1 = String::from("Rust");
    let name2 = name1;

    // println!("{}", name1); ❌ Error! name1 was moved to name2
    println!("{}", name2); // ✅
}
```

**Note:** Strings (and other heap data) are moved, not copied.

## Cloning (If You Want Two Owners)

Use `.clone()` to create a deep copy (new memory allocation):

```rust
fn main() {
    let name1 = String::from("Rust");
    let name2 = name1.clone();

    println!("{} and {}", name1, name2); // ✅ Both are valid
}
```

## Copy Types (Like Numbers)

Some types are Copy — they don't move ownership:

```rust
fn main() {
    let x = 5;
    let y = x;

    println!("x = {}, y = {}", x, y); // ✅ Both valid
}
```

These include:

- Integers (`i32`, `u64`, etc.)
- Floats (`f32`, `f64`)
- Booleans
- `char`
- Tuples of only Copy types (e.g., `(i32, i32)`)

## Ownership in Functions

Passing a value moves ownership into the function:

```rust
fn print_name(name: String) {
    println!("{}", name);
}

fn main() {
    let name = String::from("Rust");
    print_name(name);
    // println!("{}", name); ❌ name is moved
}
```

## Returning Ownership from Functions

You can return ownership from a function:

```rust
fn give_name() -> String {
    String::from("Rustacean")
}

fn main() {
    let name = give_name();
    println!("{}", name);
}
```

## Borrowing: References (&)

Instead of moving, you can borrow a value using a reference:

```rust
fn print_name(name: &String) {
    println!("{}", name);
}

fn main() {
    let name = String::from("Rust");
    print_name(&name); // Pass reference
    println!("{}", name); // ✅ Still valid
}
```

This is called borrowing — it lets you read without taking ownership.

## Mutable Borrowing

You can mutably borrow a value if you want to modify it:

```rust
fn change(name: &mut String) {
    name.push_str(" is awesome!");
}

fn main() {
    let mut name = String::from("Rust");
    change(&mut name);
    println!("{}", name);
}
```

**Important:** You can only have one mutable reference at a time.

## Rules of References

Rust enforces:

- **Many immutable references:** `&x`, `&x`, `&x` — OK
- **Mutable + immutable at the same time** — Not allowed
- **Only one mutable reference:** `&mut x`

This prevents data races at compile time.

## Ownership Summary Table

| Concept | Description | Example |
|---------|-------------|---------|
| Ownership | One owner per value | `let a = String::from("hi");` |
| Move | Value passed → previous owner invalid | `let b = a;` |
| Clone | Deep copy (new memory) | `let b = a.clone();` |
| Copy | Primitive types copied | `let y = x;` for `i32`, `bool`, etc. |
| Borrowing (`&T`) | Read without taking ownership | `fn read(x: &String)` |
| Mut borrow (`&mut`) | Modify through reference | `fn edit(x: &mut String)` |

## Practice Tasks

1. Try moving and cloning strings.
2. Write a function that borrows a value and prints it.
3. Write a function that takes a mutable reference and updates a string.
4. Use references safely with multiple variables.

## Resources

- [The Rust Book - Understanding Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
- [Rust Playground](https://play.rust-lang.org/)
- [Rust by Example - Ownership and Moves](https://doc.rust-lang.org/rust-by-example/scope/move.html)
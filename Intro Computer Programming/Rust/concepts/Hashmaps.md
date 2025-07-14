# 📦 Rust HashMaps: A Complete Student-Friendly Guide

A `HashMap` in Rust is a powerful collection type that allows you to store data as **key-value pairs**. It's similar to dictionaries in Python or objects in JavaScript.

---

## 🧠 Why Use a HashMap?

* Fast **lookup**, **insertion**, and **removal**
* Ideal for situations where each value is associated with a unique key
* Stores data **without any guaranteed order**

---

## 🛠 Importing and Creating a HashMap

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert("Alice", 50);
    scores.insert("Bob", 60);

    println!("{:?}", scores);
}
```

---

## 📦 Basic Operations

### ✅ Inserting

```rust
map.insert("key", value);
```

### ✅ Accessing

```rust
if let Some(score) = map.get("Alice") {
    println!("Alice's score is {}", score);
}
```

### ✅ Iterating

```rust
for (key, value) in &map {
    println!("{}: {}", key, value);
}
```

### ✅ Removing

```rust
map.remove("Alice");
```

---

## 🔐 Ownership Rules

Rust enforces ownership even inside a HashMap:

```rust
let key = String::from("name");
let value = String::from("Bob");
map.insert(key, value); // key and value are moved here
```

To retain ownership, use references:

```rust
map.insert(&key, &value);
```

---

## 🔧 Common Methods

| Method                      | What It Does                           |
| --------------------------- | -------------------------------------- |
| `insert(key, val)`          | Inserts a key-value pair               |
| `get(&key)`                 | Returns an `Option<&value>`            |
| `contains_key(&key)`        | Checks if a key exists                 |
| `remove(&key)`              | Removes the key-value pair             |
| `entry(key).or_insert(val)` | Inserts a value only if key is missing |

---

## 🧪 Entry API

The `entry` API is powerful for updating values safely:

```rust
let mut scores = HashMap::new();
scores.entry("Alice").or_insert(0);

if let Some(score) = scores.get_mut("Alice") {
    *score += 10;
}
```

---

## ⚠️ Common Pitfalls

* Keys must be **unique** — inserting a key that already exists will overwrite the value.
* A HashMap **does not maintain order**.
* Values are **moved** unless you clone or reference them.

---

## 📦 Helpful Crates

| Crate      | Purpose                                |
| ---------- | -------------------------------------- |
| `indexmap` | HashMap that maintains insertion order |
| `dashmap`  | Thread-safe concurrent HashMap         |

---

## ✅ When to Use HashMaps

* You need to **associate values with unique keys**.
* Fast data **retrieval** by key is important.
* Order doesn't matter (or use `indexmap` if it does).

---

## 👨‍🏫 Summary

* `HashMap<K, V>` lets you store key-value data.
* You must `use std::collections::HashMap` to use it.
* Respect ownership when inserting data.
* The `entry()` API is great for updating or initializing values.

Rust HashMaps give you power and speed — while still enforcing safety!

---

Let me know if you'd like a quiz, mini-project, or challenge to go with this! 🚀

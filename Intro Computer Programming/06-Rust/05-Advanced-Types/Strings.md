# 📚 Rust Strings: Everything You Need to Know

Rust treats strings with precision, safety, and flexibility. To master strings in Rust, it's important to understand not just what a string is, but how it's represented under the hood.

---

## 🧵 Types of Strings in Rust

| Type     | Description                                      |
| -------- | ------------------------------------------------ |
| `String` | Growable, heap-allocated string (UTF-8 encoded)  |
| `&str`   | String slice; an immutable reference to a string |

```rust
let s1: String = String::from("Hello");
let s2: &str = "World"; // string literal
```

---

## 🧠 What is UTF-8?

Rust strings are **UTF-8 encoded**, meaning:

* Each character may take **1 to 4 bytes**.
* It can represent **any Unicode character**.
* Encoding is efficient for ASCII, but powerful for all scripts.

```rust
let emoji = "🚀"; // takes 4 bytes
let ascii = "A";  // takes 1 byte
```

---

## 🔡 Unicode, Scalars, Graphemes & Bytes

### 1. **Bytes**

The smallest unit of memory, each character in a Rust string is made up of **bytes**.

```rust
let s = "hello";
println!("Bytes: {:?}", s.as_bytes());
```

### 2. **Unicode Scalar Values**

A Unicode scalar is any code point except surrogate pairs (range: `U+0000` to `U+D7FF`, `U+E000` to `U+10FFFF`). Each `char` in Rust is a Unicode scalar:

```rust
let ch: char = 'é';
println!("Unicode scalar: {}", ch);
```

### 3. **Grapheme Clusters**

What **users perceive as a character** — can be made up of multiple Unicode scalars.

```rust
use unicode_segmentation::UnicodeSegmentation;
let text = "é"; // 'e' + accent = é
for grapheme in text.graphemes(true) {
    println!("Grapheme: {}", grapheme);
}
```

> 🔸 Graphemes matter when you're doing string slicing or character counts with non-English text.

---

## ✂️ String Slicing

Rust prevents invalid slicing that could break UTF-8 encoding:

```rust
let hello = "Здравствуйте";
let slice = &hello[0..4]; // ✅ valid (UTF-8 aligned)
// let bad = &hello[0..1]; // ❌ panic at runtime!
```

---

## 🔧 Common String Methods

```rust
let mut s = String::from("hello");
s.push('!');
s.push_str(" world");
let len = s.len();
let contains = s.contains("world");
```

| Method           | Description                             |
| ---------------- | --------------------------------------- |
| `push(char)`     | Add one character                       |
| `push_str(&str)` | Add string slice                        |
| `len()`          | Get byte length                         |
| `chars()`        | Iterate Unicode scalars                 |
| `bytes()`        | Iterate raw bytes                       |
| `graphemes()`    | Iterate visible characters (with crate) |

---

## 🪓 String vs \&str: When to Use What?

| Use `String`       | Use `&str`          |
| ------------------ | ------------------- |
| You need ownership | Borrowing is enough |
| Modify the string  | Read-only access    |

---

## 📦 Extra: Crates for String Handling

| Crate                  | Purpose                              |
| ---------------------- | ------------------------------------ |
| `unicode-segmentation` | Handles graphemes, words, sentences  |
| `regex`                | Powerful regular expressions         |
| `unidecode`            | ASCII transliteration (e.g., é -> e) |

---

## 🚨 Common Pitfalls

* ❌ Trying to index a string directly (`s[0]`) — use `.chars().nth()`
* ❌ Invalid UTF-8 slicing
* ❌ Confusing byte length with character count

---

## ✅ Best Practices

* Use `&str` for read-only function arguments.
* Use `String` when you need dynamic, mutable strings.
* Use `.chars()` or `unicode-segmentation` for user-visible characters.

---

## 🧪 Example

```rust
fn greet(name: &str) {
    println!("Hello, {}!", name);
}

fn main() {
    let name = String::from("🌍 Alice");
    greet(&name);
}
```

---

This should give students a complete and clear view of how Rust handles strings — from memory and encoding, to best practices and user-visible behaviors.

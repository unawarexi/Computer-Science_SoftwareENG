# 03: Control Structures in Go

Welcome to the guide on Control Structures in Go! Control structures are the fundamental building blocks of any program, allowing you to dictate the flow of execution based on conditions or to repeat actions.

Go’s approach to control structures is intentionally minimalist and clean. It removes unnecessary clutter (like parentheses around conditions) and eliminates redundant keywords (like `while`), making the language highly readable.

Below are detailed, easy-to-understand explanations of the core control structures in Go: **If/Else**, **Switch**, and **Loops**.

---

## 1. If / Else Statements

The `if` statement evaluates a boolean condition. If the condition is true, the block of code inside the statement executes. If you want a fallback behavior when the condition is false, you can chain an `else` block or an `else if` block.

### Key Characteristics in Go:

- **No Parentheses Required & Mandatory Braces:** Unlike C, Java, or JavaScript, you do not need to wrap your conditions in parentheses `()`. However, Go absolutely requires the use of curly braces `{}`, even for a single line of code, to prevent indentation bugs.

  ```go
  if age >= 18 {
      fmt.Println("Adult")
  }
  ```

- **Initialization Statement:** Go introduces a powerful feature where you can declare and initialize a variable right before the condition, separated by a semicolon `;`. This restricts the variable's scope to _only_ the `if` and `else` blocks.
  ```go
  if count := getCount(); count > 10 {
      fmt.Println("High count:", count)
  }
  ```

---

## 2. Switch Statements

A `switch` statement is an elegant alternative to writing a long, complex chain of `if-else` statements. You provide a variable or expression to the `switch`, and it evaluates it against a series of `case` values.

### Key Characteristics in Go:

- **No Automatic Fallthrough & Multiple Values:** In Go, once a matching case successfully executes, the switch block automatically terminates. You do not need to write `break`. You can also test multiple values in a single case using commas.

  ```go
  switch day {
  case "Saturday", "Sunday":
      fmt.Println("Weekend")
  default:
      fmt.Println("Weekday")
  }
  ```

  _(Note: If you actually want the logic to bleed into the next case, you must explicitly use the `fallthrough` keyword at the end of your case block)._

- **Switch without an Expression:** You can write a `switch` statement without passing any variable to it. It acts exactly like a clean chain of `if-else` statements.
  ```go
  switch {
  case score >= 90:
      fmt.Println("Grade: A")
  case score >= 80:
      fmt.Println("Grade: B")
  }
  ```

---

## 3. Loops (The `for` loop)

Here is one of the most distinctive features of Go: **The `for` loop is the only loop construct in the entire language.** There are no `while` loops, no `do-while` loops, and no `foreach` loops. Instead, Go’s `for` loop is incredibly versatile and acts as all of those depending on how you structure it.

### The Different Faces of the `for` Loop:

**1. The Traditional `for` Loop:**
Just like in other languages, you define a loop with three components: Initialization, Condition, and Post Statement.

```go
for i := 0; i < 5; i++ {
    fmt.Println(i)
}
```

**2. The "While" Loop:**
Because Go has no `while` keyword, you simulate a `while` loop by omitting the Initialization and Post statements. The loop runs as long as the condition remains true.

```go
count := 0
for count < 5 {
    count++
}
```

**3. The Infinite Loop:**
If you omit the condition entirely, it becomes an infinite loop. You must explicitly break out of it.

```go
for {
    fmt.Println("Running forever until manually stopped!")
    break // used to exit the loop
}
```

**4. The `range` Clause (The "ForEach" Loop):**
When you need to iterate over a collection (like a list or a dictionary), you use the `for` loop combined with `range`. It automatically provides you with the **index** and the **value**.

```go
names := []string{"Alice", "Bob"}
for index, name := range names {
    fmt.Println(index, name)
}
```

---

### Summary

Go's control structures are designed for maximum readability and safety. By removing parentheses, standardizing brace usage, eliminating automatic switch fallthroughs, and consolidating all looping behavior into a single, highly flexible `for` keyword, Go ensures that the flow of your program is predictable and easy to reason about.

# 04: Functions and Pointers in Go

Welcome to the guide on Functions and Pointers in Go! Functions allow you to encapsulate and reuse logic, while pointers give you direct control over memory, enabling efficient data manipulation.

Go handles both of these concepts in a straightforward, pragmatic way.

---

## 1. Functions

Functions in Go are defined using the `func` keyword. They can take parameters and return values. A unique and powerful feature of Go is its ability to return multiple values from a single function.

### Function Declarations

To declare a function, specify the name, parameters (with their types), and the return type. The return type comes _after_ the parameters.

```go
func add(x int, y int) int {
    return x + y
}
```

_Note: If consecutive parameters share the same type, you can omit the type from all but the last one (e.g., `x, y int`)._

### Multiple Return Values

Go natively supports returning multiple values from a function. This is frequently used for returning both a result and an error status, making error handling explicit and clean.

```go
func divide(a, b float64) (float64, error) {
    // Returns the result and a potential error
    return a / b, nil
}
```

### Ignoring Return Values

If a function returns multiple values but you only need some of them, you can use the **blank identifier** `_` to discard the unwanted values. This tells the Go compiler to ignore the unused variable, avoiding compilation errors.

```go
result, _ := divide(10.0, 2.0) // We only care about the result, ignoring the error
```

### Guard Clauses (Early Returns)

A common pattern in Go is using "guard clauses" to handle errors or invalid conditions at the top of a function. Instead of nesting your main logic inside an `if` block, you check for the error, return early if it exists, and keep your "happy path" unindented.

```go
func process(data string) error {
    if data == "" {
        return fmt.Errorf("empty data") // Guard clause
    }
    // Main logic here, no extra indentation
    return nil
}
```

### Named and Naked Return Values

You can name the return variables at the top of the function. This acts as a declaration, and calling `return` without arguments (a "naked" return) will return the current values of those named variables.

```go
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return // Returns x and y (naked return)
    // return x, y // (named return)
}
```

### Variadic Functions

A variadic function can accept a variable number of arguments of a specific type. You define this by using an ellipsis `...` before the type name of the last parameter.

```go
func sum(numbers ...int) int {
    // 'numbers' acts as a slice of ints
    return numbers[0] + numbers[1] // Example logic
}
```

### Callback Functions (Functions as Values)

In Go, functions are first-class citizens. This means you can treat them like any other value, allowing you to pass them as arguments to other functions to act as callbacks.

```go
func execute(callback func(string), message string) {
    callback(message)
}
```

---

## 2. Pointers

A pointer holds the memory address of a value rather than the value itself. By passing pointers, you can allow functions to mutate the original data, and you can avoid copying large data structures, leading to better performance.

### Memory Allocation (Stack vs Heap)

Go manages memory automatically using a garbage collector. Variables are typically allocated on the **stack** (which is fast and automatically cleaned up when a function returns). However, if you return a pointer to a local variable from a function, the Go compiler performs "escape analysis" and safely allocates that variable on the **heap** (so it survives after the function exits). You can also use the builtin `new()` function to explicitly allocate memory and get a pointer.

### The `&` and `*` Operators

- The **`&` (Address-of) operator** generates a pointer to its operand (i.e., it gets the memory address).
- The **`*` (Dereference) operator** denotes the pointer's underlying value. You use it to read or update the value at that address.

### Creating and Using Pointers

When you declare a pointer, its type is written as `*T`, meaning it points to a value of type `T`.

```go
var x int = 10
var p *int = &x // p now holds the memory address of x
```

You can read or modify the value stored at the memory address by using the `*` operator on the pointer.

```go
*p = 21         // Sets x to 21 through the pointer
fmt.Println(x)  // Outputs 21
```

### Pointers in Functions

By default, Go passes arguments by value (making a copy). If you want a function to modify the original variable, you must pass a pointer to it.

```go
func increment(val *int) {
    *val++ // Modifies the original value
}
```

_(Calling it: `increment(&x)`)_

### No Pointer Arithmetic

Unlike C or C++, Go does not support pointer arithmetic (e.g., `p++`). This is a deliberate design choice to keep the language safe, simple, and free from common memory manipulation bugs.

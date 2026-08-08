# 02: Variables and Data Types in Go

Welcome to the comprehensive guide on Variables, Constants, and Data Types in Go! Go is a statically typed language, which means the type of every variable must be known at compile time. This helps catch bugs early and improves performance. 

This README provides a detailed breakdown of how to declare variables, use basic data types, concatenate strings, and perform type conversions in Go.

---

## 1. Variables in Go

In Go, variables can be declared in several ways depending on whether you want to explicitly state the type or let the compiler infer it.

### Explicit Declaration (using `var`)
You can use the `var` keyword followed by the variable name and its type.

```go
var name string = "Alice"
var age int = 30
```

### Implicit Declaration (Type Inference)
You can omit the type if you provide an initial value. Go will automatically infer the type based on the value.

```go
var city = "New York" // Go infers this is a string
var isActive = true   // Go infers this is a boolean
```

### Short Variable Declaration (`:=`)
Inside a function, you can use the short declaration operator `:=` to declare and initialize a variable simultaneously. This is the most common way to declare variables in Go. **Note:** `:=` cannot be used outside of a function (e.g., for package-level variables).

```go
func main() {
    country := "Canada"
    population := 38000000
}
```

### Multiple Variable Declarations
You can declare multiple variables on the same line or in a block to keep your code clean.

**Single line:**
```go
var x, y, z int = 1, 2, 3
a, b := "Hello", 100
```

**Block declaration:**
```go
var (
    firstName string = "Bob"
    lastName  string = "Smith"
    userAge   int    = 25
)
```

### The "Zero Value"
If you declare a variable without initializing it, Go automatically assigns it a **zero value**. Unlike other languages, variables in Go are never uninitialized or `undefined`.
- Numeric types: `0`
- Booleans: `false`
- Strings: `""` (empty string)
- Pointers, functions, interfaces, slices, channels, and maps: `nil`

```go
var count int      // initialized to 0
var message string // initialized to ""
```

---

## 2. Constants

Constants are variables whose values cannot be changed once they are declared. Use the `const` keyword. Constants can be characters, strings, booleans, or numeric values.

```go
const Pi = 3.14159
const AppName = "MyGoApp"

// Multiple constants block
const (
    StatusOK = 200
    NotFound = 404
)
```
*Note: You cannot use the `:=` syntax for constants.*

---

## 3. Data Types in Go

Go has a rich set of built-in data types. They are broadly categorized into Basic types, Aggregate types, Reference types, and Interface types. Here, we focus on the **Basic Data Types**.

### Numeric Types

**1. Integers (`int`, `int8`, `int16`, `int32`, `int64`, `uint`, `uint8`, etc.)**
- `int` and `uint` scale depending on the operating system (32-bit or 64-bit). Generally, you should just use `int` unless you have a specific reason to restrict size.
- `uint` stands for unsigned integer (positive numbers only).
- `byte` is an alias for `uint8`. Used heavily when dealing with raw data/streams.
- `rune` is an alias for `int32`. Used to represent a Unicode code point (characters).

**2. Floating-Point Numbers (`float32`, `float64`)**
- `float64` is the default when you use type inference for decimals. It offers higher precision.
```go
var price float64 = 19.99
```

**3. Complex Numbers (`complex64`, `complex128`)**
- Go has native support for complex mathematics.
```go
var c complex128 = complex(5, 7) // 5 + 7i
```

### Boolean Type (`bool`)
Represents a truth value: `true` or `false`.
```go
var isAvailable bool = true
```

### String Type (`string`)
A string in Go is a read-only slice of bytes. Strings are immutable, meaning once a string is created, you cannot change its contents (though you can reassign the variable to a completely new string).

```go
greeting := "Hello, World!"
```

---

## 4. String Concatenation and Formatting

Working with strings is a massive part of programming. Go provides several ways to combine and format strings.

### 1. Using the `+` Operator
The simplest way to concatenate two strings is using the `+` operator.
```go
firstName := "John"
lastName := "Doe"
fullName := firstName + " " + lastName // "John Doe"
```
*Tip: Using `+` is fine for simple concatenations, but can be inefficient if you are combining many strings in a loop.*

### 2. Using `fmt.Sprintf`
If you need to mix strings with numbers or other data types, `fmt.Sprintf` is incredibly powerful. It formats a string according to a format specifier without printing it to the console, returning the formatted string instead.

```go
import "fmt"

age := 30
name := "Alice"
// %s is for string, %d is for base-10 integer
bio := fmt.Sprintf("My name is %s and I am %d years old.", name, age)
```

**Common format verbs:**
- `%v`: The default format (works for almost any type)
- `%T`: Prints the data type of the variable
- `%s`: String
- `%d`: Integer
- `%f`: Float (use `%.2f` to round to 2 decimal places)

### 3. Using `strings.Join`
When you have a slice (array) of strings and want to combine them with a separator, `strings.Join` is highly efficient.

```go
import "strings"

words := []string{"Go", "is", "awesome"}
sentence := strings.Join(words, " ") // "Go is awesome"
```

### 4. Using `strings.Builder` (For High Performance)
If you are concatenating a large number of strings (e.g., inside a loop), using `strings.Builder` is the most memory-efficient and fastest approach.

```go
import "strings"

var builder strings.Builder
builder.WriteString("Hello")
builder.WriteString(", ")
builder.WriteString("World!")

result := builder.String() // "Hello, World!"
```

---

## 5. Type Conversion (Casting)

Go is very strict about types. It **does not** do implicit type conversions. You cannot add an `int` to a `float64` without explicitly converting one of them. 

The syntax for conversion is `Type(value)`.

```go
var i int = 42
var f float64 = float64(i) // Convert int to float64
var u uint = uint(f)       // Convert float64 to uint

fmt.Printf("i: %v, f: %v, u: %v\n", i, f, u)
```

**Converting Numbers to Strings and Vice Versa:**
To convert between strings and numeric types, you use the `strconv` (string conversion) package.

```go
import "strconv"

// String to Int
numStr := "100"
numInt, err := strconv.Atoi(numStr) // Atoi = ASCII to Integer

// Int to String
newStr := strconv.Itoa(numInt)      // Itoa = Integer to ASCII
```

---

## 📝 Summary Checklist
- [ ] Understand `var` vs `:=` declarations.
- [ ] Know how to declare multiple variables and constants.
- [ ] Understand the concept of "Zero Values" in Go.
- [ ] Differentiate between `int`, `float64`, `string`, and `bool`.
- [ ] Master string concatenation using `+`, `fmt.Sprintf`, and `strings.Builder`.
- [ ] Successfully convert types natively and using the `strconv` package.

# Reflection (`reflect`)

Reflection in Go (via the `reflect` package) is a powerful form of metaprogramming. It allows a program to inspect its own variables, determine their types, and even modify their values at **runtime**, even if those types weren't known when the code was compiled.

This is the "magic" that makes packages like `encoding/json` (reading struct tags) and `fmt` (printing arbitrary types) work.

## 1. Type and Value

The reflection package revolves around two primary concepts: `reflect.Type` and `reflect.Value`. You obtain these using `reflect.TypeOf()` and `reflect.ValueOf()`.

```go
import "reflect"

var x float64 = 3.14

// Inspect the type at runtime
fmt.Println("Type:", reflect.TypeOf(x))   // Output: float64

// Inspect the value at runtime
fmt.Println("Value:", reflect.ValueOf(x)) // Output: 3.14
```

## 2. Inspecting Structs and Tags

A common use case for reflection is inspecting structs to read their tags. This is exactly how the JSON package knows which JSON keys map to which struct fields.

```go
type Employee struct {
    Name string `database:"col_name"`
    Age  int    `database:"col_age"`
}

e := Employee{"Alice", 28}
t := reflect.TypeOf(e)

// Iterate through the fields of the struct
for i := 0; i < t.NumField(); i++ {
    field := t.Field(i)
    // Extract the struct tag dynamically
    fmt.Printf("Field: %s, Tag: %s\n", field.Name, field.Tag.Get("database"))
}
```

## 3. Modifying Values

Reflection can also modify variables, but it's notoriously tricky. To modify a value via reflection, you **must pass a pointer** to `reflect.ValueOf()`, and then use `.Elem()` to get the underlying value that the pointer points to. 

```go
var name string = "John"

// 1. Pass a pointer to ValueOf
v := reflect.ValueOf(&name)

// 2. Use Elem() to access the settable value
v.Elem().SetString("Doe")

fmt.Println(name) // Output: Doe
```

## ⚠️ Warnings About Reflection

While powerful, reflection should be used sparingly for three reasons:
1. **Performance overhead**: Reflection evaluates types at runtime, making it significantly slower than direct, compile-time typed code.
2. **Loss of compile-time safety**: Bugs using reflection will cause **panics** at runtime instead of being caught by the compiler.
3. **Readability**: Code using heavy reflection is often difficult to read and maintain.

If you can solve a problem using Interfaces or Generics, you should always prefer those over Reflection.

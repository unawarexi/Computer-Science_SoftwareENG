# Generics in Go

For a long time, Go intentionally omitted generics to keep the language simple and compilation fast. If you wanted a function to work with both `int` and `float64`, you either had to write two separate functions or use the empty interface `interface{}` (which sacrifices type safety and requires slow type assertions).

Go 1.18 introduced **Type Parameters** (Generics), allowing developers to write flexible, reusable code while maintaining strict, compile-time type safety.

## 1. Type Parameters

You can define a function with type parameters by placing them in square brackets `[]` before the regular function arguments. 

```go
// [T any] means T can be literally any type.
func PrintAnything[T any](thing T) {
    fmt.Println(thing)
}

// Usage:
PrintAnything[string]("Hello") // Explicit type
PrintAnything(42)              // Implicit type inference (Go figures out it's an int)
```

## 2. Type Constraints

Usually, `any` is too broad. If you want to add two numbers, the compiler needs to know that the generic type actually supports the `+` operator. You achieve this using **Constraints**.

The `constraints` package (or the built-in `comparable` constraint) lets you restrict what types are allowed.

```go
// T must be an int or a float64
type Number interface {
    int | float64
}

// The constraint 'Number' guarantees the '+' operator will work.
func Add[T Number](a, b T) T {
    return a + b
}
```

## 3. The `comparable` Constraint

If you want to use a generic type as a key in a `map`, or use the `==` operator on it, you must use the built-in `comparable` constraint.

```go
// Find returns the index of a target in a slice.
// T must be comparable so we can use ==
func Find[T comparable](slice []T, target T) int {
    for i, val := range slice {
        if val == target {
            return i
        }
    }
    return -1
}
```

## 4. Generic Data Structures

Generics aren't just for functions; they are incredibly useful for building custom, type-safe data structures like Stacks, Queues, or Linked Lists.

```go
// A generic Stack
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}
```

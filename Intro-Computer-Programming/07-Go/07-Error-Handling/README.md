# 07: Error Handling in Go

Welcome to Error Handling in Go! Unlike languages that use `try/catch` exceptions, Go treats errors as standard, returned values. This forces you to handle errors explicitly, leading to robust and predictable code.

---

## 1. The `error` Interface

In Go, an error is simply an interface type. Any type that implements a method named `Error()` returning a string satisfies this interface.

```go
type error interface {
    Error() string
}
```

## 2. Returning and Checking Errors

Because Go supports multiple return values, it is a standard idiom for functions to return the result and an `error`. You check it using a simple `if` statement.

```go
result, err := doSomething()
if err != nil {
    return fmt.Errorf("failed doing something: %w", err) // this is called guard clause
}
```

## 3. Creating Basic Errors

You can create simple text-based errors using the built-in `errors` package or the `fmt` package if you need string formatting.

```go
// Using errors.New
err := errors.New("something went wrong")
```

```go
// Using fmt.Errorf for formatting
err := fmt.Errorf("user %s not found", username)
```

## 4. Custom Error Types

You can create your own error types by defining a struct and implementing the `Error()` method. This allows you to attach extra data to the error.

```go
type NotFoundError struct { ID int }

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("record %d not found", e.ID)
}
```

## 5. Error Wrapping

Often, you want to add context to an error while preserving the original error underneath. You can "wrap" errors using `fmt.Errorf` with the `%w` verb.

```go
func fetch() error {
    err := db.Query()
    // Wraps the database error with more context
    return fmt.Errorf("fetch failed: %w", err)
}
```

## 6. Inspecting Errors (`errors.Is`)

Because errors can be wrapped, simply checking `err == targetErr` might fail. You should use `errors.Is` to check if a specific error is anywhere in the chain.

```go
if errors.Is(err, sql.ErrNoRows) {
    fmt.Println("No records found in database")
}
```

## 7. Extracting Errors (`errors.As`)

If you need to extract a specific custom error struct out of the error chain to access its fields, use `errors.As`.

```go
var notFound *NotFoundError
if errors.As(err, &notFound) {
    fmt.Println("Missing ID:", notFound.ID)
}
```

---

## 8. The `defer` Statement

Before understanding `recover`, you must know `defer`. A deferred function call is pushed onto a stack and executed right before the surrounding function returns, regardless of success or failure.

```go
func processFile() {
    file := openFile()
    defer file.Close() // Guaranteed to run at the end
}
```

## 9. Panic

When your program encounters an unrecoverable state (like an out-of-bounds array access), it "panics". `panic()` stops normal execution, runs all deferred functions, and crashes the program. You should rarely use it explicitly.

```go
if configIsMissing {
    panic("cannot start without config!")
}
```

## 10. Recover

You can stop a panic and regain control of your program using the built-in `recover()` function. It **must** be called directly inside a `defer`red function to work.

```go
defer func() {
    if r := recover(); r != nil {
        fmt.Println("Recovered from panic:", r)
    }
}()
```

_(If a panic happens below this defer, the program won't crash; it will print the message and continue up the call stack)._

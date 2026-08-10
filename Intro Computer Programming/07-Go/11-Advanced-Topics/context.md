# The Context Package (`context`)

In Go, servers typically handle each incoming request in its own goroutine. However, processing a request often requires spawning *more* goroutines to query databases, call external APIs, or perform heavy computations. 

If a user cancels their request (e.g., closes their browser) or if an API call takes too long, you want to **cancel all related goroutines** to free up resources. The `context` package provides the standard way to pass these cancellation signals, deadlines, and request-scoped values across API boundaries and between goroutines.

## 1. Context with Cancellation

You can create a context that can be manually cancelled. When `cancel()` is called, the context's `Done()` channel is closed. Any goroutine listening to this channel knows it should stop working.

```go
// Create a context and a cancellation function
ctx, cancel := context.WithCancel(context.Background())

go func() {
    // Simulate long work
    select {
    case <-time.After(5 * time.Second):
        fmt.Println("Work finished")
    case <-ctx.Done(): // Triggered when cancel() is called
        fmt.Println("Work cancelled!")
    }
}()

cancel() // Manually trigger cancellation immediately
```

## 2. Context with Timeout / Deadline

Instead of manually cancelling, you can set a context to automatically cancel itself after a certain amount of time. This is essential for preventing hanging network requests.

```go
// Automatically cancel after 2 seconds
ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
defer cancel() // Always defer cancel to prevent context leaks

req, _ := http.NewRequestWithContext(ctx, "GET", "https://api.example.com", nil)
res, err := http.DefaultClient.Do(req)
// If the API takes longer than 2 seconds, err will be "context deadline exceeded"
```

## 3. Request-Scoped Values

Contexts can also carry data associated with a specific request (like a User ID or an authentication token) down the call stack without having to pass it as an explicit parameter to every function.

```go
// Store a value in the context
ctx := context.WithValue(context.Background(), "userID", 12345)

// Retrieve it deep inside another function
if id, ok := ctx.Value("userID").(int); ok {
    fmt.Println("User ID is:", id)
}
```

> **Best Practice**: Always pass `ctx context.Context` as the very first argument to functions that do I/O or concurrency. Never store contexts in structs.

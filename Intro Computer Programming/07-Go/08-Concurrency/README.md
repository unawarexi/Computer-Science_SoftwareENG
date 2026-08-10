# Concurrency in Go

Concurrency is the ability of a program to be decomposed into parts that can run independently of each other. Go approaches concurrency conceptually through the Communicating Sequential Processes (CSP) model, famously summarized by the proverb: *"Do not communicate by sharing memory; instead, share memory by communicating."*

Go provides two primary primitives for concurrency: **Goroutines** (for execution) and **Channels** (for communication and synchronization).

## Goroutines

A Goroutine is a lightweight thread managed by the Go runtime. Unlike traditional OS threads which have a large initial stack (often 1-2MB) and high context-switching overhead, goroutines start with a tiny stack (typically 2KB) that grows and shrinks dynamically. This makes it practical to spawn hundreds of thousands of concurrent goroutines in a single Go application.

### Basic Concurrency

To invoke a function in a new goroutine, use the `go` keyword followed by the function call. The new goroutine executes concurrently with the calling code.

```go
go func() {
    fmt.Println("Running concurrently!")
}()
```

### WaitGroups

When a program's `main` function terminates, all running goroutines are abruptly killed. To wait for multiple goroutines to finish their work before proceeding, we use `sync.WaitGroup`. It acts as a concurrency-safe counter. You add to the counter before launching a goroutine, decrement it inside the goroutine using `Done()`, and use `Wait()` to block until the counter hits zero.

```go
var wg sync.WaitGroup
wg.Add(1) // Increment counter
go func() { defer wg.Done(); doWork() }()
wg.Wait() // Block until counter is 0
```

### Mutexes (Mutual Exclusion)

While channels are preferred for communication, sometimes you need to safely share state (memory) across goroutines. A `sync.Mutex` ensures that only one goroutine can access a critical section of code at a time, preventing race conditions.

```go
var mu sync.Mutex
mu.Lock()
// safely modify shared state
mu.Unlock()
```

## Channels

Channels are typed conduits through which you can send and receive values between goroutines. They provide a safe mechanism for concurrent processes to communicate without the need for complex, error-prone locking mechanisms (like Mutexes), aligning perfectly with the CSP model.

### Unbuffered Channels

An unbuffered channel has no capacity to store data. A send operation on an unbuffered channel blocks the sending goroutine until another goroutine is ready to receive the data, and vice versa. This provides strong synchronization between goroutines.

```go
ch := make(chan int) // Unbuffered
go func() { ch <- 42 }() // Blocks until received
val := <-ch // Receives 42
```

### Buffered Channels and Buffers

A **buffer** is a temporary storage area in memory. In Go, a buffered channel has an internal queue (buffer) with a specified capacity. Sends to a buffered channel only block when the buffer is completely full, and receives block only when the buffer is empty. This decouples the execution speeds of producers and consumers.

```go
ch := make(chan string, 2) // Channel with buffer capacity 2
ch <- "msg1"               // Stored in buffer, doesn't block
ch <- "msg2"               // Stored in buffer, doesn't block
```

### Select Statement

The `select` statement lets a goroutine wait on multiple communication operations. It's similar to a `switch` statement, but each `case` must be a channel operation (send or receive). `select` blocks until one of its cases can proceed. If multiple are ready, it picks one at random, preventing starvation.

```go
select {
case msg1 := <-ch1:
    fmt.Println("Received:", msg1)
case ch2 <- "ping":
    fmt.Println("Sent ping")
}
```

### Worker Pools

A Worker Pool is a concurrency pattern where a fixed number of worker goroutines are spawned to process a potentially infinite stream of tasks. This pattern is crucial for controlling resource utilization (like memory or database connections) and preventing the system from being overwhelmed by too many concurrent operations.

```go
// Launching 3 workers
for w := 1; w <= 3; w++ {
    go worker(w, jobsChan, resultsChan)
}
```

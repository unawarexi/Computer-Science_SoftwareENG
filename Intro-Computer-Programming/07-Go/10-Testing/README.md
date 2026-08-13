# Testing in Go

Go has a built-in, lightweight testing framework that makes writing automated tests remarkably simple. Unlike other languages that often require massive third-party frameworks (like JUnit or pytest), Go provides everything you need right out of the box with the standard library `testing` package and the `go test` command.

## The `testing` Package

The `testing` package provides the necessary types and functions to write unit tests, benchmarks, and examples. To use it, you create a file that ends in `_test.go` in the same directory and package as the code you want to test. The `go test` command automatically finds and executes all functions in these files that match a specific naming convention.

## Unit Tests

A unit test focuses on verifying the behavior of a small, isolated piece of code—typically a single function—ensuring it behaves as expected under various conditions.

### Writing a Unit Test

To write a unit test in Go, you must follow these rules:
1. The file name must end with `_test.go` (e.g., `math_test.go`).
2. The function name must start with `Test` followed by a capitalized word (e.g., `TestAdd`).
3. The function must take exactly one argument of type `*testing.T`.

The `*testing.T` object provides methods to report failures (like `t.Errorf` or `t.Fatalf`) and log information.

```go
// In math_test.go
import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        // t.Errorf logs the error and marks the test as failed, but continues execution.
        t.Errorf("Add(2, 3) FAILED. Expected 5, got %d", result)
    }
}
```

## Table-Driven Tests

When you need to test a function against many different inputs and expected outputs, writing individual test functions for each scenario becomes repetitive and bloated. Go developers heavily favor a pattern called **Table-Driven Testing**.

In a table-driven test, you define a slice of anonymous structs (the "table"). Each struct represents a single test case, containing the inputs and the expected output. You then iterate over this table using a `for` loop, running the test logic for each entry.

```go
func TestMultiply(t *testing.T) {
    // 1. Define the table of test cases
    tests := []struct {
        name     string // A descriptive name for the test case
        a, b     int    // Inputs
        expected int    // Expected output
    }{
        {"positive numbers", 2, 3, 6},
        {"negative numbers", -2, -3, 6},
        {"mixed numbers", -2, 3, -6},
        {"zero", 5, 0, 0},
    }

    // 2. Iterate and test
    for _, tc := range tests {
        // t.Run executes a subtest with a specific name, making output easier to read
        t.Run(tc.name, func(t *testing.T) {
            result := Multiply(tc.a, tc.b)
            if result != tc.expected {
                t.Errorf("Expected %d, got %d", tc.expected, result)
            }
        })
    }
}
```
This approach is extremely clean, makes it trivial to add new test cases by just adding a line to the struct slice, and utilizes `t.Run()` to create distinct, named subtests. If one case fails, you know exactly which one it was without it stopping the other cases from running.

## Benchmarks

While unit tests verify *correctness*, Benchmarks measure *performance*. They tell you how long a piece of code takes to execute and how much memory it allocates.

### Writing a Benchmark

Benchmarks follow similar rules to unit tests:
1. They live inside `_test.go` files.
2. The function name must start with `Benchmark` (e.g., `BenchmarkAdd`).
3. The function takes an argument of type `*testing.B`.

The `*testing.B` object gives you access to a crucial field: `b.N`. The Go testing framework will automatically run your benchmarked code inside a loop exactly `b.N` times. The framework automatically adjusts `b.N` upwards until the benchmark runs long enough (usually 1 second) to get a statistically significant and reliable timing measurement.

```go
func BenchmarkAdd(b *testing.B) {
    // The loop must run exactly b.N times
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}
```

To run benchmarks, you use the terminal command `go test -bench=.`. The framework will output the number of operations it was able to perform and the average nanoseconds (`ns/op`) each operation took, allowing you to easily identify performance bottlenecks.

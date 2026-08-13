package advancedtopics

import (
	"context"
	"fmt"
	"net/http"
	"time"
)

// =============================================================================
// SECTION 1: Context with Cancellation
// context.WithCancel creates a context and a cancel function.
// Calling cancel() closes the ctx.Done() channel, signalling all listening
// goroutines to stop what they are doing and clean up.
// =============================================================================

func demonstrateCancellation() {
	fmt.Println("--- 1. Context with Cancellation ---")

	// context.Background() is the root context — use it at the top level.
	ctx, cancel := context.WithCancel(context.Background())

	// Launch a goroutine that respects the cancellation signal.
	done := make(chan struct{})
	go func() {
		defer close(done)
		select {
		case <-time.After(5 * time.Second):
			// This branch would run if the context were never cancelled
			fmt.Println("  Worker: 5-second task completed.")
		case <-ctx.Done():
			// ctx.Done() is closed when cancel() is called
			fmt.Println("  Worker: Cancelled! Reason:", ctx.Err())
			// ctx.Err() returns context.Canceled here
		}
	}()

	// Cancel the context almost immediately — the worker should receive the signal.
	time.Sleep(50 * time.Millisecond)
	cancel() // Trigger cancellation

	<-done // Wait for the goroutine to finish cleanup
	fmt.Println("  Main: All workers cleaned up.")
}

// =============================================================================
// SECTION 2: Context with Timeout / Deadline
// context.WithTimeout is the most common pattern for HTTP clients and DB queries.
// Always defer cancel() immediately after creating the context to avoid leaks.
// =============================================================================

// simulateSlowAPI simulates a function that respects context deadlines.
// In real code this would be http.NewRequestWithContext or a DB query.
func simulateSlowAPI(ctx context.Context, latency time.Duration) error {
	select {
	case <-time.After(latency): // Simulates the API response time
		return nil
	case <-ctx.Done():
		// The context deadline was exceeded before the API responded
		return ctx.Err()
	}
}

func demonstrateTimeout() {
	fmt.Println("\n--- 2. Context with Timeout ---")

	// The context will auto-cancel after 200ms
	ctx, cancel := context.WithTimeout(context.Background(), 200*time.Millisecond)
	defer cancel() // ALWAYS defer cancel — prevents context leak even on success

	// Fast API call — completes within 200ms
	err := simulateSlowAPI(ctx, 100*time.Millisecond)
	if err != nil {
		fmt.Println("  Fast call failed:", err)
	} else {
		fmt.Println("  Fast call (100ms latency) succeeded!")
	}

	// Slow API call — will exceed the 200ms deadline
	ctx2, cancel2 := context.WithTimeout(context.Background(), 200*time.Millisecond)
	defer cancel2()

	err = simulateSlowAPI(ctx2, 500*time.Millisecond)
	if err != nil {
		// err == context.DeadlineExceeded
		fmt.Println("  Slow call (500ms latency) failed:", err)
	}
}

func demonstrateHTTPWithTimeout() {
	fmt.Println("\n--- 2b. HTTP Client with Context Timeout ---")

	// Any HTTP request that takes longer than 1 second will be aborted
	ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
	defer cancel()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, "https://httpbin.org/delay/0", nil)
	if err != nil {
		fmt.Println("  Could not create request:", err)
		return
	}

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println("  HTTP request failed (possibly timeout):", err)
		return
	}
	defer resp.Body.Close()
	fmt.Println("  HTTP response status:", resp.Status)
}

// =============================================================================
// SECTION 3: Request-Scoped Values
// context.WithValue stores a value in the context. Any function receiving
// the context down the call stack can retrieve it — no need to add extra
// parameters to every function signature.
//
// Best Practice: Use a private unexported type as the key to avoid collisions.
// =============================================================================

// Using an unexported custom type as a key avoids key collisions between packages.
type contextKey string

const (
	userIDKey    contextKey = "userID"
	requestIDKey contextKey = "requestID"
)

// processRequest simulates a handler that extracts context values.
func processRequest(ctx context.Context) {
	// Retrieve the user ID stored higher up in the call stack
	if id, ok := ctx.Value(userIDKey).(int); ok {
		fmt.Printf("  Processing request for UserID: %d\n", id)
	} else {
		fmt.Println("  No UserID found in context")
	}

	if reqID, ok := ctx.Value(requestIDKey).(string); ok {
		fmt.Printf("  Request trace ID: %s\n", reqID)
	}
}

func demonstrateContextValues() {
	fmt.Println("\n--- 3. Request-Scoped Values in Context ---")

	// A middleware or HTTP handler would set these values once
	ctx := context.WithValue(context.Background(), userIDKey, 12345)
	ctx = context.WithValue(ctx, requestIDKey, "req-abc-789")

	// processRequest doesn't need userID as a parameter — it reads it from context
	processRequest(ctx)

	// A context without those values — processRequest handles it gracefully
	emptyCtx := context.Background()
	processRequest(emptyCtx)
}

// =============================================================================
// DemonstrateContext runs all context examples.
// =============================================================================
func DemonstrateContext() {
	demonstrateCancellation()
	demonstrateTimeout()
	// demonstrateHTTPWithTimeout() — requires network; comment in when online
	demonstrateContextValues()

	fmt.Println("\n--- Best Practices ---")
	fmt.Println("✓ Always pass ctx as the FIRST argument to functions doing I/O.")
	fmt.Println("✓ Always defer cancel() immediately after context creation.")
	fmt.Println("✓ Never store a context inside a struct field.")
	fmt.Println("✓ Use unexported types as context value keys to avoid collisions.")
}

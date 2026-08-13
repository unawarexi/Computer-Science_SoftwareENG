package concurrency

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

// =============================================================================
// TOKENS AND SEMAPHORES IN GO CONCURRENCY
//
// A "token" is a unit of permission represented as a value in a channel.
// Controlling how many tokens are available controls how many goroutines
// can do work simultaneously — this is the semaphore pattern.
// =============================================================================

// =============================================================================
// SECTION 1: Basic Token / Semaphore
//
// A buffered channel of capacity N acts as a semaphore:
//   - Sending to the channel = acquiring a token (claiming a "slot")
//   - Receiving from the channel = releasing a token (freeing the "slot")
//
// When the channel is full (all N slots taken), any send blocks — forcing
// new goroutines to wait until a running goroutine releases its token.
//
// We use `struct{}` as the token value because it carries no data and
// occupies zero bytes in memory. It is purely a signalling mechanism.
// =============================================================================

// DemonstrateSemaphore shows how a buffered channel limits concurrency to N.
func DemonstrateSemaphore() {
	fmt.Println("=== 1. Semaphore (Buffered Channel as Token Pool) ===")

	const maxConcurrent = 3 // Only 3 goroutines may run at once
	const totalJobs = 8

	// The semaphore: a buffered channel of empty structs.
	// Capacity = max number of goroutines allowed to run simultaneously.
	semaphore := make(chan struct{}, maxConcurrent)

	var wg sync.WaitGroup
	var completed int32 // atomic counter

	fmt.Printf("Launching %d jobs with max concurrency of %d...\n", totalJobs, maxConcurrent)

	for i := 1; i <= totalJobs; i++ {
		wg.Add(1)
		go func(jobID int) {
			defer wg.Done()

			// ── Acquire Token ────────────────────────────────────────────────
			// Send a token to claim one of the N available slots.
			// If the semaphore is full, this BLOCKS until another goroutine
			// releases its token (receives from the channel).
			semaphore <- struct{}{}

			// ── Release Token (deferred for safety) ─────────────────────────
			// Always release the token when work is done, even if the goroutine
			// panics. Using defer guarantees this runs no matter what.
			defer func() { <-semaphore }()

			// ── Critical Section ─────────────────────────────────────────────
			// At most 'maxConcurrent' goroutines execute this block at once.
			fmt.Printf("  Job %d started (semaphore used: %d/%d)\n",
				jobID, len(semaphore), maxConcurrent)

			time.Sleep(100 * time.Millisecond) // Simulate work

			atomic.AddInt32(&completed, 1)
			fmt.Printf("  Job %d done\n", jobID)
		}(i)
	}

	wg.Wait()
	fmt.Printf("All %d jobs completed.\n\n", atomic.LoadInt32(&completed))
}

// =============================================================================
// SECTION 2: Token Bucket Rate Limiter
//
// A token bucket controls the RATE at which work happens over time.
// The "bucket" is refilled with one token every time.Duration.
// Goroutines must wait for a token — limiting throughput to at most
// 1 operation per interval.
//
// This is different from a semaphore:
//   Semaphore = limits CONCURRENCY (how many at once)
//   Token Bucket = limits RATE (how many per unit of time)
// =============================================================================

// DemonstrateTokenBucket shows a simple rate limiter using time.Tick.
func DemonstrateTokenBucket() {
	fmt.Println("=== 2. Token Bucket Rate Limiter ===")

	// Process at most 1 request every 150ms → ~6–7 requests per second
	tokenInterval := 150 * time.Millisecond
	rateLimiter := time.NewTicker(tokenInterval)
	defer rateLimiter.Stop()

	requests := []string{"GET /api/users", "POST /api/orders", "GET /api/products",
		"DELETE /api/items/5", "PUT /api/settings"}

	fmt.Printf("Rate limit: 1 request per %v\n", tokenInterval)
	start := time.Now()

	for _, req := range requests {
		// Block here until the ticker fires — this enforces the rate limit.
		// Each tick = one token becoming available.
		<-rateLimiter.C

		elapsed := time.Since(start).Round(time.Millisecond)
		fmt.Printf("  [+%v] Handling: %s\n", elapsed, req)
	}

	fmt.Println("All requests processed.\n")
}

// =============================================================================
// SECTION 3: Bursty Token Bucket
//
// A more advanced rate limiter that allows short bursts of traffic
// (up to burstSize requests at once) while still enforcing a long-term
// average rate. This matches real-world APIs that allow burst traffic.
// =============================================================================

// DemonstrateBurstyRateLimiter shows how to allow bursts using a pre-filled channel.
func DemonstrateBurstyRateLimiter() {
	fmt.Println("=== 3. Bursty Token Bucket ===")

	const burstSize = 3 // Allow up to 3 instant requests (the "burst")

	// Pre-fill the channel with burst tokens — these allow immediate processing.
	burstyLimiter := make(chan time.Time, burstSize)
	for i := 0; i < burstSize; i++ {
		burstyLimiter <- time.Now()
	}

	// A background goroutine replenishes one token every 200ms.
	go func() {
		ticker := time.NewTicker(200 * time.Millisecond)
		defer ticker.Stop()
		for t := range ticker.C {
			burstyLimiter <- t
		}
	}()

	requests := make([]int, 7)
	for i := range requests {
		requests[i] = i + 1
	}

	start := time.Now()
	fmt.Println("First 3 requests burst immediately, then rate-limited:")

	for _, req := range requests {
		// Acquire a token (may be from the burst or from the periodic refill)
		<-burstyLimiter
		elapsed := time.Since(start).Round(time.Millisecond)
		fmt.Printf("  [+%v] Request %d handled\n", elapsed, req)
	}

	fmt.Println()
}

// =============================================================================
// SECTION 4: Worker Pool with Token-Based Back-Pressure
//
// Combines the worker pool and semaphore patterns. The jobs channel acts as
// a queue and the semaphore token ensures we never exceed the worker capacity.
// This is the production-grade pattern for bounded concurrency.
// =============================================================================

// job represents a unit of work.
type job struct {
	ID   int
	Data string
}

// result holds the outcome of processing a job.
type result struct {
	JobID  int
	Output string
}

// worker processes jobs from the jobs channel and sends results to results channel.
// The semaphore is acquired before processing and released after — enforcing the limit.
func boundedWorker(workerID int, jobs <-chan job, results chan<- result, semaphore chan struct{}, wg *sync.WaitGroup) {
	defer wg.Done()
	for j := range jobs {
		// Acquire a token — blocks if max concurrency is already reached
		semaphore <- struct{}{}

		// Simulate processing work
		time.Sleep(50 * time.Millisecond)
		output := fmt.Sprintf("Worker-%d processed Job-%d (%s)", workerID, j.ID, j.Data)

		// Release the token and send the result
		<-semaphore
		results <- result{JobID: j.ID, Output: output}
	}
}

// DemonstrateBoundedWorkerPool shows a worker pool with semaphore-based back-pressure.
func DemonstrateBoundedWorkerPool() {
	fmt.Println("=== 4. Bounded Worker Pool with Token Back-Pressure ===")

	const numWorkers = 5
	const maxConcurrentJobs = 2 // At most 2 jobs process at the same time
	const numJobs = 6

	jobsChan := make(chan job, numJobs)
	resultsChan := make(chan result, numJobs)
	semaphore := make(chan struct{}, maxConcurrentJobs)

	// Launch workers
	var wg sync.WaitGroup
	for w := 1; w <= numWorkers; w++ {
		wg.Add(1)
		go boundedWorker(w, jobsChan, resultsChan, semaphore, &wg)
	}

	// Send jobs
	for j := 1; j <= numJobs; j++ {
		jobsChan <- job{ID: j, Data: fmt.Sprintf("task-%d", j)}
	}
	close(jobsChan) // Signal that no more jobs are coming

	// Wait for all workers to finish, then close results
	go func() {
		wg.Wait()
		close(resultsChan)
	}()

	// Collect results
	fmt.Printf("%d workers, max %d concurrent jobs, %d total jobs:\n",
		numWorkers, maxConcurrentJobs, numJobs)
	for r := range resultsChan {
		fmt.Println(" ", r.Output)
	}
	fmt.Println()
}

// =============================================================================
// DemonstrateTokens runs all token and semaphore examples.
// =============================================================================
func DemonstrateTokens() {
	DemonstrateSemaphore()
	DemonstrateTokenBucket()
	DemonstrateBurstyRateLimiter()
	DemonstrateBoundedWorkerPool()
}

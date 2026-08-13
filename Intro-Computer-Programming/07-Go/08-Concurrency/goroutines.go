package concurrency

import (
	"fmt"
	"sync"
	"time"
)

// DemonstrateGoroutines showcases how to use goroutines and WaitGroups in Go.
func DemonstrateGoroutines() {
	// 1. Basic Goroutine
	// The 'go' keyword starts a new concurrent goroutine.
	go func() {
		fmt.Println("Hello from a basic goroutine!")
	}()
	
	// Wait a bit to let the basic goroutine finish (not ideal for real apps)
	time.Sleep(10 * time.Millisecond)

	// 2. Using sync.WaitGroup
	// WaitGroups are the idiomatic way to wait for a collection of goroutines to finish.
	var wg sync.WaitGroup
	
	// We are launching 3 goroutines, so we add 3 to the WaitGroup counter.
	wg.Add(3)
	
	for i := 1; i <= 3; i++ {
		go func(workerID int) {
			// Ensure Done() is called when the goroutine finishes
			defer wg.Done()
			fmt.Printf("Worker %d is executing...\n", workerID)
		}(i)
	}
	
	// Block until the WaitGroup counter goes back to 0.
	wg.Wait()
	fmt.Println("All workers finished executing.")
}

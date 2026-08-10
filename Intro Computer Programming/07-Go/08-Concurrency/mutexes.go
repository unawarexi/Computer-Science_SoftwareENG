package concurrency

import (
	"fmt"
	"sync"
)

// DemonstrateMutexes showcases how to use sync.Mutex to protect shared state.
func DemonstrateMutexes() {
	// 1. Shared State and Mutex Declaration
	var counter int
	var mu sync.Mutex
	var wg sync.WaitGroup
	
	// Launching 1000 goroutines that all try to increment the counter
	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			
			// 2. Locking the Mutex
			// Only one goroutine can acquire the lock at a time.
			// This prevents race conditions when modifying 'counter'.
			mu.Lock()
			counter++
			mu.Unlock() // Always unlock after the critical section
		}()
	}
	
	wg.Wait()
	fmt.Println("Final counter value (should be 1000):", counter)
}

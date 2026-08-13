package concurrency

import (
	"fmt"
	"sync"
)

// DemonstrateMutexes shows sync.Mutex and sync.RWMutex protecting shared state.
func DemonstrateMutexes() {
	// --- 1. sync.Mutex ---
	// Only one goroutine can hold the lock at a time.
	// Use for any shared state that is both read and written.
	var counter int
	var mu sync.Mutex
	var wg sync.WaitGroup

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			mu.Lock()
			counter++
			mu.Unlock()
		}()
	}
	wg.Wait()
	fmt.Println("Mutex — final counter (should be 1000):", counter)

	// --- 2. sync.RWMutex ---
	// Multiple goroutines can hold a read lock (RLock) simultaneously.
	// A write lock (Lock) is exclusive — blocks all readers and writers.
	cache := map[string]string{"lang": "Go"}
	var rw sync.RWMutex
	var wg2 sync.WaitGroup

	// Spawn 5 concurrent readers — all run at the same time.
	for i := 0; i < 5; i++ {
		wg2.Add(1)
		go func(id int) {
			defer wg2.Done()
			rw.RLock()
			fmt.Printf("  Reader %d: cache[\"lang\"] = %q\n", id, cache["lang"])
			rw.RUnlock()
		}(i)
	}

	// One writer — gets exclusive access, all readers wait.
	wg2.Add(1)
	go func() {
		defer wg2.Done()
		rw.Lock()
		cache["lang"] = "Go 1.22"
		fmt.Println("  Writer: updated cache")
		rw.Unlock()
	}()

	wg2.Wait()
	fmt.Println("RWMutex — final cache value:", cache["lang"])
}

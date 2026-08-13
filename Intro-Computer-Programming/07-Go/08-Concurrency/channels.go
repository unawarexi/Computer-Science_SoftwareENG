package concurrency

import (
	"fmt"
)

// DemonstrateChannels showcases how to use unbuffered/buffered channels and select.
func DemonstrateChannels() {
	// 1. Unbuffered Channels
	// Unbuffered channels block until both sender and receiver are ready.
	unbufChan := make(chan string)
	go func() {
		unbufChan <- "Data from unbuffered channel"
	}()
	msg := <-unbufChan
	fmt.Println("Received:", msg)

	// 2. Buffered Channels
	// Buffered channels have an in-memory queue. Sends don't block unless the buffer is full.
	bufChan := make(chan int, 2)
	bufChan <- 100 // Doesn't block
	bufChan <- 200 // Doesn't block
	
	fmt.Println("Received from buffer:", <-bufChan)
	fmt.Println("Received from buffer:", <-bufChan)

	// 3. The Select Statement
	// Select allows waiting on multiple channel operations simultaneously.
	ch1 := make(chan string)
	ch2 := make(chan string)
	
	go func() { ch1 <- "Fast message" }()
	
	select {
	case m1 := <-ch1:
		fmt.Println("Received from ch1:", m1)
	case m2 := <-ch2:
		fmt.Println("Received from ch2:", m2)
	}
}

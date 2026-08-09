package controlstructures

import "fmt"

// DemonstrateLoops showcases the different ways to use the 'for' loop in Go.
func DemonstrateLoops() {
	// 1. Traditional For Loop
	// Consists of Initialization, Condition, and Post Statement.
	fmt.Println("Traditional Loop:")
	for i := 0; i < 3; i++ {
		fmt.Println("Iteration:", i)
	}

	// 2. For Loop as a "While" Loop
	// Omit the initialization and post statement, keeping only the condition.
	fmt.Println("\nWhile Loop Simulation:")
	count := 0
	for count < 3 {
		fmt.Println("Count is:", count)
		count++
	}

	// 3. Infinite For Loop
	// Has no condition and runs forever unless 'break' is called.
	fmt.Println("\nInfinite Loop with Break:")
	x := 0
	for {
		if x == 2 {
			fmt.Println("Breaking out of infinite loop at x =", x)
			break // Exits the loop
		}
		x++
	}

	// 4. For Loop with 'range'
	// The standard way to iterate over slices, arrays, and maps.
	fmt.Println("\nRange Loop:")
	fruits := []string{"Apple", "Banana", "Cherry"}
	for index, fruit := range fruits {
		fmt.Printf("Index: %d, Fruit: %s\n", index, fruit)
	}
}

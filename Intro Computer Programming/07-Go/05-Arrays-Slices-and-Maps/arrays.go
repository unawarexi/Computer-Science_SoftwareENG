package arraysslicesandmaps

import "fmt"

// DemonstrateArrays showcases how to use arrays in Go.
func DemonstrateArrays() {
	// 1. Declaration and Initialization
	// Specify the fixed size and type. Arrays are initialized to zero values by default.
	var nums [3]int
	names := [2]string{"Alice", "Bob"}
	fmt.Println("Empty nums array:", nums)
	fmt.Println("Initialized names array:", names)

	
	// 2. The '...' Ellipsis
	// Let the Go compiler count the elements for you.
	colors := [...]string{"red", "green", "blue"}
	fmt.Println("Colors length:", len(colors))

	
	// 3. Accessing and Modifying
	// Access elements using their zero-based index.
	nums[0] = 42
	fmt.Println("First element of nums is now:", nums[0])
}

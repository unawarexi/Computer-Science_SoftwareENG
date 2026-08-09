package functionsandpointers

import "fmt"

// DemonstratePointers showcases how to use pointers in Go.
func DemonstratePointers() {
	// 1. Creating and Using Pointers
	// The & (Address-of) operator gets the memory address of a variable.
	var x int = 10
	var p *int = &x // p holds the memory address of x

	fmt.Println("Value of x:", x)
	fmt.Println("Memory address of x (p):", p)

	// 2. Dereferencing Pointers
	// The * (Dereference) operator reads or updates the underlying value at the pointer's address.
	*p = 21 // Sets x to 21 through the pointer
	fmt.Println("New value of x after *p = 21:", x)

	// 3. Pointers in Functions
	// Pass pointers to functions to allow them to mutate the original variable.
	fmt.Println("Before increment:", x)
	increment(&x)
	fmt.Println("After increment:", x)

	// 4. No Pointer Arithmetic
	// In Go, you cannot do things like p++. This ensures memory safety.
}

// increment modifies the original integer value directly via a pointer.
func increment(val *int) {
	*val++ // Dereferences and increments the underlying value
}

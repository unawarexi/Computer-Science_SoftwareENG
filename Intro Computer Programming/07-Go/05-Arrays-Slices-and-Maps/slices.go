package arraysslicesandmaps

import "fmt"

// DemonstrateSlices showcases how to use slices in Go.
func DemonstrateSlices() {
	// 1. Declaration and Initialization
	// Like an array, but without a specified length.
	var emptySlice []int // nil slice
	scores := []int{90, 85, 100}
	fmt.Println("Empty slice:", emptySlice)
	fmt.Println("Scores:", scores)


	// 2. Using make()
	// Pre-allocate a slice with a specific length and capacity.
	// make(type, length, capacity)
	buffer := make([]byte, 5, 10)
	fmt.Println("Buffer via make:", buffer)


	// 3. Slicing Existing Arrays or Slices
	// Create a slice using a half-open range [low:high].
	letters := []string{"a", "b", "c", "d"}
	subset := letters[1:3] // Contains "b" and "c"
	fmt.Println("Subset:", subset)


	// 4. Length vs Capacity (len and cap)
	// Length is current elements, capacity is max elements.
	fmt.Println("Buffer length:", len(buffer))
	fmt.Println("Buffer capacity:", cap(buffer))

	
	// 5. The append() Function
	// Add elements dynamically. Reallocates underlying array if needed.
	scores = append(scores, 95)
	scores = append(scores, 88, 92) // Appending multiple items
	fmt.Println("Scores after append:", scores)
}

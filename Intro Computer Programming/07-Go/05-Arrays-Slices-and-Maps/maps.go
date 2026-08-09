package arraysslicesandmaps

import "fmt"

// DemonstrateMaps showcases how to use maps in Go.
func DemonstrateMaps() {
	// 1. Declaration and Initialization
	// Maps must be initialized before use.
	ages := make(map[string]int)
	ages["Alice"] = 30
	codes := map[string]string{"NY": "New York", "CA": "California"}
	fmt.Println("Ages map:", ages)

	
	// 2. Accessing and Modifying
	// Use the key inside square brackets.
	codes["TX"] = "Texas"
	fmt.Println("Code for NY:", codes["NY"])
	

	// 3. The "Comma OK" Idiom (Checking Existence)
	// Safely check if a key exists without confusing it with a zero-value.
	age, exists := ages["Bob"]
	if !exists {
		fmt.Println("Bob is not in the ages map (zero value was:", age, ")")
	}

	
	// 4. Deleting Elements
	// Remove a key-value pair.
	delete(codes, "NY")
	fmt.Println("Codes after deleting NY:", codes)


	// 5. Iterating Over Maps
	// Use range to loop through key-value pairs (order is randomized!).
	fmt.Println("Iterating over codes:")
	for key, value := range codes {
		fmt.Println(key, ":", value)
	}
}

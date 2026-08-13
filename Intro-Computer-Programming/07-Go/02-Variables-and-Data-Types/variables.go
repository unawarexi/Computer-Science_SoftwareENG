package variablesanddatatypes

import "fmt"

// DemonstrateVariables showcases the different ways to declare variables in Go.
func DemonstrateVariables() {
	// 1. Explicit Declaration using 'var'
	// The type is explicitly defined.
	var name string = "Alice"
	var age int = 30


	// 2. Implicit Declaration (Type Inference)
	// Go infers the type from the assigned value.
	var city = "New York"
	var isActive = true


	// 3. Short Variable Declaration (:=)
	// Commonly used inside functions. Combines declaration and assignment.
	country := "Canada"
	population := 38000000


	// 4. Multiple Variable Declarations
	// Declaring multiple variables in a single line.
	var x, y, z int = 1, 2, 3
	a, b := "Hello", 100


	// 5. Block Declarations
	// Grouping variables together for cleaner code.
	var (
		firstName string = "Bob"
		lastName  string = "Smith"
		userAge   int    = 25
	)


	// 6. Zero Values
	// Variables declared without initialization get a default "zero value".
	var uninitializedInt int       // 0
	var uninitializedString string // ""
	var uninitializedBool bool     // false

	
	// Print all variables to avoid "unused variable" compilation errors
	fmt.Println(name, age, city, isActive, country, population)
	fmt.Println(x, y, z, a, b)
	fmt.Println(firstName, lastName, userAge)
	fmt.Println("Zero values:", uninitializedInt, uninitializedString, uninitializedBool)
}

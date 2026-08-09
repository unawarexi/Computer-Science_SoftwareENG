package variablesanddatatypes

import "fmt"

// DemonstrateOperators showcases how to use different operators in Go.
func DemonstrateOperators() {
	a := 10
	b := 3
	// 1. Arithmetic Operators
	// Used to perform common mathematical operations.
	sum := a + b        // Addition: 13
	diff := a - b       // Subtraction: 7
	prod := a * b       // Multiplication: 30
	quotient := a / b   // Division: 3 (integer division drops the remainder)
	remainder := a % b  // Modulus: 1 (returns the remainder)


	// 2. Relational (Comparison) Operators
	// Used to compare two values, returns a boolean (true/false).
	isEqual := (a == b)      // Equal to: false
	isNotEqual := (a != b)   // Not equal to: true
	isGreater := (a > b)     // Greater than: true
	isLess := (a < b)        // Less than: false


	// 3. Logical Operators
	// Used to determine the logic between variables or values.
	t := true
	f := false
	logicalAnd := t && f // Logical AND: false (both must be true)
	logicalOr := t || f  // Logical OR: true (one must be true)
	logicalNot := !t     // Logical NOT: false (reverses the boolean)


	// 4. Assignment Operators
	// Used to assign values to variables.
	c := 5               // Simple assignment
	c += 2               // Add and assign (c = c + 2) -> 7
	c *= 2               // Multiply and assign (c = c * 2) -> 14

	
	// Print results
	fmt.Println("Arithmetic:", sum, diff, prod, quotient, remainder)
	fmt.Println("Relational:", isEqual, isNotEqual, isGreater, isLess)
	fmt.Println("Logical:", logicalAnd, logicalOr, logicalNot)
	fmt.Println("Assignment Result:", c)
}

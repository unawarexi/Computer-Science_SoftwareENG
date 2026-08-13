package functionsandpointers

import "fmt"

// DemonstrateFunctions showcases how to use functions in Go.
func DemonstrateFunctions() {
	// 1. Function Declarations
	// Calls a function with standard parameters and a return value.
	sumResult := add(5, 3)
	fmt.Println("5 + 3 =", sumResult)

	// 2. Multiple Return Values
	// Go functions can return more than one value, often used for error handling.
	result, err := divide(10.0, 2.0)
	if err == nil {
		fmt.Printf("10.0 / 2.0 = %.2f\n", result)
	}

	// 2.5 Ignoring Return Values
	// Use the blank identifier '_' to discard unwanted return values.
	onlyResult, _ := divide(20.0, 4.0)
	fmt.Printf("20.0 / 4.0 (ignoring error) = %.2f\n", onlyResult)

	// 3. Named Return Values
	// Calling 'return' without arguments returns the named variables.
	x, y := split(17)
	fmt.Println("Split 17 into:", x, "and", y)

	// 4. Variadic Functions
	// Functions that can accept a variable number of arguments.
	total := sumVariadic(1, 2, 3, 4, 5)
	fmt.Println("Sum of 1, 2, 3, 4, 5 is", total)
	// 5. Callback Functions (Functions as Values)
	// Passing a function as an argument to another function.
	executeCallback(printMessage, "Hello via Callback!")

	// 6. Guard Clauses (Early Returns)
	// Returning early upon encountering an error to avoid deep nesting.
	err = processData("")
	if err != nil {
		fmt.Println("Error processing data:", err)
	}
}

// add demonstrates a basic function declaration.
func add(x int, y int) int {
	return x + y
}

// divide demonstrates multiple return values.
func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, fmt.Errorf("division by zero")
	}
	return a / b, nil
}

// split demonstrates named return values.
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return // naked return
}

// sumVariadic demonstrates variadic parameters using an ellipsis (...).
func sumVariadic(numbers ...int) int {
	total := 0
	for _, num := range numbers {
		total += num
	}
	return total
}

// executeCallback takes a function as an argument and executes it.
func executeCallback(callback func(string), message string) {
	callback(message)
}

// printMessage is a simple function to be used as a callback.
func printMessage(msg string) {
	fmt.Println(msg)
}

// processData demonstrates the use of a guard clause for early returns.
func processData(data string) error {
	if data == "" {
		return fmt.Errorf("empty data provided") // Guard clause
	}
	
	// Main logic proceeds without extra nesting
	fmt.Println("Processing data:", data)
	return nil
}

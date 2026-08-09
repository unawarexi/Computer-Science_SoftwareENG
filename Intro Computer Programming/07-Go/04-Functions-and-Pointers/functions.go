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

	// 3. Named Return Values
	// Calling 'return' without arguments returns the named variables.
	x, y := split(17)
	fmt.Println("Split 17 into:", x, "and", y)

	// 4. Variadic Functions
	// Functions that can accept a variable number of arguments.
	total := sumVariadic(1, 2, 3, 4, 5)
	fmt.Println("Sum of 1, 2, 3, 4, 5 is", total)
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

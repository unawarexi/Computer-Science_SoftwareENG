package variablesanddatatypes

import (
	"fmt"
	"strconv"
	"strings"
)

// The functions below are methods/functions that manipulate different data types.
// ManipulateStrings demonstrates various string operations.
func ManipulateStrings(firstName, lastName string) string {
	// 1. Basic concatenation using '+'
	fullName := firstName + " " + lastName


	// 2. Concatenation using fmt.Sprintf for formatting
	// %s is the verb for string formatting
	formattedGreeting := fmt.Sprintf("Hello, %s!", fullName)


	// 3. Advanced concatenation using strings.Builder (better performance for large strings)
	var builder strings.Builder
	builder.WriteString(formattedGreeting)
	builder.WriteString(" Welcome to Go.")
	return builder.String()
}


// ManipulateNumbers demonstrates basic numeric operations.
func ManipulateNumbers(price float64, quantity int) float64 {
	// Must explicitly convert integer 'quantity' to float64 to multiply
	totalCost := price * float64(quantity)
	
	// Apply a 10% discount
	discount := totalCost * 0.10
	return totalCost - discount
}


// ManipulateBooleans takes a condition and returns an opposite status string.
func ManipulateBooleans(isActive bool) string {
	// Toggling the boolean state using the NOT operator (!)
	isSuspended := !isActive
	if isSuspended {
		return "Account is suspended."
	}
	return "Account is active."
}


// ConvertTypes demonstrates how to convert strings to integers and vice-versa.
func ConvertTypes(numStr string) (string, error) {
	// Convert String to Integer using strconv.Atoi
	// Returns the integer and an error if the string is not a valid number
	numInt, err := strconv.Atoi(numStr)
	if err != nil {
		return "", err
	}
	
	// Manipulate the integer
	numInt += 50

	// Convert Integer back to String using strconv.Itoa
	finalStr := strconv.Itoa(numInt)
	return finalStr, nil
}

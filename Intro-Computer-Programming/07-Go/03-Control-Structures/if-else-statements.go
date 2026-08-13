package controlstructures

import "fmt"

// DemonstrateIfElse showcases how to use if, else if, and else statements in Go.
func DemonstrateIfElse() {
	// 1. Basic If-Else Statement
	// Evaluates the boolean condition; no parentheses required around the condition.
	age := 20
	if age >= 18 {
		fmt.Println("You are an adult.")
	} else {
		fmt.Println("You are a minor.")
	}

	// 2. If, Else If, Else Chain
	// Evaluates multiple conditions sequentially.
	score := 85
	if score >= 90 {
		fmt.Println("Grade: A")
	} else if score >= 80 {
		fmt.Println("Grade: B")
	} else {
		fmt.Println("Grade: C or below")
	}

	// 3. If with Initialization Statement
	// Variables declared here (like 'count') only exist within the if/else scope.
	if count := 15; count > 10 {
		fmt.Println("Count is high:", count)
	} else {
		fmt.Println("Count is low:", count)
	}
	// Note: 'count' is inaccessible here.
}

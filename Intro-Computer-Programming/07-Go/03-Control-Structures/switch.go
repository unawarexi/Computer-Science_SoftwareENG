package controlstructures

import "fmt"

// DemonstrateSwitch showcases how to use switch statements in Go.
func DemonstrateSwitch() {
	// 1. Basic Switch Statement (No Automatic Fallthrough & Multiple Values)
	// Evaluates a variable against a series of case values.
	// You can test multiple values in a single case using commas.
	day := "Saturday"
	switch day {
	case "Saturday", "Sunday":
		fmt.Println("Weekend")
	default:
		fmt.Println("Weekday")
	}

	// 2. Switch without an Expression
	// Acts exactly like a clean chain of if-else statements.
	score := 85
	switch {
	case score >= 90:
		fmt.Println("Grade: A")
	case score >= 80:
		fmt.Println("Grade: B")
	default:
		fmt.Println("Grade: C or below")
	}

	// 3. Switch with Fallthrough
	// Use the 'fallthrough' keyword if you want the logic to bleed into the next case.
	value := 1
	switch value {
	case 1:
		fmt.Println("Executing case 1")
		fallthrough
	case 2:
		fmt.Println("Executing case 2 because of fallthrough")
	default:
		fmt.Println("Other")
	}
}

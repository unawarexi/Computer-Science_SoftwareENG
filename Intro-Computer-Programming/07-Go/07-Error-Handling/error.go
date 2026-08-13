package errorhandling

import (
	"errors"
	"fmt"
)

// --- 4. Custom Error Types ---
// NotFoundError is a custom error type implementing the error interface.
type NotFoundError struct {
	ID int
}

func (e *NotFoundError) Error() string {
	return fmt.Sprintf("record %d not found", e.ID)
}

// --- 3. Creating Basic Errors ---
// doSomething simulates a function returning a basic error.
func doSomething(shouldFail bool) (string, error) {
	if shouldFail {
		return "", errors.New("something went wrong")
	}
	return "success", nil
}

// --- 5. Error Wrapping ---
// fetch simulates fetching a record and wrapping a custom error.
func fetch(id int) error {
	// Simulate a database failure using our custom error
	dbErr := &NotFoundError{ID: id}

	// Wrap the underlying dbErr with more context using %w.
	return fmt.Errorf("fetch failed: %w", dbErr)
}

// DemonstrateErrorHandling showcases error handling, panic, and recover in Go.
func DemonstrateErrorHandling() {
	// --- 8. The defer Statement & 10. Recover ---
	// Defer a function to recover from any panics that might occur below.
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic:", r)
		}
	}()

	// --- 2. Returning and Checking Errors ---
	result, err := doSomething(true)
	if err != nil { // Guard clause
		fmt.Println("Error doing something:", err)
	} else {
		fmt.Println("Result:", result)
	}

	// --- 6. Inspecting Errors (errors.Is) ---
	baseErr := errors.New("base database error")
	wrappedErr := fmt.Errorf("query failed: %w", baseErr)
	
	// Check if baseErr is anywhere in the chain of wrappedErr
	if errors.Is(wrappedErr, baseErr) {
		fmt.Println("wrappedErr contains baseErr!")
	}

	// --- 7. Extracting Errors (errors.As) ---
	fetchErr := fetch(404)
	var notFound *NotFoundError
	
	// Extract the custom NotFoundError out of the wrapped fetchErr chain
	if errors.As(fetchErr, &notFound) {
		fmt.Printf("Extracted Custom Error - Missing ID: %d\n", notFound.ID)
	}

	// --- 9. Panic ---
	fmt.Println("About to trigger a panic...")
	panic("critical system failure!")
	
	// Execution stops before this line; the deferred recover() function will run instead.
	// fmt.Println("This line will never be reached")
}

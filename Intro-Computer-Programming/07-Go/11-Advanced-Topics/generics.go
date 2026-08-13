package advancedtopics

import "fmt"

// =============================================================================
// SECTION 1: Type Parameters (Basic Generics)
// =============================================================================

// PrintAnything is a generic function. [T any] declares a type parameter T
// constrained by 'any', meaning T can be literally any Go type.
// This replaces the need to write separate functions for int, string, etc.
func PrintAnything[T any](thing T) {
	fmt.Println(thing)
}

// =============================================================================
// SECTION 2: Type Constraints
// =============================================================================

// Number is a custom type constraint — an interface that restricts what types
// can be used as T. Only 'int' or 'float64' satisfy this constraint.
type Number interface {
	int | float64
}

// Add is a generic function that uses the Number constraint.
// The compiler guarantees the '+' operator will work because only
// types supporting '+' (int, float64) are allowed.
func Add[T Number](a, b T) T {
	return a + b
}

// =============================================================================
// SECTION 3: The `comparable` Constraint
// =============================================================================

// Find searches for a target in a slice and returns its index.
// [T comparable] means T must support == and !=, which is required
// for map keys and direct equality comparisons.
func Find[T comparable](slice []T, target T) int {
	for i, val := range slice {
		if val == target {
			return i
		}
	}
	return -1 // Not found
}

// =============================================================================
// SECTION 4: Generic Data Structures
// =============================================================================

// Stack is a generic LIFO (Last-In, First-Out) data structure.
// By parameterising with [T any], a single Stack definition works
// for Stack[int], Stack[string], or any other type.
type Stack[T any] struct {
	items []T
}

// Push adds an item to the top of the Stack.
func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

// Pop removes and returns the top item. Returns the zero value and false if empty.
func (s *Stack[T]) Pop() (T, bool) {
	var zero T
	if len(s.items) == 0 {
		return zero, false
	}
	top := s.items[len(s.items)-1]
	s.items = s.items[:len(s.items)-1]
	return top, true
}

// Peek returns the top item without removing it.
func (s *Stack[T]) Peek() (T, bool) {
	var zero T
	if len(s.items) == 0 {
		return zero, false
	}
	return s.items[len(s.items)-1], true
}

// IsEmpty reports whether the stack has no items.
func (s *Stack[T]) IsEmpty() bool {
	return len(s.items) == 0
}

// =============================================================================
// DemonstrateGenerics runs all generics examples.
// =============================================================================
func DemonstrateGenerics() {
	fmt.Println("--- 1. Type Parameters ---")
	// Explicit type argument
	PrintAnything[string]("Hello, Generics!")
	// Implicit type inference — Go deduces T is int from the argument '42'
	PrintAnything(42)
	PrintAnything(3.14)

	fmt.Println("\n--- 2. Type Constraints ---")
	// Add works for both int and float64 thanks to the Number constraint
	intSum := Add(10, 20)
	floatSum := Add(1.5, 2.5)
	fmt.Printf("Add(10, 20)   = %d\n", intSum)
	fmt.Printf("Add(1.5, 2.5) = %.1f\n", floatSum)

	fmt.Println("\n--- 3. comparable Constraint ---")
	fruits := []string{"apple", "banana", "cherry"}
	idx := Find(fruits, "banana")
	fmt.Printf("Find(fruits, \"banana\") -> index %d\n", idx) // index 1

	numbers := []int{10, 20, 30, 40}
	notFound := Find(numbers, 99)
	fmt.Printf("Find(numbers, 99)      -> index %d (not found)\n", notFound) // -1

	fmt.Println("\n--- 4. Generic Stack Data Structure ---")
	var intStack Stack[int]
	intStack.Push(1)
	intStack.Push(2)
	intStack.Push(3)

	if top, ok := intStack.Peek(); ok {
		fmt.Println("Peek (top of int stack):", top) // 3
	}
	for !intStack.IsEmpty() {
		val, _ := intStack.Pop()
		fmt.Println("Popped:", val) // 3, 2, 1 (LIFO order)
	}

	// Same Stack type works perfectly for strings — no code duplication!
	var strStack Stack[string]
	strStack.Push("go")
	strStack.Push("generics")
	if top, ok := strStack.Pop(); ok {
		fmt.Println("Popped from string stack:", top) // generics
	}
}

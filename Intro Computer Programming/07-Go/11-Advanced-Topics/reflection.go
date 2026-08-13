package advancedtopics

import (
	"fmt"
	"reflect"
)

// =============================================================================
// SECTION 1: Type and Value
// reflect.TypeOf() and reflect.ValueOf() are the two entry points into
// Go's reflection system. They let you inspect variables at runtime.
// =============================================================================

func demonstrateTypeAndValue() {
	fmt.Println("--- 1. Type and Value ---")

	var x float64 = 3.14

	// reflect.TypeOf returns the dynamic type of the variable
	t := reflect.TypeOf(x)
	fmt.Println("Type:", t) // float64

	// reflect.ValueOf returns a Value holding the variable's data
	v := reflect.ValueOf(x)
	fmt.Println("Value:", v)          // 3.14
	fmt.Println("Kind:", v.Kind())    // float64 (the underlying kind)
	fmt.Println("Float:", v.Float())  // 3.14 (accessing the raw value)

	// You can also inspect slices and maps
	nums := []int{1, 2, 3}
	fmt.Println("\nSlice Type:", reflect.TypeOf(nums))   // []int
	fmt.Println("Slice Kind:", reflect.TypeOf(nums).Kind()) // slice
}

// =============================================================================
// SECTION 2: Inspecting Structs and Tags
// This is the core use case of reflection — reading struct field names, types,
// and their metadata tags (e.g., json, database, validate tags).
// =============================================================================

// Employee is a sample struct with custom struct tags.
// The 'database' tag is purely for demonstration — in real projects you'll
// see 'json', 'db', 'yaml', 'validate', etc.
type Employee struct {
	Name   string `database:"col_name"   json:"name"`
	Age    int    `database:"col_age"    json:"age"`
	Salary float64 `database:"col_salary" json:"-"` // '-' means "skip in JSON"
}

func demonstrateStructInspection() {
	fmt.Println("\n--- 2. Inspecting Struct Fields and Tags ---")

	e := Employee{Name: "Alice", Age: 28, Salary: 75000}
	t := reflect.TypeOf(e) // Get the reflect.Type of Employee

	fmt.Printf("Struct Name: %s\n", t.Name()) // Employee
	fmt.Printf("Number of Fields: %d\n\n", t.NumField())

	// Iterate over each field in the struct
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)

		// Read the struct tag values for specific keys
		dbTag := field.Tag.Get("database")
		jsonTag := field.Tag.Get("json")

		fmt.Printf("Field %-10s | Type: %-8s | db tag: %-12s | json tag: %s\n",
			field.Name, field.Type, dbTag, jsonTag)
	}

	// We can also use reflect.ValueOf to read field values at runtime
	v := reflect.ValueOf(e)
	fmt.Printf("\nValue of 'Name' field: %v\n", v.FieldByName("Name"))
}

// =============================================================================
// SECTION 3: Modifying Values via Reflection
// To set a value via reflection you MUST pass a pointer, then call .Elem()
// to dereference it. Trying to set a non-pointer value causes a panic.
// =============================================================================

func demonstrateModifyingValues() {
	fmt.Println("\n--- 3. Modifying Values via Reflection ---")

	name := "John"
	fmt.Println("Before:", name)

	// 1. Pass a POINTER to reflect.ValueOf — critical!
	v := reflect.ValueOf(&name)

	// 2. Use Elem() to get the settable underlying value (dereferences the pointer)
	elem := v.Elem()

	// 3. Check CanSet() before setting — it's safer than panicking
	if elem.CanSet() {
		elem.SetString("Doe")
	}

	fmt.Println("After :", name) // Doe

	// Modifying an int field inside a struct via a pointer
	type Config struct {
		MaxRetries int
		Timeout    float64
	}
	cfg := Config{MaxRetries: 3, Timeout: 30.0}

	cfgVal := reflect.ValueOf(&cfg).Elem()
	cfgVal.FieldByName("MaxRetries").SetInt(10)
	cfgVal.FieldByName("Timeout").SetFloat(60.0)

	fmt.Printf("Modified Config: %+v\n", cfg)
}

// =============================================================================
// DemonstrateReflection runs all reflection examples.
// =============================================================================
func DemonstrateReflection() {
	demonstrateTypeAndValue()
	demonstrateStructInspection()
	demonstrateModifyingValues()

	fmt.Println("\n--- ⚠️ Reflection Warnings ---")
	fmt.Println("1. PERFORMANCE: Reflection is significantly slower than direct typed code.")
	fmt.Println("2. SAFETY: Errors become runtime panics, not compile-time errors.")
	fmt.Println("3. READABILITY: Heavy use of reflection makes code harder to maintain.")
	fmt.Println("→ Prefer Interfaces or Generics whenever possible over Reflection.")
}

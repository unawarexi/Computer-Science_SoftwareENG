package structsandinterfaces

import "fmt"

// Person is a basic struct.
type Person struct {
	Name string
	Age  int
}

// Address represents a location.
type Address struct {
	City string
}

// Employee demonstrates nested vs embedded structs.
type Employee struct {
	Home   Address // Nested struct (must access via Home.City)
	Person         // Embedded struct (fields are promoted)
}

// Greet is a method with a value receiver.
func (p Person) Greet() string {
	return "Hi, I am " + p.Name
}

// HaveBirthday is a method with a pointer receiver.
func (p *Person) HaveBirthday() {
	p.Age++ // Modifies the original struct
}

// User demonstrates struct tags.
type User struct {
	Name string `json:"username"`
	Age  int    `json:"age,omitempty"`
}

// DemonstrateStructs showcases struct features.
func DemonstrateStructs() {
	// 1. Defining and Initializing Structs
	p := Person{Name: "Alice", Age: 30}

	// 2. Accessing and Modifying Fields
	p.Age = 31
	fmt.Println("Person name:", p.Name)

	// 3. Pointers to Structs
	pPointer := &p
	pPointer.Age = 32 // Automatically dereferenced
	fmt.Println("Age via pointer:", p.Age)

	// 4. Anonymous Structs
	user := struct{ Name string }{
		Name: "Bob",
	}
	fmt.Println("Anonymous user:", user.Name)

	// 5. Nested vs Embedded Structs
	e := Employee{
		Home:   Address{City: "New York"},
		Person: Person{Name: "Charlie", Age: 40},
	}
	fmt.Println("Nested City:", e.Home.City)
	fmt.Println("Embedded Name:", e.Name) // Promoted field

	// 6. Struct Methods
	fmt.Println(p.Greet())
	p.HaveBirthday()
	fmt.Println("Age after birthday:", p.Age)
}

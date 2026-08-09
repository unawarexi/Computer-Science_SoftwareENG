package structsandinterfaces

import "fmt"

// Speaker is an interface defining a behavior.
type Speaker interface {
	Speak() string
}

// Dog is a struct that will implicitly implement Speaker.
type Dog struct{}

// Speak implements the Speaker interface for Dog.
func (d Dog) Speak() string {
	return "Woof!"
}

// MakeSound accepts any type that implements Speaker.
func MakeSound(s Speaker) {
	fmt.Println(s.Speak())
} 

// PrintAnything demonstrates the empty interface.
func PrintAnything(value any) {
	fmt.Println("Value is:", value)
}

// DemonstrateInterfaces showcases interface features.
func DemonstrateInterfaces() {
	// 1. Implicit Implementation (Duck Typing)
	var mySpeaker Speaker = Dog{}
	
	// 2. Using Interfaces
	MakeSound(mySpeaker)

	// 3. The Empty Interface
	PrintAnything(42)
	PrintAnything("Hello")

	// 4. Type Assertions
	var i any = "hello"
	str, ok := i.(string)
	if ok {
		fmt.Println("Asserted string:", str)
	}

	// 5. Type Switches
	switch v := i.(type) {
	case int:
		fmt.Println("It's an int:", v)
	case string:
		fmt.Println("It's a string:", v)
	}
}

// Reader and Writer demonstrate interface embedding.
type Reader interface{ Read() }
type Writer interface{ Write() }
type ReadWriter interface {
	Reader
	Writer
}

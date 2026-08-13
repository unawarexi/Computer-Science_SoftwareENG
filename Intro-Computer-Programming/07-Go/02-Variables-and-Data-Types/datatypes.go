package variablesanddatatypes

import (
	"fmt"
)

// DemonstrateDataTypes showcases Go's basic data types and type conversion.
func DemonstrateDataTypes() {
	// 1. Numeric Types: Integers
	var smallInt int8 = 127         // 8-bit integer
	var regularInt int = 10000      // Platform dependent (32 or 64 bit)
	var unsignedInt uint = 500      // Unsigned (positive numbers only)
	var myByte byte = 255           // Alias for uint8, commonly used for raw data


	// 2. Numeric Types: Floating Point
	var floatNum float32 = 3.14     // 32-bit floating point
	var doubleNum float64 = 9.8123  // 64-bit floating point (default for decimals)


	// 3. Numeric Types: Complex Numbers
	var compNum complex64 = 5 + 7i  // Complex number with float32 real and imaginary parts


	// 4. Boolean Type
	var isGolangFun bool = true     // true or false


	// 5. String Type
	var greeting string = "Hello"   // Read-only slice of bytes (immutable)
	var myRune rune = 'A'           // Alias for int32, represents a single Unicode character


	// 6. Type Conversion (Casting)
	// Go requires explicit conversion between different data types.
	var i int = 42
	var f float64 = float64(i)      // Convert int to float64
	var u uint = uint(f)            // Convert float64 to uint

	
	// Print all variables to avoid "unused variable" compilation errors
	fmt.Printf("Ints: %v, %v, %v, %v\n", smallInt, regularInt, unsignedInt, myByte)
	fmt.Printf("Floats: %v, %v\n", floatNum, doubleNum)
	fmt.Printf("Complex: %v\n", compNum)
	fmt.Printf("Boolean: %v\n", isGolangFun)
	fmt.Printf("String and Rune: %v, %c\n", greeting, myRune)
	fmt.Printf("Converted: int=%v, float=%v, uint=%v\n", i, f, u)
}

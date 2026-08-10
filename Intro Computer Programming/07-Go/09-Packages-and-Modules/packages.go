package packagesandmodules

import (
	"fmt"
	"math/rand" // Importing a standard library package
)

// DemonstratePackages showcases exported and unexported identifiers.
func DemonstratePackages() {
	fmt.Println("Demonstrating packages and visibility rules.")
	
	// Calling an unexported function from within the same package is allowed.
	result := calculateInternalLogic()
	fmt.Println("Internal logic result:", result)
	
	// Calling an exported function (this could be called from other packages too).
	PublicAPI()
}

// PublicAPI is an exported function because it starts with a capital letter.
// Functions, types, or variables starting with a capital letter can be imported and used by other packages.
func PublicAPI() {
	// Using an exported function 'Intn' from the imported 'rand' package
	fmt.Println("Public API called. Random number:", rand.Intn(100))
}

// calculateInternalLogic is unexported because it starts with a lowercase letter.
// It is strictly internal to the 'packagesandmodules' package.
func calculateInternalLogic() int {
	return 42
}

package packagesandmodules

import (
	"fmt"
	
	// Third-party packages are imported using their module path, typically a URL.
	// To actually run this code, you must first:
	// 1. Initialize a Go module in this directory: `go mod init mymodule`
	// 2. Download the dependency: `go get github.com/google/uuid`
	"github.com/google/uuid"
)

// DemonstrateThirdParty showcases how to import and use external libraries.
func DemonstrateThirdParty() {
	fmt.Println("Demonstrating third-party packages.")
	
	// We can now use the exported functions and types from the 'uuid' package
	// just like we do with standard library packages.
	newUUID := uuid.New()
	
	fmt.Printf("Generated a random UUID: %s\n", newUUID.String())
	fmt.Println("This functionality was provided by the external module 'github.com/google/uuid'!")
}

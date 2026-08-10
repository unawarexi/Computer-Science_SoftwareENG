# Packages and Modules in Go

Go was designed from the ground up to support large-scale software engineering. A key part of this design is how Go code is organized, reused, and distributed. This is achieved through a hierarchy of **Packages** and **Modules**.

## Packages

A package is a collection of source files in the same directory that are compiled together. Functions, types, variables, and constants defined in one source file are visible to all other source files within the same package. Packages act as the fundamental unit of modularity, code reuse, and encapsulation in Go.

### Visibility (Exported vs Unexported)

Go uses a brilliantly simple rule for visibility: if the name of a top-level variable, function, or type starts with a **capital letter** (e.g., `fmt.Println`), it is **exported** and accessible from other packages. If it starts with a **lowercase letter** (e.g., `math.pi`), it is unexported and internal to the package.

```go
// Exported: Can be imported and used elsewhere
func CalculateTotal() int { return 100 }

// Unexported: Internal to this package only
func calculateTax() int { return 10 }
```

### Importing

To use the exported identifiers from another package, you must import it using the `import` keyword. Go's compiler strictly enforces that all imported packages must be used, preventing bloated binaries and messy codebases.

```go
import (
    "fmt"
    "github.com/google/uuid"
)
```

## Modules

While packages organize code within a single project, **Modules** are how Go manages dependencies *between* projects. A module is a collection of related Go packages that are versioned together as a single unit. Modules solve the infamous dependency hell by precisely tracking which versions of external libraries your project requires.

### Creating Modules

To start a new Go project, you initialize a module using the `go mod init` command. This establishes the project's identity (its module path) and creates the foundation for dependency tracking. The module path is usually a URL where the code can be downloaded.

```bash
# Initialize in the current directory
go mod init github.com/username/myproject
```

### `go.mod`

The `go.mod` file is the heart of a Go module. It defines the module's path, the minimum required Go version, and explicitly lists all the external modules (and their specific versions) that the project depends on. When you import a new package and run `go build` or `go test`, Go automatically updates this file.

```go
module github.com/username/myproject

go 1.20

require github.com/google/uuid v1.3.0
```

### `go.sum`

Alongside `go.mod`, Go automatically generates a `go.sum` file. This file contains cryptographic checksums for the exact content of specific module versions you downloaded. This is a crucial security feature: it guarantees that the code you depend on hasn't been maliciously altered or accidentally changed since you first downloaded it, ensuring reproducible builds across any environment.

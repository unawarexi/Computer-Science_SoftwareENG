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

---

## Modules

While packages organize code within a single project, **Modules** are how Go manages dependencies *between* projects. A module is a collection of related Go packages that are versioned together as a single unit. Modules solve the infamous dependency hell by precisely tracking which versions of external libraries your project requires.

### Creating Modules

To start a new Go project, you initialize a module using the `go mod init` command. This establishes the project's identity (its module path) and creates the foundation for dependency tracking. The module path is usually a URL where the code can be downloaded.

```bash
# Initialize in the current directory
go mod init github.com/username/myproject
```

---

## `go.mod` — The Module Manifest

The `go.mod` file is the heart of a Go module. It defines the module's path, the minimum required Go version, and explicitly lists all the external modules (and their specific versions) that the project depends on. When you import a new package and run `go build` or `go test`, Go automatically updates this file.

```go
module github.com/username/myproject

go 1.21

require (
    github.com/google/uuid v1.3.0
    github.com/gin-gonic/gin v1.9.1
)
```

### The `require` Directive

`require` is the most important directive in `go.mod`. It lists every external module your project directly depends on, along with its **exact semantic version** (e.g., `v1.3.0`). Go guarantees reproducible builds by always using precisely the version listed here.

```go
require (
    // Direct dependency — used directly in your code
    github.com/google/uuid v1.3.0

    // Indirect dependency (marked with '// indirect') — required by one of your
    // direct dependencies, but not imported directly by your code
    golang.org/x/sys v0.12.0 // indirect
)
```

You can add a requirement by running:
```bash
go get github.com/google/uuid@v1.3.0
```

### The `replace` Directive

The `replace` directive is a powerful tool that overrides where Go resolves a module. This is used in three common scenarios:

**1. Local Development / Testing a Fork:**
When you are developing a dependency locally alongside your project, `replace` lets you point at a local directory instead of the published version on the internet.

```go
require github.com/my-org/mylib v1.0.0

// Replace the published module with your local version on disk.
// The right-hand side is a relative or absolute filesystem path.
replace github.com/my-org/mylib => ../mylib
```

**2. Patching a Bug in a Third-Party Module:**
If you need to fix a bug in someone else's library and can't wait for them to release a new version, fork it, apply the fix, and replace the original with your fork.

```go
require github.com/original/library v1.2.3

// Use your fixed fork instead of the original
replace github.com/original/library => github.com/your-fork/library v1.2.3-patched
```

**3. Replacing a Specific Version:**
You can also replace just one version of a module with another version.

```go
replace github.com/some/module v1.0.0 => github.com/some/module v1.0.1
```

> **⚠️ Warning:** `replace` directives in a module only affect the root module's build. If you publish a library to `pkg.go.dev`, any `replace` directives in your `go.mod` will be **ignored** by users who import your library. `replace` is designed for applications (top-level modules), not libraries.

---

## `go.sum` — The Cryptographic Lock File

Alongside `go.mod`, Go automatically generates a `go.sum` file. This file contains cryptographic checksums (SHA-256 hashes) for the exact content of specific module versions you downloaded. This is a crucial security feature: it guarantees that the code you depend on hasn't been maliciously altered or accidentally changed since you first downloaded it, ensuring reproducible builds across any environment.

```
github.com/google/uuid v1.3.0 h1:t6JiXb mAZnueoENLqEjuWQ2P0VWHECi/bnL5/4kbS0=
github.com/google/uuid v1.3.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
```

Do not edit `go.sum` manually — the `go` tool manages it entirely.

---

## Useful Module Commands

| Command | Description |
|---|---|
| `go mod init <path>` | Initialize a new module |
| `go get <module>@<version>` | Add or update a dependency |
| `go mod tidy` | Remove unused dependencies, add missing ones |
| `go mod download` | Download all dependencies to the local cache |
| `go mod vendor` | Copy dependencies into a local `vendor/` directory |
| `go mod graph` | Print the module dependency graph |
| `go mod why <module>` | Explain why a module is needed |
| `go list -m all` | List all modules in the build |

See also: [`important-packages.md`](important-packages.md) for a comprehensive reference of standard library packages and popular third-party modules.

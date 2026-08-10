# Essential Go Commands Reference

Go is famous for its powerful, unified toolchain. Almost everything you need—building, testing, formatting, and package management—is built directly into the `go` CLI.

Below is a comprehensive tabular list of the most important inbuilt `go` commands, as well as industry-standard third-party CLI tools used in production environments.

## Inbuilt Go Commands

| Command | Category | Description |
|---|---|---|
| `go run main.go` | Run | Compiles and executes one or more Go files immediately. Perfect for local development. |
| `go build` | Build | Compiles the packages and their dependencies, creating an executable binary. |
| `go build -o app` | Build | Compiles the binary and explicitly names the output file "app". |
| `GOOS=linux GOARCH=amd64 go build` | Build | **Cross-compilation**: Compiles a binary specifically for a Linux OS on an AMD64 architecture, regardless of what machine you are currently on. |
| `go mod init <name>` | Modules | Initializes a new `go.mod` file, starting a new project. |
| `go mod tidy` | Modules | Adds missing modules and removes unused modules from `go.mod` and `go.sum`. Run this frequently! |
| `go mod vendor` | Modules | Copies all dependencies into a local `vendor/` folder for offline builds. |
| `go get <url>` | Modules | Downloads and installs a specific third-party package (e.g., `go get github.com/gin-gonic/gin`). |
| `go test ./...` | Testing | Recursively finds and runs all unit tests (`_test.go` files) in the current directory and all subdirectories. |
| `go test -v` | Testing | Runs tests in verbose mode, showing the name and result of every single test case. |
| `go test -bench=.` | Testing | Runs all Benchmark functions to measure performance. |
| `go test -cover` | Testing | Calculates and displays the code coverage percentage of your tests. |
| `go fmt ./...` | Code Quality | Automatically formats all Go code in your project to the strict, official Go style guidelines. |
| `go vet ./...` | Code Quality | Analyzes your code for subtle bugs and suspicious constructs that the compiler might miss. |
| `go env` | System | Prints Go environment information (paths, OS, architecture flags). |
| `go clean` | System | Removes object files and cached build artifacts to free up space. |
| `go doc <package>` | Documentation | Prints the documentation comments for a package or symbol directly in the terminal. |
| `go tool pprof` | Profiling | Opens an interactive CPU and Memory profiler to analyze performance bottlenecks. |

---

## Essential Third-Party CLI Tools

While the Go toolchain is fantastic, the open-source community provides several specialized tools that are considered industry standard for databases, APIs, and developer experience.

*Note: These must be installed separately, usually via `go install <url>`.*

| Command / Tool | Category | Description |
|---|---|---|
| `air` | Dev Experience | Live-reloading. Watches your `.go` files and automatically recompiles and restarts your server when you save changes. |
| `golangci-lint run` | Code Quality | The industry-standard "mega-linter". It runs dozens of different linters simultaneously to ensure flawless code quality. |
| `migrate create` / `up` / `down` | Database | Provided by `golang-migrate`. Manages database schema migrations (creating tables, altering columns) securely across environments. |
| `sqlc generate` | Database | Compiles raw SQL queries into type-safe Go code, eliminating the need for bulky ORMs and preventing runtime SQL errors. |
| `swag init` | APIs | Automatically generates OpenAPI/Swagger documentation by parsing special comments in your HTTP handlers. |
| `mockgen` | Testing | Generates mock implementations of Go interfaces. Essential for isolating dependencies during unit testing. |
| `wire` | Setup | A code generation tool by Google that automatically wires up Dependency Injection, making massive projects easier to initialize. |
| `protoc` (with Go plugins) | APIs | Compiles `.proto` (Protocol Buffer) files into Go structs and gRPC interfaces for building microservices. |

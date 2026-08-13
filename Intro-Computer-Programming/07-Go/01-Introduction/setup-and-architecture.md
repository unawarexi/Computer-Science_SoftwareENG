# Go Setup, Architecture, and Project Structure

Before writing enterprise-level code, you need a solid foundation. This guide covers how to set up your environment and how the Go community structures industry-grade, production-ready applications.

## 1. Setup Instructions

Setting up Go is famously straightforward.

1. **Install Go**: Download the installer for your operating system (Windows, macOS, or Linux) from the official website: [https://go.dev/dl/](https://go.dev/dl/).
2. **Verify Installation**: Open your terminal and run `go version`. You should see the installed version printed out.
3. **IDE Setup**: 
   - **VS Code**: Install the official **Go** extension by the Go Team at Google. It provides autocompletion, formatting, and debugging out of the box.
   - **GoLand**: JetBrains offers a powerful, dedicated Go IDE (paid, but excellent for enterprise work).
4. **Initialize a Project**: Create a new directory, navigate into it, and initialize a Go module to track dependencies:
   ```bash
   mkdir my-app && cd my-app
   go mod init github.com/yourusername/my-app
   ```

## 2. Industry-Grade Folder Structure

Unlike frameworks like Ruby on Rails or Django, Go does not enforce a strict folder structure. However, the industry has largely converged on the **Standard Go Project Layout**. 

Here is what a production-grade backend service looks like:

```text
my-app/
├── cmd/                # Main applications for this project
│   └── server/         # e.g., cmd/server/main.go (The entry point)
├── internal/           # Private application code (Cannot be imported by other projects!)
│   ├── config/         # Environment variables and config loading
│   ├── database/       # Database connections and migrations
│   ├── models/         # Data structures (User, Product, etc.)
│   ├── repository/     # Database queries (SQL/NoSQL interactions)
│   └── handlers/       # HTTP controllers/handlers (API endpoints)
├── pkg/                # Library code that is safe for OTHER projects to import
│   └── logger/         # e.g., A custom logging wrapper
├── api/                # OpenAPI/Swagger specs, JSON schema files, Protobuf files
├── configs/            # Configuration file templates (e.g., config.yaml)
├── scripts/            # Scripts for build, deployment, or database setup (bash/Makefiles)
├── deployments/        # IaaS, PaaS, Dockerfiles, Kubernetes manifests
├── go.mod              # Module dependencies
└── go.sum              # Dependency checksums (security)
```

**Key Takeaway**: The `internal/` directory is special in Go. The Go compiler physically prevents code in other repositories from importing packages located inside an `internal/` directory. This is how you enforce encapsulation in large projects.

## 3. Production Architecture Patterns

When organizing code within the `internal/` directory, industry-grade Go projects typically avoid "spaghetti code" by utilizing structural patterns.

### Clean Architecture (Ports and Adapters)
Go developers heavily favor separating business logic from infrastructure. A typical request flows like this:
1. **Transport Layer (Handlers)**: Extracts JSON from an HTTP request and passes it to the service layer. Knows *nothing* about databases.
2. **Service/Use-Case Layer**: Contains the pure business logic (e.g., "Check if user is 18 before creating an account"). It calls the repository layer via **Interfaces**.
3. **Repository Layer**: The only layer that talks to the database (SQL, MongoDB, etc.). 

By using **Interfaces** between these layers, you can easily mock the database during unit testing, ensuring your business logic is robust and independent of the framework or database engine.

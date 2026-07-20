# 02 - Containerization and DevSecOps

Containerization revolutionized deployment by ensuring that software runs exactly the same way across all environments: "It works on my machine" means it will work in production.

## 1. Docker Basics
Containers bundle the application code with its dependencies, libraries, and configuration files.
- **Images:** Read-only templates used to create containers. Built using a `Dockerfile`.
- **Containers:** Running instances of Docker images. Isolated from each other and the host OS via Linux Namespaces and cgroups.
- **Docker Compose:** A tool for defining and running multi-container Docker applications locally (e.g., bringing up your web app, Redis, and Postgres together).

## 2. Multi-Stage Builds
When building a container, you want the final image sent to production to be as small and secure as possible.
- **Multi-Stage `Dockerfile`:** You use one "builder" image (which contains the heavy SDKs, compilers, and source code) to compile the application, and then copy *only* the final compiled binary into a tiny, lightweight runtime image (like Alpine Linux or Distroless).

## 3. DevSecOps (Shift-Left Security)
Security shouldn't be an afterthought; it should be integrated into the CI/CD pipeline (shifting left).
- **SAST (Static Application Security Testing):** Scanning source code for vulnerabilities before it compiles.
- **DAST (Dynamic Application Security Testing):** Testing the running application for vulnerabilities (like XSS or SQLi).
- **Dependency & Secret Scanning:** Tools (like Dependabot or TruffleHog) automatically check if your libraries have known CVEs (Common Vulnerabilities and Exposures) or if you accidentally committed an API key.
- **Container Image Scanning:** Scanning the Docker image layers for vulnerable OS packages (e.g., using Trivy or Clair) before allowing it into the container registry.

---
**Next Step:** Automate your servers and infrastructure in [03 - Infrastructure as Code & GitOps](./03-iac-and-gitops.md).

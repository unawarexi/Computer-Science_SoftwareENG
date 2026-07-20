# 02 - API Design and Gateways

APIs (Application Programming Interfaces) are the doors through which different services communicate. Designing them well is crucial for usability, performance, and security.

## 1. API Styles
- **REST (Representational State Transfer):** The standard for web APIs. It uses standard HTTP methods (GET, POST, PUT, DELETE) and operates on resources (URIs). It is stateless and highly scalable.
- **GraphQL:** Developed by Facebook, it allows clients to request exactly the data they need and nothing more. It solves the "over-fetching" and "under-fetching" problems common in REST, but can be complex to secure against malicious queries.
- **gRPC:** Developed by Google, gRPC uses HTTP/2 and Protocol Buffers (protobufs) to create highly efficient, binary, strongly-typed APIs. It is primarily used for internal microservice-to-microservice communication.
- **Webhooks:** A reverse API. Instead of the client polling the server for updates, the server sends an HTTP POST request to the client when an event occurs.

## 2. API Gateways
When building a system with multiple services, exposing them all directly to the internet is a security nightmare.
- **The Solution:** An API Gateway acts as a single entry point (a reverse proxy) for all client requests.
- **Responsibilities:** 
  - Routing requests to the correct internal microservice.
  - **Rate Limiting & Throttling:** Preventing abuse by limiting how many requests a user can make per minute.
  - SSL Termination.
  - Authentication validation.

## 3. Building Secure APIs
- **Input Validation:** Never trust client data. Always validate payloads strictly before processing them.
- **Pagination:** Never return massive datasets in a single response; always enforce limits/pagination to prevent database exhaustion.

---
**Next Step:** Understand the vulnerabilities that threaten APIs and web apps in [03 - Security Essentials](./03-security-essentials.md).

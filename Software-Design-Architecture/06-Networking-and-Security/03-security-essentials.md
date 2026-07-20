# 03 - Security Essentials and Web Vulnerabilities

A software architect must understand common attack vectors to design systems that are secure by default.

## 1. Common Vulnerabilities (The OWASP Top 10)
- **XSS (Cross-Site Scripting):** Attackers inject malicious JavaScript into web pages viewed by other users. *Defense: Sanitize user input and escape data on output.*
- **CSRF (Cross-Site Request Forgery):** Tricking a logged-in user's browser into executing an unwanted action on a trusted site. *Defense: Use Anti-CSRF tokens (SameSite cookies).*
- **SQLi (SQL Injection):** Attackers interfere with database queries by injecting malicious SQL. *Defense: Always use Prepared Statements (Parameterized Queries) or ORMs. Never concatenate strings for SQL queries.*

## 2. Modern Web Defenses
- **CORS (Cross-Origin Resource Sharing):** A browser mechanism that restricts how a web page can request resources from a different domain. Misconfiguring CORS (e.g., `Allow-Origin: *`) can expose internal APIs to malicious sites.
- **CSP (Content Security Policy):** An HTTP header that allows site administrators to declare which dynamic resources are allowed to load (mitigating XSS).
- **HSTS (HTTP Strict Transport Security):** Forces browsers to strictly use HTTPS, preventing protocol downgrade attacks.

## 3. Authentication & Authorization Protocols
- **TLS (Transport Layer Security):** Encrypts data in transit. 
- **JWT (JSON Web Tokens):** A stateless, compact token format used to transmit claims between parties. They are signed (to ensure integrity) but usually not encrypted. *Warning: Do not store sensitive data in JWTs, and handle revocation carefully.*
- **OAuth2 & OIDC (OpenID Connect):** 
  - *OAuth2* is a framework for **authorization** (delegated access). For example, granting a printing app access to your Google Drive without sharing your password.
  - *OIDC* sits on top of OAuth2 and adds **authentication** (verifying identity).

---
**Next Step:** Apply these concepts to architectural design in [04 - Secure Architecture Design](./04-secure-architecture.md).

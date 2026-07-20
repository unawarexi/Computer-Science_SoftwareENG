# 04 - Secure Architecture Design

Security is not a feature you add at the end; it must be baked into the architecture from day one.

## 1. Threat Modeling
Threat modeling is a structured process to identify potential security threats and vulnerabilities, quantify their severity, and prioritize mitigation techniques.
- **STRIDE Methodology:** Evaluate Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, and Elevation of Privilege.

## 2. Architectural Security Principles
- **Principle of Least Privilege:** A user, program, or process should have only the bare minimum privileges necessary to perform its function.
- **Defense in Depth:** Using multiple, layered security controls. If a hacker breaches your outer firewall, they should still face internal authentications and encrypted databases.
- **RBAC vs ABAC:** 
  - *Role-Based Access Control:* Access based on the user's role (Admin, User).
  - *Attribute-Based Access Control:* More granular access based on user attributes, resource state, and environment (e.g., "Only allow access during business hours").

## 3. Secure Storage and Secrets Management
- **Passwords:** Never store passwords in plain text. Hash them using slow algorithms with a salt (e.g., bcrypt, Argon2).
- **Secrets Management:** API keys, database credentials, and TLS certificates should never be hardcoded or checked into Git. Use dedicated secrets managers like **HashiCorp Vault**, AWS Secrets Manager, or Azure Key Vault.

---
**Next Step:** Go beyond the basics with advanced perimeter defenses in [05 - Advanced Infrastructure Security](./05-advanced-infrastructure.md).

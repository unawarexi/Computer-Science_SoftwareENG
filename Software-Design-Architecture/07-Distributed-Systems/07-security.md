# 07 - Security in Distributed Systems

Securing a distributed system is vastly more complex than a centralized one because the attack surface is larger, data travels over insecure networks, and trust must be established among multiple independent nodes.

## 1. Security Challenges
- **Network Sniffing:** Attackers intercepting data in transit.
- **Spoofing & Impersonation:** A malicious node pretending to be a legitimate server or client.
- **Denial of Service (DoS):** Overwhelming nodes to bring the system down.
- **Lack of Central Control:** No single point of authentication makes policy enforcement harder.

## 2. Core Security Mechanisms
- **Cryptography:** 
  - *Symmetric/Asymmetric Encryption:* Ensuring data confidentiality during transmission.
  - *Hashes & Digital Signatures:* Ensuring data integrity and non-repudiation.
- **Authentication & Authorization:**
  - *Kerberos:* A network authentication protocol designed to provide strong authentication for client/server applications using secret-key cryptography.
  - *OAuth / JWT:* Token-based authorization used heavily in distributed microservices.
- **Secure Channels (TLS/SSL):** Encrypting the communication links between nodes to prevent eavesdropping and man-in-the-middle attacks (e.g., Mutual TLS).

## 3. Trust Models and Access Control
- **Zero Trust Architecture:** Never trust, always verify. Every request, whether internal or external, must be authenticated and authorized.
- **Role-Based Access Control (RBAC):** Restricting network access based on the roles of individual users or services within the enterprise.
- **Distributed Firewalls and Intrusion Detection:** Protecting individual nodes and monitoring network traffic for anomalous behavior across the entire distributed footprint.

---
**Congratulations!** You have completed the comprehensive deep dive into Distributed Systems. Head back to the [Main Syllabus](./README.md).

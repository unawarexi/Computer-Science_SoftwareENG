# 01 - Protocols & Web Communication

Before designing distributed systems or APIs, you must understand the foundational protocols that dictate how data travels across the internet.

## 1. The OSI Model
The Open Systems Interconnection (OSI) model conceptualizes how networks operate in 7 layers (Physical, Data Link, Network, Transport, Session, Presentation, Application). 
- As an architect, you mostly deal with **Layer 4 (Transport)** and **Layer 7 (Application)**.

## 2. Core Transport Protocols (Layer 4)
- **TCP (Transmission Control Protocol):** Connection-oriented. It guarantees that packets arrive in order and without errors (via a 3-way handshake). Used for web browsing (HTTP), email, and file transfers.
- **UDP (User Datagram Protocol):** Connectionless. It is fast but unreliable (packets can be dropped or arrive out of order). Used for video streaming, VoIP, and gaming.

## 3. Web Protocols (Layer 7)
- **HTTP / HTTPS:** The backbone of the web. HTTPS adds a layer of encryption via TLS (Transport Layer Security). 
  - *HTTP/1.1:* Text-based, relies on multiple connections.
  - *HTTP/2:* Multiplexed, binary framing, server push.
  - *HTTP/3:* Built on QUIC (which runs over UDP), reducing connection latency significantly.
- **WebSockets:** While HTTP is unidirectional (client requests, server responds), WebSockets provide a persistent, full-duplex, bi-directional communication channel. Ideal for chat apps and live updates.

## 4. DNS (Domain Name System)
The phonebook of the internet. Translates human-readable domain names (google.com) into IP addresses. Understanding DNS resolution, A-records, CNAMEs, and TTLs is crucial for deploying applications and managing traffic routing.

---
**Next Step:** Learn how to structure the data sent over these protocols in [02 - API Design](./02-api-design.md).

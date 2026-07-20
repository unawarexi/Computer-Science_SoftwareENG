# 05 - Advanced Distributed Architectures & OS Models

Beyond basic communication patterns, distributed systems rely on higher-level architectural models and operating system paradigms to function efficiently.

## 1. Architectural Models
- **Client-Server Model:** The most common model. Clients request resources or services, and a centralized server provides them. It's easy to manage but can become a bottleneck.
- **Peer-to-Peer (P2P) Model:** All nodes (peers) act as both clients and servers. Resources are distributed among all nodes, making the system highly scalable and resilient without a single point of failure (e.g., BitTorrent).

## 2. Operating System Models
- **Network Operating System (NOS):** Each node runs its own operating system, and users are aware of the network. The OS provides services like file sharing and remote execution, but the nodes remain relatively autonomous and visible.
- **Middleware Operating System:** A software layer that sits above the native OS and below the application. It masks the heterogeneity of the underlying networks, hardware, and OS, making the distributed system look like a single coherent system to the user.

## 3. Distributed Objects and CORBA
- **Distributed Objects:** Objects that are distributed across different machines but can interact as if they were in the same memory space.
- **CORBA (Common Object Request Broker Architecture):** A standard designed to facilitate the communication of systems deployed on diverse platforms. It uses an Object Request Broker (ORB) to enable objects to make requests and receive responses seamlessly, regardless of the language or OS they are written in.

## 4. Software Agents
- **Software Agents in Distributed Systems:** Autonomous software entities that can migrate across the network, executing tasks on behalf of a user. They possess properties like autonomy, mobility, and reactivity, making them useful for distributed information retrieval and network management.

---
**Next Step:** Explore the depths of distributed data management in [06 - Advanced Distributed Databases](./06-advanced-databases.md).

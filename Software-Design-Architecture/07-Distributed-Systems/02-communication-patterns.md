# 02 - Communication Patterns and Architectures

In a distributed system, nodes must communicate efficiently and reliably. This week covers the diverse methods, protocols, and algorithms that make distributed interaction possible.

## 1. Asynchronous Messaging & Event-Driven Architecture
- **Message Queues:** A queue decouples the sender (producer) from the receiver (consumer). The sender pushes a message to the queue, and the receiver pulls it when ready. Examples: **RabbitMQ**, Amazon SQS.
- **Pub/Sub (Publish/Subscribe):** A publisher broadcasts messages to a "topic." Multiple subscribers can listen to that topic and react simultaneously. Examples: **Apache Kafka**, Google Cloud Pub/Sub.
- **Event Sourcing:** Instead of storing just the current state of data in a database, you store a sequence of state-changing *events*. The current state is derived by replaying the events. This pairs heavily with Kafka and CQRS.

## 2. Remote Invocation (RPC, RMI, MPI)
- **RPC (Remote Procedure Call):** Allows a program to execute a subroutine on a remote computer as if it were a local call. Examples: gRPC, Thrift.
- **RMI (Remote Method Invocation):** The object-oriented equivalent of RPC, often associated with Java. It allows invoking a method on an object residing in a different JVM.
- **MPI (Message Passing Interface):** A standardized API typically used in high-performance computing (HPC) to allow processes to communicate and synchronize in parallel computing environments.

## 3. Communication Protocols
Distributed systems rely on a stack of protocols. While HTTP/REST is common, others include:
- **TCP/UDP:** Low-level transport. TCP provides reliable ordered delivery; UDP is fire-and-forget.
- **WebSockets:** Persistent, bi-directional communication channels.
- **AMQP / MQTT:** Specialized protocols for message queuing and IoT communication.

## 4. Distributed Databases & Parallel Databases
- **Parallel Databases:** Tightly coupled systems where multiple processors share memory/disks to execute queries incredibly fast.
- **Distributed Databases:** Loosely coupled systems where data is spread across multiple physical nodes (Sharding). They must handle replication, partitioning, and complex distributed transactions.
- **Concurrency Control:** Ensuring that multiple transactions happening at the same time do not corrupt data. Techniques include Two-Phase Locking (2PL) and Optimistic Concurrency Control (OCC).

## 5. Election Algorithms
When a master node fails, the system must elect a new leader.
- **Bully Algorithm:** The node with the highest ID bullies the others into accepting it as the leader.
- **Ring Algorithm:** Nodes are arranged in a logical ring. If the leader fails, an election message circles the ring, gathering IDs, and the highest ID is elected.

## 6. Migration and Fault Tolerance
- **Code and Resource Migration:** Moving processes, code, or data from one machine to another dynamically to balance load or move processing closer to data. 
- **Migration Models:** 
  - *Sender-initiated* vs *Receiver-initiated* (push vs pull).
  - *Strong mobility* (migrating execution state) vs *Weak mobility* (migrating only code).
- **Fault Tolerance:** Techniques like redundancy, replication, and checkpoints ensure that if a node or migration fails, the system recovers gracefully.

---
**Next Step:** Understand the theoretical limits of distributed systems in [03 - CAP Theorem in Depth](./03-cap-theorem.md).

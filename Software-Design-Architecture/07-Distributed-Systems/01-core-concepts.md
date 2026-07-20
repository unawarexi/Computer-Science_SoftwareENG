# 01 - Core Concepts of Distributed Systems

Welcome to Distributed Systems! In a distributed system, multiple components located on different networked computers communicate and coordinate their actions by passing messages to one another. 

## 1. What is Distributed Computing?
A distributed system appears to its users as a single coherent system but is actually composed of multiple independent nodes. The primary goals of distributed computing are:
- **Scalability:** Handling increased load by adding more machines (horizontal scaling).
- **Reliability and Fault Tolerance:** If one node fails, the system can continue operating.
- **Performance:** Processing can be parallelized, and data can be placed geographically closer to the users.

*Challenges:* Distributed systems introduce network latency, partial failures, and complex synchronization problems that do not exist in single-node systems.

## 2. Time & Clocks in Distributed Systems
In a single computer, processes can rely on the CPU's physical clock. In a distributed system, every node has its own physical clock, and they are never perfectly synchronized due to clock drift.

- **Physical Clocks:** Using protocols like NTP (Network Time Protocol) helps keep clocks relatively synchronized, but they are not accurate enough to determine the exact ordering of events across different nodes.
- **Logical Clocks (Lamport Clocks):** Instead of wall-clock time, Lamport Clocks assign a sequence number to events. This helps establish a "happens-before" relationship. If Event A happened before Event B, A's timestamp is lower than B's.
- **Vector Clocks:** An extension of Lamport Clocks. They allow us to detect concurrent events—events that happened at the same time and do not have a causal relationship.

## 3. Consensus Algorithms
How do multiple independent nodes agree on a single value or state, especially when nodes can fail or the network can drop messages? This is the problem of consensus.

- **The Problem:** We need a group of servers to agree on the next action (e.g., who is the leader database node? Or committing a transaction).
- **Paxos:** The pioneering consensus algorithm, though notoriously difficult to understand and implement correctly.
- **Raft:** A newer consensus algorithm designed specifically to be easier to understand than Paxos. It achieves consensus via an elected leader. The leader takes commands from clients, logs them, and replicates them to other nodes safely.

---
**Next Step:** Dive into the diverse ways nodes talk to each other in [02 - Communication Patterns](./02-communication-patterns.md).

# 06 - Advanced Distributed Databases & Transactions

When a database spans multiple physical machines, handling data consistency, execution, and queries becomes significantly more complex.

## 1. Distributed Transactions and Execution
- **Distributed Transactions:** A transaction that involves multiple network hosts. It must maintain the ACID (Atomicity, Consistency, Isolation, Durability) properties across all involved databases.
- **Two-Phase Commit (2PC):** The classic protocol to ensure atomic commitment in a distributed transaction. It has a Voting Phase (Prepare) and a Decision Phase (Commit/Abort).
- **Transaction Execution:** Managing how the steps of a transaction are routed and processed by different nodes.

## 2. Distributed Mutual Exclusion
To prevent data corruption, only one process must access a shared resource at a time. In a distributed system with no shared memory, this is achieved via:
- **Centralized Algorithms:** A coordinator grants permission.
- **Distributed Algorithms (e.g., Ricart-Agrawala):** Nodes broadcast requests and collect permissions from all other nodes.
- **Token Ring Algorithms:** A virtual token circulates among nodes; only the node with the token can enter the critical section.

## 3. Data Replication and Recovery
- **Data Replication:** Storing copies of data on multiple nodes to improve availability and read performance. Challenges involve keeping all replicas consistent (synchronous vs. asynchronous replication).
- **Recovery:** When a distributed system fails, recovery mechanisms ensure no data is lost. This involves distributed logging, checkpoints, and restoring from consistent snapshots.

## 4. Fragmentation and Query Processing
- **Fragmentation (Partitioning):** Breaking a single database table into smaller pieces to distribute them across nodes.
  - *Horizontal Fragmentation:* Splitting rows (e.g., users in US on one node, EU on another).
  - *Vertical Fragmentation:* Splitting columns (e.g., separating sensitive data from public data).
- **Distributed Query Processing:** When a query requires data from multiple fragments across different nodes, the database must generate a distributed execution plan to minimize data transfer across the network and optimize join operations locally where possible.

---
**Next Step:** Learn how to protect your distributed architecture in [07 - Security in Distributed Systems](./07-security.md).

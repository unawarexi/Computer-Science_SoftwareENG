# 03 - CAP Theorem in Depth

The CAP theorem (also known as Brewer's theorem) is one of the most fundamental concepts in distributed systems. It states that it is impossible for a distributed data store to simultaneously provide more than two out of the following three guarantees:

## 1. Consistency (C)
Every read receives the most recent write or an error. When a system is consistent, it behaves as if there is only one copy of the data, and all operations are executed in a sequential order.

## 2. Availability (A)
Every request receives a (non-error) response, without the guarantee that it contains the most recent write. As long as a node is up and running, it will respond to a client.

## 3. Partition Tolerance (P)
The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes. In a distributed system, network partitions (failures) are a fact of life. You **must** tolerate partitions.

## The Tradeoff: CP vs AP
Because network partitions (P) are unavoidable in distributed systems over a network, you generally have to choose between Consistency and Availability when a partition occurs:

- **CP (Consistency and Partition Tolerance):** If a network partition occurs, the system will return an error or time out rather than risk returning stale data. 
  - *Example:* Banking systems, where reading an incorrect account balance is unacceptable. MongoDB and HBase often lean CP.
- **AP (Availability and Partition Tolerance):** If a network partition occurs, the system will always respond to the query, even if it might return stale data. The nodes will resynchronize once the network is restored.
  - *Example:* Social media feeds. It's better to show an older feed than an error page. Cassandra and DynamoDB often lean AP.

## Eventual Consistency
A common compromise in AP systems. It guarantees that if no new updates are made to a given data item, eventually all accesses to that item will return the last updated value.

---
**Next Step:** Learn how to handle chaos gracefully in [04 - Failures in Distributed Systems](./04-failures.md).

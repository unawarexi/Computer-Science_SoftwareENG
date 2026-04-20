# Deadlocks: Prevention, Avoidance, Detection, Recovery

A deadlock is a situation where a set of processes are blocked, each waiting for a resource held by another, forming a cycle.

## Deadlock Prevention
- Ensure at least one of the necessary conditions for deadlock cannot hold (mutual exclusion, hold and wait, no preemption, circular wait).

## Deadlock Avoidance
- Dynamically examine resource allocation to ensure a safe state (e.g., Banker's Algorithm).

## Deadlock Detection
- Allow deadlocks to occur but detect and resolve them (resource allocation graphs, detection algorithms).

## Deadlock Recovery
- Terminate or preempt processes to break the deadlock cycle.
- Rollback processes to a safe state.

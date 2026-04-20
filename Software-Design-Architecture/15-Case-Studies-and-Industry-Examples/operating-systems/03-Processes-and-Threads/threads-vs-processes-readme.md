# Threads vs Processes

## Processes:
- Independent execution units with their own memory space.
- More resource-intensive to create and manage.
- Inter-process communication (IPC) is required for data sharing.

## Threads:
- Lightweight execution units within a process.
- Share the same memory space and resources of the parent process.
- Easier and faster to create, switch, and terminate.
- Communication between threads is simpler (shared memory).

## Key Differences:
- **Isolation:** Processes are isolated; threads are not.
- **Resource Sharing:** Threads share resources; processes do not.
- **Overhead:** Processes have higher overhead than threads.
- **Failure Impact:** Process failure does not affect others; thread failure can affect the whole process.

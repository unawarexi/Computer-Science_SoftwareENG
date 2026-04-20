# Synchronization Primitives (Mutex, Semaphore, Monitor)

Synchronization primitives are mechanisms to control access to shared resources and prevent race conditions in concurrent systems.

## Mutex (Mutual Exclusion):
- Allows only one thread/process to access a resource at a time.
- Used to protect critical sections.

## Semaphore:
- Integer variable used for signaling.
- Can allow multiple threads to access a resource (counting semaphore) or only one (binary semaphore).
- Used for signaling and resource management.

## Monitor:
- High-level abstraction that combines mutual exclusion and condition variables.
- Only one process can be active in the monitor at a time.
- Provides methods for safe access and synchronization.

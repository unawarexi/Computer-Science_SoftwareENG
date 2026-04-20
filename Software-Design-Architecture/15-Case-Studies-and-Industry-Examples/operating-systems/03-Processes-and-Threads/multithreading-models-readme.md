# Multithreading Models

Multithreading models define how threads are mapped to kernel threads by the operating system. The main models are:

## 1. Many-to-One Model
- Multiple user-level threads mapped to a single kernel thread.
- Only one thread can access the kernel at a time.
- Simple but cannot utilize multiprocessors.

## 2. One-to-One Model
- Each user thread maps to a kernel thread.
- Allows true parallelism on multiprocessors.
- More overhead due to kernel thread management.

## 3. Many-to-Many Model
- Many user threads mapped to many kernel threads.
- OS can schedule threads on available processors.
- Flexible and scalable.

## Hybrid Model
- Combines aspects of the above models for efficiency and flexibility.

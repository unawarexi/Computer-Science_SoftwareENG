# Interrupt-Driven I/O

Interrupt-driven I/O allows devices to signal the CPU when they are ready for data transfer, rather than polling continuously.

- **Advantages:** Reduces CPU idle time, improves efficiency.
- **Process:** Device sends interrupt, CPU suspends current task, executes interrupt handler, resumes task.
- **Applications:** Keyboards, network cards, disk controllers.

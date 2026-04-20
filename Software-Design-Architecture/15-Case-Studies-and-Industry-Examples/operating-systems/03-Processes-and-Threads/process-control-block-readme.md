# Process Control Block (PCB)

A Process Control Block (PCB) is a data structure maintained by the operating system for every process. It contains all the information about a process, including:

- **Process State:** Current state (new, ready, running, waiting, terminated).
- **Process ID (PID):** Unique identifier for the process.
- **Program Counter:** Address of the next instruction to execute.
- **CPU Registers:** Contents of all process-specific registers.
- **Memory Management Info:** Base/limit registers, page tables, segment tables.
- **Accounting Info:** CPU usage, process start time, priority, etc.
- **I/O Status Info:** List of I/O devices allocated, open files, etc.

The PCB is essential for context switching, as it allows the OS to save and restore process states efficiently. It also enables process management, scheduling, and resource allocation.

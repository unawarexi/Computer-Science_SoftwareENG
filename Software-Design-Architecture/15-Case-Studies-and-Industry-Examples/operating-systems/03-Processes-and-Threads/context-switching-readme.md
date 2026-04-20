# Context Switching

Context switching is the process by which the operating system saves the state of a currently running process or thread and restores the state of the next scheduled process or thread. This allows multiple processes to share a single CPU efficiently.

## Steps in Context Switching:
1. Save the context (registers, program counter, etc.) of the current process into its PCB.
2. Update the process state to ready or waiting.
3. Select the next process to run (using the scheduler).
4. Load the context of the selected process from its PCB.
5. Update the process state to running.

Context switching introduces overhead, as CPU cycles are spent saving and loading states rather than executing process instructions. Efficient context switching is crucial for system performance, especially in multitasking environments.

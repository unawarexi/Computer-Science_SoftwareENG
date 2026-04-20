# Address Binding

Address binding refers to the process of mapping logical (virtual) addresses used by a program to physical addresses in memory. This can occur at different stages:

- **Compile Time:** If the memory location is known in advance, absolute code is generated.
- **Load Time:** If the memory location is not known at compile time, relocatable code is generated and binding occurs when the program is loaded.
- **Execution Time:** If a process can be moved during execution, binding must be delayed until run time (requires hardware support, e.g., MMU).

Modern operating systems use execution-time binding to support features like virtual memory and process relocation.

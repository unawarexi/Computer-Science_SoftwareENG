# Device Scheduling

Device scheduling algorithms determine the order in which I/O requests are serviced to optimize performance.

- **FCFS (First-Come, First-Served):** Simple, fair, but can be inefficient.
- **SSTF (Shortest Seek Time First):** Services request closest to current head position (for disks).
- **SCAN/LOOK:** Disk arm moves back and forth, servicing requests in one direction.
- **Priority Scheduling:** Some requests are prioritized over others.

Efficient scheduling reduces wait times and increases throughput.

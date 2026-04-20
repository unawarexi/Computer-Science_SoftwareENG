# Page Replacement Algorithms

When a page fault occurs and memory is full, the OS must decide which page to replace. Common algorithms include:

- **FIFO (First-In, First-Out):** Replace the oldest page in memory.
- **LRU (Least Recently Used):** Replace the page that has not been used for the longest time.
- **Optimal:** Replace the page that will not be used for the longest time in the future (requires future knowledge).
- **Clock:** Circular buffer implementation of LRU.

The choice of algorithm affects system performance and thrashing likelihood.

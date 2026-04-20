# File Allocation Methods

File allocation methods determine how files are stored on disk blocks:

- **Contiguous Allocation:** Files occupy consecutive blocks. Fast access, but can cause fragmentation.
- **Linked Allocation:** Each file block points to the next. No fragmentation, but slower access.
- **Indexed Allocation:** Uses an index block to keep track of file blocks. Efficient random access.

Modern file systems may use hybrid approaches for performance and reliability.

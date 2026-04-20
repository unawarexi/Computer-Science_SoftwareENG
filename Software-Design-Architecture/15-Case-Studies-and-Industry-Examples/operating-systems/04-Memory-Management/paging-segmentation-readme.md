# Paging and Segmentation

## Paging
- Memory is divided into fixed-size blocks called frames; logical memory is divided into pages of the same size.
- The OS maintains a page table to map logical pages to physical frames.
- Paging eliminates external fragmentation but can cause internal fragmentation.

## Segmentation
- Memory is divided into variable-sized segments based on logical divisions (code, data, stack, etc.).
- Each segment has a segment number and offset.
- Segmentation supports modularity and protection but can suffer from external fragmentation.

Modern systems often combine paging and segmentation for flexibility and efficiency.

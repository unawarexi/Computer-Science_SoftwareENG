# OS Structure: Monolithic, Layered, Microkernel, Modular, Hybrid

- **Monolithic:** All OS services run in kernel space (e.g., Linux). Fast but less modular.
- **Layered:** OS is divided into layers, each built on top of lower ones. Improves modularity and maintainability.
- **Microkernel:** Only essential services in kernel; others in user space (e.g., Minix). More secure and stable, but may be slower.
- **Modular:** Kernel can load/unload modules at runtime (e.g., Linux modules).
- **Hybrid:** Combines aspects of monolithic and microkernel (e.g., Windows NT).

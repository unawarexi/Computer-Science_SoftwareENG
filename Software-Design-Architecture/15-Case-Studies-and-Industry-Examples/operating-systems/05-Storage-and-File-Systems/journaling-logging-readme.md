# Journaling and Logging

Journaling and logging are techniques to ensure file system consistency and recoverability after crashes or power failures.

- **Journaling:** Records changes before applying them. If a crash occurs, the system can replay or discard incomplete operations.
- **Logging:** Maintains a log of operations for auditing and recovery.

Journaling file systems (e.g., ext4, NTFS) are more robust and reliable.

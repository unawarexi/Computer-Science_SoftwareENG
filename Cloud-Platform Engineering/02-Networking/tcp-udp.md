# TCP vs UDP

## 1. What is TCP?

TCP (Transmission Control Protocol) is a connection-oriented protocol that provides reliable, ordered, and error-checked delivery of data.

## 2. What is UDP?

UDP (User Datagram Protocol) is a connectionless protocol that provides fast, low-overhead, but unreliable data delivery.

## 3. Key Differences

| Feature            | TCP                       | UDP                    |
| ------------------ | ------------------------- | ---------------------- |
| Connection         | Connection-oriented       | Connectionless         |
| Reliability        | Reliable                  | Unreliable             |
| Ordering           | Ordered                   | Unordered              |
| Error Checking     | Yes                       | Optional               |
| Flow Control       | Yes                       | No                     |
| Congestion Control | Yes                       | No                     |
| Speed              | Slower                    | Faster                 |
| Overhead           | Higher                    | Lower                  |
| Use Cases          | Web, email, file transfer | Streaming, gaming, DNS |

## 4. When to Use Which

Use **TCP** when you need reliable, ordered data delivery:

- Web browsing (HTTP/HTTPS)
- Email (SMTP, IMAP, POP3)
- File transfer (FTP, SFTP)
- Secure shell (SSH)
- Database connections

Use **UDP** when you need fast, low-overhead data delivery:

- Video streaming (Netflix, YouTube)
- Online gaming
- Voice over IP (VoIP)
- DNS (Domain Name System)
- Real-time applications

## 5. TCP Three-Way Handshake

```
Client -> Server: SYN (Synchronize)
Server -> Client: SYN-ACK (Synchronize-Acknowledge)
Client -> Server: ACK (Acknowledge)
```

## 6. UDP Datagram Structure

```
| Source Port | Destination Port | Length | Checksum |
```

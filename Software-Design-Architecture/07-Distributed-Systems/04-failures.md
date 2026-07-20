# 04 - Failures in Distributed Systems

"Everything fails all the time." — Werner Vogels (CTO of Amazon).
In a single machine, if a function fails, the program crashes. In a distributed system, partial failures are common: a network packet is lost, a database is temporarily slow, or a single node reboots. Your architecture must anticipate and handle these failures gracefully.

## 1. Retry Logic
When a network call fails, the simplest response is to try again.
- **Transient Failures:** Often, failures are temporary (a network blip). A quick retry will succeed.
- **Exponential Backoff:** If a service is overwhelmed, immediately retrying will only make it worse. Exponential backoff increases the wait time between retries (e.g., wait 1s, then 2s, then 4s, then 8s).
- **Jitter:** Adding randomness (jitter) to the backoff time prevents the "thundering herd" problem, where thousands of clients retry at the exact same millisecond.

## 2. Circuit Breakers
If a downstream service is completely down, retrying continuously wastes resources and can cause cascading failures across your entire system.
- **How it Works:** Like an electrical circuit breaker, if it detects a high number of failures, the circuit "trips" (opens).
- **Open State:** All requests immediately fail without even trying to hit the broken service, giving it time to recover.
- **Half-Open State:** After a timeout, the circuit lets a few requests through. If they succeed, it closes the circuit and resumes normal operations. If they fail, it trips open again.

## 3. Idempotency
Because network calls can timeout, you might not know if a request actually succeeded. If you retry a payment, you might charge the user twice!
- **Definition:** An operation is idempotent if applying it multiple times has the exact same effect as applying it once.
- **Implementation:** Clients generate a unique `Idempotency-Key` (a UUID) for the request. The server saves this key. If the client retries with the same key, the server simply returns the cached successful response without processing the payment again.

## 4. Health Checks and Timeouts
- **Timeouts:** Never make an indefinite blocking call over a network. Always set a timeout. If a service doesn't respond in X seconds, treat it as a failure.
- **Health Checks:** Load balancers continuously ping the `/health` endpoints of nodes. If a node stops responding, the load balancer stops routing traffic to it.

---
**Congratulations!** You now have a solid foundation in the complexities of Distributed Systems. Head back to the [Main Syllabus](./README.md).

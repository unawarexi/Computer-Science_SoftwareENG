# APIs & Protocols

## Overview
Communication interfaces and protocols used across our NestJS microservices and clients.

## Topics
1. **REST & Fastify**
   - Building high-performance REST APIs.
   - Using `platform-fastify` in NestJS instead of Express for higher throughput and lower overhead.

2. **GraphQL**
   - Schema-first vs Code-first approach in NestJS.
   - Aggregating data from multiple microservices (e.g., fetching a user, their orders, and product details in a single query).
   - Dealing with the N+1 problem (DataLoader).

3. **WebSockets**
   - Real-time communication using Socket.io or ws.
   - Use cases: Live order status updates, real-time inventory count alerts.

4. **WebRTC**
   - Peer-to-peer real-time communication.
   - Use cases: Customer support video/audio chat, live streaming product demos.

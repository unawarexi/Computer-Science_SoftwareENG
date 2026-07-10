# System Design & Architecture: E-Commerce Scale

## Overview
This section covers high-level architectural patterns for a large-scale e-commerce application (Amazon scale).

## Topics
1. **Microservices Architecture**
   - Breaking down the monolith into bounded contexts (e.g., Users, Products, Orders, Inventory, Payments).
   - Domain-Driven Design (DDD).
   - Inter-service communication (Sync vs Async).

2. **CAP Theorem**
   - Consistency, Availability, Partition Tolerance.
   - Trade-offs in an e-commerce context:
     - **Shopping Cart**: High availability (AP) is preferred. We want customers to always be able to add items.
     - **Checkout/Payments**: High consistency (CP) is required to prevent double billing or overselling inventory.

3. **API Gateway Pattern**
   - Single entry point for clients.
   - Routing, composition, rate limiting, and SSL termination.

4. **Scalability Strategies**
   - Horizontal vs Vertical scaling.
   - Stateless services.
   - Database sharding and read replicas.

# Asynchronous Communication

## Overview
Decoupling microservices and handling background processing using message brokers and event streaming.

## Topics
1. **Message Queues (RabbitMQ)**
   - Point-to-point communication and task distribution.
   - Use cases: Sending emails/SMS (Notification Service), asynchronous image processing.
   - Retries, Dead Letter Exchanges (DLX).

2. **Event Streaming (Apache Kafka)**
   - Pub/Sub model, high throughput, and event replayability.
   - Use cases: Order created event (consumed by Inventory, Payment, and Notification services simultaneously).
   - Event Sourcing and CQRS (Command Query Responsibility Segregation).

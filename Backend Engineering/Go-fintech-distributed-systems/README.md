# Go Fintech Distributed Banking System

A production-grade, distributed fintech banking backend built in Go.

## Architecture Highlights
- **Clean Architecture:** Divided into domain, api, service, repository, and infrastructure layers.
- **Double-Entry Ledger:** Immutable accounting principles using PostgreSQL.
- **Transactional Outbox:** Guaranteed at-least-once event delivery (Postgres -> Kafka).
- **Saga Pattern:** Distributed transactions for transfers and multi-step workflows.
- **Idempotency:** Safe retries for financial endpoints.
- **Multi-DB:** PostgreSQL for core ACID financial data; MongoDB for high-volume logs and analytics.
- **Observability:** OpenTelemetry (traces, metrics) and structured logging (Zap).

## Getting Started

1. Set up environment:
   ```bash
   cp .env.example .env
   ```
2. Start infrastructure (PostgreSQL, MongoDB, Redis, Kafka):
   ```bash
   make db-up
   ```
3. Run migrations:
   ```bash
   make migrate-up
   ```
4. Build and run:
   ```bash
   make build
   make run-server
   ```

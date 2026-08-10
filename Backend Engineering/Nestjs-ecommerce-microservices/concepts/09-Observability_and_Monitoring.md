# Observability & Monitoring

## Overview
Gaining insights into system health, tracking down errors, and identifying performance bottlenecks.

## Topics
1. **Logging & Debugging**
   - Structured logging (JSON format) using Winston or Pino.
   - Centralized logging stack (ELK/EFK - Elasticsearch, Logstash/Fluentd, Kibana).
   - Distributed Tracing (OpenTelemetry/Jaeger) to trace requests across microservices.

2. **Monitoring (Prometheus & Grafana)**
   - **Prometheus**: Scraping metrics (CPU, Memory, Request rate, Error rate).
   - **Grafana**: Visualizing metrics in dashboards.
   - Setting up alerts for high latency or error spikes.

3. **Error Tracking (Sentry)**
   - Capturing unhandled exceptions and real-time error tracking.
   - Contextual data (user ID, request payload) for easier debugging.

4. **Production Bottlenecks**
   - Identifying CPU-bound vs I/O-bound issues.
   - Node.js event loop blocking.
   - Connection pool exhaustion and database locks.

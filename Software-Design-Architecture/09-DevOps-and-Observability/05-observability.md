# 05 - Observability Deep Dive

Monitoring tells you *when* a system is broken. Observability lets you ask *why* it is broken. In highly distributed microservice architectures, observability is non-negotiable.

## 1. The Three Pillars of Observability
To truly understand a distributed system, you need three types of telemetry data:

1. **Metrics:** Quantitative data (numbers) measured over intervals of time. 
   - Examples: CPU usage, memory consumption, request rate, error rate.
   - Tools: **Prometheus** (pull-based metric collection), **Grafana** (dashboards and visualization), Datadog.
2. **Logs:** Discrete, immutable timestamped records of discrete events that happened over time. 
   - Good logs should be structured (JSON format) so they can be easily queried.
   - Tools: **ELK Stack** (Elasticsearch, Logstash, Kibana), **Loki** (lightweight log aggregation by Grafana), Splunk.
3. **Distributed Traces:** A trace records the end-to-end journey of a single user request as it flows through all the different microservices in your system. 
   - It identifies exactly which service is causing a bottleneck or failure.
   - Tools: **Jaeger**, **Zipkin**, Honeycomb.
   - **OpenTelemetry:** The emerging open-source standard for instrumenting code to generate metrics, logs, and traces in a unified format, avoiding vendor lock-in.

## 2. Application Error Tracking
While standard logs are great, dedicated error tracking software groups identical stack traces, tracks the exact line of code that failed, and links it to source control.
- Tools: **Sentry**, Rollbar, Bugsnag.

## 3. Alerting
Collecting data is useless if no one looks at it. Alerting systems evaluate metrics against thresholds and page on-call engineers.
- Avoid alert fatigue: Only alert on actionable, critical symptoms (e.g., "Checkout failure rate is > 5%"), not causes (e.g., "CPU on Database Node 3 is at 90%").
- Tools: Prometheus Alertmanager, **PagerDuty**, Opsgenie.

---
**Next Step:** Tie it all together by adopting a reliability engineering mindset in [06 - Site Reliability Engineering (SRE)](./06-sre.md).

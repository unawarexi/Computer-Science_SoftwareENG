# 04 - Kubernetes Orchestration

Running a single Docker container is easy. Running 10,000 containers across 500 servers, handling rolling updates, networking, storage, and self-healing when nodes crash, requires an orchestrator. **Kubernetes (K8s)** is the absolute industry standard.

## 1. Kubernetes Architecture
- **Control Plane (Master Node):** The brain of K8s. It contains the API Server (which you talk to), the Scheduler (which decides where containers run), and etcd (the database storing cluster state).
- **Worker Nodes:** The physical or virtual machines where your workloads actually run. They run a `kubelet` agent.

## 2. Core Kubernetes Concepts
- **Pods:** The smallest deployable unit in K8s. A pod wraps one or more containers (usually just one, plus maybe a sidecar proxy) that share storage and a local network.
- **ReplicaSets & Deployments:** You rarely create raw Pods. You create a Deployment, which tells K8s "I always want 3 replicas of this Pod running." If a node dies, K8s notices the missing pod and spins up a new one on a healthy node automatically (Self-healing).
- **Services:** Pods are ephemeral; their IP addresses constantly change. A Service provides a stable IP address and DNS name to load-balance traffic across a set of Pods.
- **Ingress:** Manages external access to the services in a cluster, typically HTTP. It provides load balancing, SSL termination, and name-based virtual hosting.

## 3. Package Management (Helm)
Writing raw YAML files for complex applications gets tedious. 
- **Helm:** The package manager for Kubernetes. It uses "Charts" to package K8s YAML templates, allowing you to deploy complex applications (like a full Prometheus monitoring stack) with a single command: `helm install prometheus`.

---
**Next Step:** Learn how to see inside your complex distributed systems in [05 - Observability Deep Dive](./05-observability.md).

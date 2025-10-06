# TOP 50 - APP CONTAINERIZATION & DEVOPS

Flutter · React Native · AWS · GCP · Docker · Kubernetes

## DOCKER BASICS & IMAGE MANAGEMENT

**How would you containerize a mobile backend or web API?**

Create Dockerfile with base image (node:18-alpine or python:3.12-slim).

Copy source → install deps → CMD ["npm","start"].

Build + run: `docker build -t app . && docker run -p 8080:8080 app`

**What's the flow of creating multi-stage Docker builds?**

Stage 1: build dependencies; Stage 2: copy final build to lightweight image.

Reduces size; common for Flutter web or React builds.

**Why use Alpine images?**

Smaller footprint → faster pull & startup.

**How would you manage secrets in Docker?**

Use --env-file or Docker Secrets (Swarm/K8s) instead of hardcoding.

**How do you handle platform-specific builds (arm64 vs amd64)?**

Use `docker buildx build --platform linux/arm64,linux/amd64`

## DOCKER COMPOSE & MULTI-SERVICE SETUPS

**Walk me through setting up Docker Compose for app + DB.**

```yaml
services:
  api:
    build: .
    ports: ["8080:8080"]
    depends_on: [db]
  db:
    image: postgres:16
    volumes: ["db_data:/var/lib/postgresql/data"]
volumes: { db_data: {} }
```

**Why prefer Compose over multiple docker run commands?**

Centralized orchestration, env sharing, dependency graph.

**How would you persist data in containers?**

Named volumes or bind mounts; avoid ephemeral containers for DBs.

**What's the flow for debugging containers locally?**

`docker exec -it <container> sh`; inspect logs, env, network.

**How do you optimize image caching in CI/CD builds?**

Order Dockerfile steps → COPY package*.json before COPY .

## KUBERNETES & ORCHESTRATION

**Explain how you'd deploy a containerized app on Kubernetes.**

Create Deployment, Service, optional Ingress.

`kubectl apply -f deployment.yaml`

**What's the role of a Pod, Deployment, and Service?**

Pod = container runtime; Deployment = replica management; Service = network endpoint.

**How do you manage environment variables in K8s?**

envFrom + ConfigMap or Secret.

**How would you perform rolling updates safely?**

Adjust maxSurge/maxUnavailable → no downtime rollout.

**When do you use StatefulSets vs Deployments?**

StatefulSets = sticky identity (DBs); Deployments = stateless apps.

**How would you expose an app publicly in K8s?**

Ingress + controller (NGINX or Cloud LB).

**How do you monitor containers in K8s?**

Prometheus + Grafana stack or Cloud Monitoring (GCP/AWS).

**Explain how auto-scaling works in K8s.**

Horizontal Pod Autoscaler (HPA) uses CPU/memory metrics.

**How would you inject secrets securely in pods?**

`kubectl create secret` + envFrom: secretRef.

**Describe a Helm chart and its benefit.**

Templated K8s manifest → versioned, reusable deployments.

## CLOUD PROVIDER DEPLOYMENTS

**Walk me through deploying containers on AWS ECS.**

Build → push to ECR → create Task Definition → Service → Fargate cluster.

**How would you deploy the same on GCP Cloud Run?**

`gcloud run deploy app --source . --region <region> --platform managed`

**When would you choose Cloud Run vs GKE?**

Cloud Run = serverless, auto-scaling; GKE = full cluster control.

**How do you integrate a mobile backend container with Firebase/GCP services?**

Use service account JSON mounted as secret; restrict scopes.

**Explain AWS ECR vs Docker Hub.**

ECR = private managed registry with IAM auth; Docker Hub = public default.

**How do you automate pushing images to the cloud registry in CI/CD?**

Login via CLI (aws ecr get-login-password) → docker push.

**How do you set up GCP Artifact Registry permissions?**

Grant roles/artifactregistry.reader or writer to build service account.

**Why would you use Terraform or Pulumi here?**

Infra as Code → consistent, reviewable provisioning of cloud infra.

**What's the difference between Fargate and EC2 launch types?**

Fargate = serverless containers; EC2 = manual node management.

**How do you set up load balancing for containers on AWS/GCP?**

Use ALB (Target Group + ECS Service) or Cloud Load Balancer + Service Ingress.

## CI/CD & PIPELINE INTEGRATIONS

**Walk me through a full CI/CD flow for a containerized app.**

Checkout → Lint/Test → Build Docker → Push → Deploy (ECS/GKE).

**Which tools do you prefer for mobile backend CI/CD?**

GitHub Actions, GitLab CI, Jenkins, or Cloud Build (GCP).

**How do you manage build artifacts across pipeline stages?**

Store image digests in registry or pass via metadata.

**What's the role of docker-compose -f docker-compose.test.yml in pipelines?**

Spin up test stack for integration tests.

**How do you implement zero-downtime deployment in CI/CD?**

Blue-Green or rolling update via K8s or ECS.

**How would you trigger deployments automatically after merges?**

Use branch filter (on: push: branches: [main]) in workflow.

**How do you roll back failed container releases?**

Tag stable images (app:stable) and redeploy previous digest.

**What's the use of image tagging strategy in CI/CD?**

Tags = latest, commit SHA, semantic version for traceability.

**How do you integrate testing (unit/integration) inside containers?**

Multi-stage Dockerfile with npm test or pytest before packaging.

**How do you secure the CI/CD build environment?**

Use least-privilege IAM, avoid plaintext secrets, use OIDC tokens.

## OBSERVABILITY & MAINTENANCE

**How would you monitor app metrics in container environments?**

Prometheus exporters, Cloud Monitoring, or Datadog agent sidecars.

**Explain centralized logging for containers.**

Use FluentBit or Cloud Logging sinks for stdout/stderr aggregation.

**How do you implement health checks?**

Define /health endpoints; set in Dockerfile or K8s livenessProbe.

**How would you capture errors from mobile clients hitting your container APIs?**

Integrate Sentry/Cloud Error Reporting SDKs with backend endpoints.

**What's the backup flow for containerized databases?**

Snapshot via managed DB service or pg_dump in CronJob container.

## ADVANCED & HYBRID SETUPS

**How would you containerize a Flutter web build or RN Expo web?**

Multi-stage Docker: build → copy /build/web → NGINX serve.

**How do you deploy ML models alongside apps?**

Separate inference container or use Vertex AI Endpoint / SageMaker Endpoint.

**How would you orchestrate microservices communication securely?**

Use Service Mesh (Istio/Linkerd) or internal VPC networking.

**How do you manage cost in containerized environments?**

Right-size CPU/mem, use spot instances, scale-to-zero (Cloud Run).

**Explain your preferred DevOps toolchain end-to-end.**

- Local: Docker + Compose
- Build: GitHub Actions + Lint/Test
- Registry: ECR/Artifact Registry
- Deploy: Kubernetes / Cloud Run
- Monitor: Prometheus + Grafana + Cloud Logs
- Alerting: PagerDuty or OpsGenie
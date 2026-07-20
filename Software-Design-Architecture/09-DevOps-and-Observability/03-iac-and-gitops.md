# 03 - Infrastructure as Code (IaC) and GitOps

Managing servers by manually clicking through a cloud provider's web console is prone to human error, undocumented changes, and is impossible to replicate. 

## 1. Infrastructure as Code (IaC)
IaC is the process of managing and provisioning computing infrastructure through machine-readable definition files rather than physical hardware configuration or interactive configuration tools.

- **Declarative vs Imperative:**
  - *Declarative (e.g., Terraform, CloudFormation):* You define the *desired state* ("I want 3 servers and a load balancer"), and the tool figures out how to create them.
  - *Imperative (e.g., Ansible, Chef scripts):* You define the *exact steps* to reach the desired state ("Create a server. Wait. Install Apache. Wait...").
- **Terraform:** The industry standard for declarative infrastructure provisioning across any cloud (AWS, GCP, Azure). It uses `.tf` files and maintains a `state` file to track what it has created.
- **Immutable Infrastructure:** Instead of logging into a server to update a package (mutable), you destroy the server and replace it with a newly provisioned one built from an updated image (immutable).

## 2. GitOps
GitOps takes IaC a step further by making Git the single source of truth for your entire system (infrastructure and applications).

- **How it Works:** Instead of a CI/CD pipeline *pushing* changes to your cluster (e.g., running `kubectl apply`), a GitOps software agent runs *inside* your cluster, constantly watching a Git repository. 
- **The Pull Model:** When you merge a change to the main branch (e.g., changing the app version from `v1` to `v2`), the GitOps agent notices the drift between the Git repository and the live cluster, and *pulls* the changes in, updating the cluster automatically.
- **Benefits:** Massive security boost (your CI server doesn't need admin access to your production cluster), easy rollbacks (just `git revert`), and a perfect audit trail.
- **Tools:** ArgoCD, Flux.

---
**Next Step:** Manage thousands of containers at scale in [04 - Kubernetes Orchestration](./04-kubernetes-orchestration.md).

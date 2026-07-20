# 05 - Infrastructure as Code & Automation

Clicking through the AWS or GCP console to create servers, databases, and networks is acceptable for learning, but it is an anti-pattern in production. Architectures must be reproducible, auditable, and automated.

## 1. Infrastructure as Code (IaC) Review
*(Note: We touched on IaC in DevOps, but its role in Cloud Architecture is paramount).*
- **Terraform:** The most popular open-source tool by HashiCorp. It is cloud-agnostic, meaning you use the same language (HCL) to define resources for AWS, GCP, Azure, and even GitHub or Datadog.
- **CloudFormation:** AWS's native IaC tool. Uses YAML/JSON.
- **Pulumi / AWS CDK:** Newer paradigms that allow you to define infrastructure using familiar programming languages (TypeScript, Python, Go) rather than configuration languages like HCL or YAML.

## 2. Why IaC is Critical for Cloud Architecture
- **Reproducibility:** If you build a complex architecture for your Staging environment, you can deploy the exact identical architecture for Production in minutes.
- **Disaster Recovery:** If a region goes down or a rogue script deletes your VPC, you can rebuild the entire infrastructure from scratch automatically.
- **Security & Code Review:** Changes to firewalls (Security Groups) or IAM roles are submitted as Pull Requests. Your team can review the changes before they are applied.

## 3. Configuration Management vs Provisioning
- **Provisioning (Terraform):** Creates the hardware and cloud resources (VPCs, EC2 instances, Load Balancers).
- **Configuration (Ansible, Chef, Puppet):** Once the EC2 instance is created, these tools SSH into the machine, install Nginx, pull the code, and start the service.
- *Modern Trend:* The industry is moving toward immutable infrastructure (using Docker or Packer). Instead of using Ansible to configure a running server, you bake the configuration into an image, and Terraform simply deploys the pre-configured image.

---
**Next Step:** Finalize your cloud mastery by reviewing the [06 - Well-Architected Framework & Advanced Topics](./06-well-architected-advanced.md).

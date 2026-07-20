# 01 - Foundational Cloud Services (AWS & GCP)

Moving to the cloud means trading capital expense (buying servers) for variable expense (paying for what you use). To design cloud architectures, you must understand the foundational building blocks provided by hyperscalers like AWS (Amazon Web Services) and GCP (Google Cloud Platform).

## 1. Identity and Access Management (IAM)
Security is Job Zero. IAM lets you manage access to compute, storage, and databases.
- **Users and Roles:** Instead of hardcoding credentials, applications assume *Roles* that grant them temporary permissions (e.g., allowing an EC2 server to read an S3 bucket).
- **Principle of Least Privilege:** Always grant the absolute minimum permissions necessary.

## 2. Compute
Where your code actually runs.
- **Virtual Machines (IaaS):** AWS EC2, GCP Compute Engine. You get a raw virtual server. You manage the OS, updates, and runtime. Best for legacy apps or absolute control.
- **Containers as a Service (CaaS):** AWS ECS/EKS, GCP GKE. Managed platforms to run Docker containers. 

## 3. Storage
Cloud storage is durable, scalable, and highly available.
- **Object Storage:** AWS S3, GCP Cloud Storage. For storing unstructured data like images, backups, and static website files. It scales infinitely.
- **Block Storage:** AWS EBS, GCP Persistent Disk. Virtual hard drives attached to your Virtual Machines.
- **File Storage:** AWS EFS, GCP Filestore. Shared file systems that multiple VMs can mount simultaneously.

## 4. Databases
- **Relational (SQL):** AWS RDS (Aurora), GCP Cloud SQL (Spanner). Managed MySQL/Postgres databases with automatic backups and failover.
- **NoSQL:** AWS DynamoDB, GCP Firestore/Bigtable. Highly scalable, schema-less databases designed for massive throughput and single-digit millisecond latency.

## 5. Networking (VPC)
- **Virtual Private Cloud (VPC):** A logically isolated section of the cloud where you launch resources in a virtual network you define. You control subnets, IP ranges, and routing tables.
- **Public vs. Private Subnets:** Databases should *always* live in private subnets with no direct internet access. Web servers can live in public subnets or behind load balancers.

---
**Next Step:** Learn how to move away from managing servers entirely in [02 - Cloud-Native & Serverless Architectures](./02-cloud-native-serverless.md).

# 06 - The Well-Architected Framework & Advanced Topics

To ensure you are building systems according to cloud best practices, AWS and GCP have codified their knowledge into the "Well-Architected Framework."

## 1. The 6 Pillars of the Well-Architected Framework
Whenever you design a system, evaluate it against these six pillars:
1. **Operational Excellence:** Running and monitoring systems to deliver business value, and continually improving processes and procedures.
2. **Security:** Protecting information and systems (Encryption, IAM, least privilege).
3. **Reliability:** The ability of a system to recover from failures and mitigate disruptions (Multi-AZ, backups, failover).
4. **Performance Efficiency:** Using computing resources efficiently (Right-sizing, Serverless).
5. **Cost Optimization:** Avoiding unnecessary costs (Spot instances, lifecycle policies).
6. **Sustainability:** Minimizing the environmental impacts of running cloud workloads (optimizing code to use fewer CPU cycles).

## 2. Multi-Cloud and Hybrid Cloud
- **Multi-Cloud:** Using AWS for compute, GCP for machine learning, and Azure for Active Directory. It prevents vendor lock-in but significantly increases complexity and networking costs.
- **Hybrid Cloud:** Keeping sensitive legacy data on on-premises bare-metal servers while bursting compute workloads into the public cloud.
- **Tools for this:** Kubernetes, Google Anthos, and Azure Arc allow you to manage workloads across on-prem and multiple clouds from a single control plane.

## 3. Edge Computing and CDNs
Moving compute closer to the end user reduces latency.
- **Content Delivery Networks (CDNs):** AWS CloudFront, Cloudflare. They cache static assets (images, CSS) in data centers all around the globe. A user in Tokyo downloads the image from Tokyo, not from your origin server in New York.
- **Edge Computing:** AWS Lambda@Edge, Cloudflare Workers. Running actual serverless functions at the CDN level. You can modify HTTP headers, redirect users, or perform authentication in the edge location closest to the user, offloading work from your main servers.

---
**Congratulations!** You have completed the Cloud Architecture module. You are now equipped to design scalable, secure, and cost-effective cloud systems. Head back to the [Main Syllabus](./README.md).

# 03 - High Availability & Resiliency Design

In the cloud, hardware failures are treated as normal occurrences. Your architecture must be designed to survive the loss of servers, network switches, or even entire data centers.

## 1. Availability Zones and Regions
- **Regions:** A physical location around the world (e.g., `us-east-1` in Virginia) where a cloud provider clusters data centers.
- **Availability Zones (AZs):** Distinct, isolated data centers within a Region. They have independent power, cooling, and network connectivity.
- **Multi-AZ Architecture:** You should *always* deploy your application across at least two AZs. If one data center catches fire, your application continues running from the other AZ with zero downtime.

## 2. Load Balancing and Routing
- **Load Balancers:** AWS ALB/NLB. They automatically distribute incoming application traffic across multiple targets (like EC2 instances or containers) in multiple AZs. They also perform health checks, routing traffic away from unhealthy instances.
- **DNS Failover:** AWS Route 53. You can set up health checks on your primary region. If the entire region goes down (rare, but happens), DNS will automatically route users to a backup region (Multi-Region Disaster Recovery).

## 3. Handling Spikes: Load Shedding and Throttling
Sometimes, traffic spikes are so massive that auto-scaling can't keep up.
- **Load Shedding:** Intentionally dropping or rejecting requests to prevent the entire system from crashing. It's better for 10% of users to see an error than for the database to lock up and 100% of users to see an error.
- **Rate Limiting:** Capping the number of requests a specific user/IP can make per second.

## 4. Disaster Recovery (DR)
- **RPO (Recovery Point Objective):** How much data can you afford to lose? (e.g., "We back up the database every hour, so our RPO is 1 hour").
- **RTO (Recovery Time Objective):** How quickly must the system be back online after a disaster? (e.g., "The site must be back up in 15 minutes").
- DR Strategies range from "Backup and Restore" (cheap, slow RTO) to "Active-Active Multi-Region" (very expensive, instant RTO).

---
**Next Step:** Make sure you don't go bankrupt running this resilient system in [04 - Cost-Effective Architecture](./04-cost-optimization.md).

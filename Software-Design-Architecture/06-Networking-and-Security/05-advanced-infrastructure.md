# 05 - Advanced Infrastructure Security

As systems scale and move to the cloud, network perimeters dissolve. Modern architecture requires advanced infrastructure defenses.

## 1. Zero Trust Architecture (ZTA)
Historically, corporate networks assumed that anything "inside" the firewall was trustworthy (the "castle-and-moat" model). **Zero Trust** abandons this.
- **Core philosophy:** Never trust, always verify.
- Every request between microservices—even if they are on the same private subnet—must be authenticated, authorized, and encrypted.

## 2. Service Mesh and mTLS
Implementing Zero Trust manually in hundreds of microservices is impossible. 
- **Service Mesh:** Infrastructure software (like Istio or Linkerd) that injects a "sidecar" proxy next to every microservice.
- **mTLS (Mutual TLS):** The service mesh automatically encrypts all traffic between services. Both the client and the server cryptographically verify each other's identities before exchanging data.

## 3. Web Application Firewalls (WAF)
A WAF sits in front of web applications and inspects incoming HTTP traffic. 
- It filters and blocks malicious traffic based on rulesets (like SQL injection or XSS patterns).
- Unlike a standard firewall that looks at IP addresses and ports, a WAF understands Layer 7 web traffic.

## 4. DDoS Mitigation
Distributed Denial of Service attacks attempt to overwhelm a system with junk traffic.
- **Defenses:** Using CDNs (Content Delivery Networks) like Cloudflare or Akamai. These networks have massive global bandwidth and can absorb and scrub malicious traffic before it ever reaches your origin servers.

---
**Congratulations!** You now have a solid foundation in software networking and security. Head back to the [Main Syllabus](./README.md).

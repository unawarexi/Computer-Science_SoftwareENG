# Load Balancing

## 1. What is Load Balancing?

Load balancing is the process of distributing network traffic across multiple servers to ensure no single server gets overwhelmed.
It improves application availability, scalability, and reliability.

## 2. How Load Balancing Works (Step-by-Step)

1. **Client Request**: User sends a request to the load balancer.
2. **Load Balancer**: Receives the request and selects a backend server based on the algorithm.
3. **Forward Request**: Forwards the request to the selected server.
4. **Server Response**: Server processes the request and sends the response back to the load balancer.
5. **Load Balancer**: Returns the response to the client.

## 3. Key Load Balancing Concepts

- **Health Checks**: Load balancers continuously check the health of backend servers and remove unhealthy servers from rotation.
- **Session Persistence (Sticky Sessions)**: Ensures a client is always sent to the same server for the duration of their session.
- **SSL Termination**: Load balancers can decrypt SSL/TLS traffic, reducing the processing load on backend servers.
- **Session Affinity**: Similar to sticky sessions but more flexible, allowing routing based on session attributes.

## 4. Load Balancing Algorithms

- **Round Robin**: Distributes requests sequentially to each server.
- **Weighted Round Robin**: Servers with higher weights receive more requests.
- **Least Connections**: Sends requests to the server with the fewest active connections.
- **Weighted Least Connections**: Combines weighting with least connections.
- **IP Hash**: Uses client IP hash to determine the server.
- **Least Response Time**: Sends requests to the server with the fastest response time.
- **Least Bandwidth**: Sends requests to the server with the least current bandwidth usage.

## 5. Types of Load Balancers

- **Hardware Load Balancers** - Physical appliances (e.g., F5 BIG-IP, Citrix ADC)
- **Software Load Balancers** - Software running on commodity hardware or VMs
- **Cloud Load Balancers** - Managed load balancing services provided by cloud providers
- **Application Load Balancers (Layer 7)** - Operate at the application layer, can route based on URL, cookies, etc.
- **Network Load Balancers (Layer 4)** - Operate at the transport layer, route based on IP and port
- **Global Server Load Balancing (GSLB)** - Distributes traffic across multiple geographic locations

## 6. Common Load Balancing Providers

- **Cloudflare Load Balancing** - Global load balancing with CDN integration
- **AWS Elastic Load Balancing (ELB)** - Application Load Balancer, Network Load Balancer, Gateway Load Balancer, Classic Load Balancer
- **Google Cloud Load Balancing** - Global HTTP(S), TCP, and UDP load balancing
- **Azure Load Balancer** - Layer 4 load balancing with health probes
- **NGINX** - Popular open-source reverse proxy and load balancer
- **HAProxy** - High-performance TCP/HTTP load balancer and proxy
- **Envoy Proxy** - Open-source edge and service proxy
- **Traefik** - Modern HTTP reverse proxy and load balancer with container awareness
- **F5 BIG-IP** - Enterprise-grade hardware and software load balancer

## 7. Load Balancing Security

- **DDoS Protection**: Load balancers can absorb and filter malicious traffic.
- **Web Application Firewall (WAF)**: Integrated WAF to protect against common web attacks.
- **Rate Limiting**: Limit the number of requests from a specific IP address.
- **Bot Management**: Identify and block malicious bots.
- **Security Groups/Firewalls**: Restrict access to backend servers.

## 8. Load Balancing Best Practices

- **Implement Health Checks**: Continuously monitor backend server health.
- **Use Health Check Timeouts**: Set appropriate timeouts to avoid prolonged unhealthy server selection.
- **Implement Sticky Sessions When Needed**: Use only when necessary to maintain session state.
- **Configure SSL/TLS Termination**: Offload SSL processing to the load balancer.
- **Enable Health Checks**: Set up regular health checks to ensure traffic is only sent to healthy instances.
- **Use Multiple Availability Zones**: Deploy load balancers and backend servers across multiple AZs for high availability.
- **Implement Monitoring and Alerting**: Track load balancer metrics and set up alerts for issues.
- **Configure Rate Limiting**: Protect backend servers from abuse.
- **Implement proper Timeouts**: Set appropriate timeouts for health checks and client requests.
- **Monitor and Adjust Algorithms**: Regularly review algorithm performance and adjust as needed.

## 9. Load Balancing Tools

- **NGINX** - Open-source reverse proxy and load balancer
- **HAProxy** - High-performance TCP/HTTP load balancer
- **Traefik** - Modern edge router and load balancer for microservices
- **Envoy Proxy** - Cloud-native sidecar proxy
- **AWS ELB** - Elastic Load Balancing for AWS
- **Google Cloud Load Balancing** - Google Cloud's load balancing service
- **Azure Load Balancer** - Azure's load balancing service
- **Keepalived** - High-availability and load balancing using VRRP
- **F5 BIG-IP** - Enterprise-grade load balancer
- **Cloudflare Load Balancing** - Cloudflare's global load balancing solution

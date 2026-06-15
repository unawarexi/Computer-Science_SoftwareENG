# DNS (Domain Name System)

## 1. What is DNS?

DNS is the phonebook of the internet.
It translates human-readable domain names (like google.com) into machine-readable IP addresses (like [IP_ADDRESS]).
Without DNS, you'd have to remember IP addresses for every website you visit.

## 2. How DNS Resolution Works (Step-by-Step)

When you type a URL into your browser:

1. **Browser Check**: Browser checks its cache for the IP address.
2. **OS Check**: If not in browser cache, OS checks its resolver cache.
3. **Router Check**: If not in OS cache, checks router's cache.
4. **Recursive Resolver**: Queries the ISP's DNS server (recursive resolver).
5. **Root Servers**: Recursive resolver asks root DNS servers (`.`).
6. **TLD Servers**: Root servers point to Top-Level Domain servers (`.com`, `.org`).
7. **Authoritative Servers**: TLD servers point to authoritative DNS servers (for that specific domain).
8. **Response**: Authoritative servers return the IP address.
9. **Browser**: Browser caches the result and loads the website.

## 3. Key DNS Record Types

- **A record** - Maps domain name to IPv4 address
- **AAAA record** - Maps domain name to IPv6 address
- **CNAME record** - Maps domain name to another domain name (alias)
- **MX record** - Mail Exchange records (for email routing)
- **TXT record** - Text records (used for verification, SPF, DKIM)
- **PTR record** - Pointer records (reverse DNS lookup)
- **SRV record** - Service records (specify host and port for specific services)

## 4. DNS Configuration

- **TTL (Time To Live)** - How long DNS records are cached (lower TTL = faster updates, higher load on servers)
- **Zone Files** - Files containing DNS records for a domain
- **DNSSEC** - DNS Security Extensions (adds cryptographic signatures to DNS records)

## 5. Common DNS Providers

- **Cloudflare DNS** - Fast, secure, good free tier
- **Google Cloud DNS** - Integrates with Google Cloud Platform
- **AWS Route 53** - Integrates with AWS services
- **Azure DNS** - Integrates with Azure services
- **NS1** - Enterprise-grade DNS management
- **Dyn** - Oracle's enterprise DNS service
- **GoDaddy, Namecheap** - Common registrar DNS

## 6. DNS Security

- **DNS Spoofing** - Redirecting traffic to malicious sites
- **DNS Cache Poisoning** - Corrupting DNS cache with false records
- **DNS Amplification Attacks** - DDoS attacks using DNS
- **DNSSEC** - Protects against DNS spoofing
- **DoH (DNS over HTTPS)** - Encrypts DNS queries
- **DoT (DNS over TLS)** - Encrypts DNS queries

## 7. DNS Tools

- **nslookup** - Classic DNS lookup tool
- **dig** - More advanced DNS lookup
- **host** - Simple DNS lookup
- **whois** - Domain registration information
- **DNSPerf** - DNS performance benchmarking

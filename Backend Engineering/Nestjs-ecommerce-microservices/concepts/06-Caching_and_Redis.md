# Caching & Redis

## Overview
Reducing database load and improving response times using in-memory caches.

## Topics
1. **Redis in NestJS**
   - Integrating `cache-manager` with Redis store.

2. **Caching Strategies**
   - **Cache-Aside**: Application checks cache, then DB, then writes to cache.
   - **Write-Through / Write-Behind**: Keeping cache and DB in sync.

3. **Use Cases**
   - Session storage.
   - Caching frequent queries (e.g., homepage products, category trees).
   - Rate limiting counters.

4. **Cache Invalidation**
   - TTL (Time-To-Live).
   - Event-driven invalidation (e.g., invalidating product cache when price updates).

# Top 50 Questions: Networking, Latency & Error Handling

A comprehensive guide for Flutter and React Native developers covering networking fundamentals, optimization, and error handling.

## Fundamentals of Networking (1-10)

### 1. Walk me through how networking works in Flutter and React Native

**Flutter**: http, dio, chopper, or graphql_flutter for REST/GraphQL.

**React Native**: fetch, axios, or react-query for data fetching.

Both use platform-native HTTP stacks under the hood.

### 2. What's the difference between fetch and axios in React Native?

fetch is built-in, minimal; axios adds interceptors, cancellation, JSON auto-parsing.

### 3. What's the Flutter equivalent of axios?

dio — supports interceptors, cancellation, timeouts, form-data, retries.

### 4. What's the best way to handle async network requests?

**Flutter**: Future / async-await

**React Native**: Promise / async-await

### 5. How to cancel network requests?

**Flutter (dio)**: CancelToken

**React Native (axios)**: CancelToken or AbortController (fetch)

### 6. How do you detect if the device is online/offline?

**Flutter**: connectivity_plus

**React Native**: @react-native-community/netinfo

### 7. How should your app behave when offline?

Show cached data → queue writes → show "retry" CTA → auto-resume when reconnected.

### 8. What's the difference between GET and POST in performance terms?

GET cacheable, idempotent. POST carries payloads, no browser caching.

### 9. Why should you avoid unnecessary polling?

Increases battery and network drain; use WebSockets or push notifications.

### 10. How do you handle HTTP timeouts?

**Flutter**: `dio.options.connectTimeout`

**React Native**: `axios.defaults.timeout`

Always surface fallback UI.

## Latency Reduction & Optimization (11-20)

### 11. What are top strategies to reduce app latency?

Caching, request batching, CDN endpoints, compression, HTTP/2 or gRPC.

### 12. How do you handle slow networks gracefully?

Show skeleton loaders, preload critical data, lazy load heavy data.

### 13. What's the impact of DNS latency, and how can you reduce it?

High DNS lookup time → use DNS caching or CDN-provided endpoints.

### 14. How do you detect slow network conditions?

**React Native**: `NetInfo.fetch()` with `details.downlink`

**Flutter**: measure request RTT manually or via connectivity events

### 15. What's the effect of TCP handshake delay in mobile apps?

Adds round-trip time; mitigate with persistent connections (Keep-Alive).

### 16. How can HTTP/2 improve latency?

Multiplexing — multiple requests over single TCP connection.

### 17. When should you prefetch data?

Anticipate upcoming screens (e.g., home → profile); prefetch on idle frames.

### 18. How to optimize image fetching?

CDN with WebP/AVIF, lazy loading, caching headers, placeholders.

### 19. How to handle latency in chat or live apps?

Use WebSockets or MQTT; handle connection drops with exponential backoff.

### 20. What's the difference between optimistic and pessimistic updates?

**Optimistic** = update UI before server confirms (faster UX)

**Pessimistic** = wait for server success (safer, slower)

## Retry & Resilience Patterns (21-30)

### 21. How do you implement automatic retry on network failure?

**Flutter (dio)**: RetryInterceptor; exponential backoff

**React Query / Axios**: retry with delay logic

### 22. How to avoid retry storms?

Limit retry count and backoff exponentially (2^n * baseDelay).

### 23. What's a circuit breaker pattern?

Temporarily block requests to a failing endpoint to prevent system overload.

### 24. How do you detect server errors vs network errors?

**Server** = valid response (5xx)

**Network** = no response (timeout, DNS, offline)

### 25. How do you handle stale data after failed refresh?

Serve cached data + show "Last updated X mins ago".

### 26. How can you recover gracefully from API failure?

Retry silently, fallback to local cache, or show non-blocking warning.

### 27. How do you notify users of lost connectivity?

Persistent banner / snackbar saying "No Internet — retrying".

### 28. How do you queue actions when offline?

Save request metadata → replay when back online (e.g., pending posts).

### 29. How do you ensure idempotency on retries?

Use request IDs so the server can ignore duplicates.

### 30. How do you log network errors for diagnostics?

Capture request URL, method, headers, response status, latency metrics.

## Caching & Data Consistency (31-40)

### 31. How does caching improve perceived performance?

Serves local data instantly → reduces wait time → improves UX on slow networks.

### 32. How do you implement request caching?

**Flutter**: dio_cache_interceptor

**React Native**: react-query cache or manual AsyncStorage

### 33. What's the difference between memory cache and disk cache?

**Memory**: faster, volatile

**Disk**: persistent but slower

### 34. How to handle stale cache invalidation?

Include ETag, timestamps, or TTL headers in API.

### 35. When to use conditional GETs (If-Modified-Since)?

To revalidate cached resources efficiently.

### 36. How do you cache images effectively?

**Flutter**: cached_network_image

**React Native**: react-native-fast-image or caching headers

### 37. How do you sync cached state after reconnect?

Compare timestamps; push queued actions; revalidate via background fetch.

### 38. What is delta sync?

Only sync changed data since last update; reduces bandwidth.

### 39. How do you use GraphQL for efficient caching?

Apollo/Hasura cache normalized responses; auto-update minimal diffs.

### 40. How do you test caching logic?

Simulate offline, clear cache, validate freshness and invalidation flow.

## Error Handling & UX Recovery (41-50)

### 41. How do you classify network errors in your app?

Timeout, DNS failure, 4xx client error, 5xx server error, serialization error.

### 42. How should UI respond to network errors?

Retry CTA, cached fallback, meaningful error text (not raw message).

### 43. What's the best practice for timeout UX?

Show a spinner ≤ 10s → fallback "Retry" button → log event.

### 44. How to differentiate between user-triggered cancel vs network failure?

Cancel tokens or custom error code.

### 45. How do you prevent infinite loading states?

Timeout + fallback screen after threshold.

### 46. What's the right way to handle 401/403 (auth errors)?

Refresh token; redirect to login if invalid.

### 47. How do you handle 429 (rate-limited) responses?

Respect Retry-After header; pause requests until limit resets.

### 48. How do you surface background sync errors without breaking UX?

Silent toast, badge indicator, or retry silently.

### 49. How do you capture network traces in production?

**Flutter**: interceptors → local logs or Sentry

**React Native**: axios interceptors + remote logging

### 50. What defines a "good network experience" for mobile users?

Fast perceived responses (< 1.5s), graceful fallbacks offline, consistent loading states, no silent crashes, offline-friendly UI, and safe retries.

## Senior-Level Key Insights

- Always design for offline-first and eventual consistency
- Use interceptors for logging, metrics, retries, and token injection
- Batch, cache, and compress network requests
- Handle 4xx and 5xx errors distinctly; retry only safe requests
- Integrate network status listeners to dynamically switch offline/online UX
- Keep the UI responsive under latency — never block the main thread
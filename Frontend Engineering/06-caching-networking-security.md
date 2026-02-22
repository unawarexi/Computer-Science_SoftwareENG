# Caching, Networking & Security

---

## 40. IndexedDB

**What it is:**  
IndexedDB is a low-level, transactional, NoSQL database built into the browser. It stores large amounts of structured data (including files and blobs) with indexed queries, far exceeding `localStorage`'s 5–10MB limit.

**Key characteristics:**

- **Asynchronous** — all operations are non-blocking (unlike `localStorage`).
- **Transactional** — all reads/writes happen within transactions that auto-rollback on error.
- **Object store-based** — data is stored in object stores (like tables) with key paths.
- **Indexed** — create indexes on properties for efficient querying.
- **Large storage** — typically 50%+ of disk space (hundreds of MB to GB).

**Interview-level insight:**

- The API is notoriously **verbose and callback-heavy**. Use wrapper libraries: **Dexie.js**, **idb** (by Jake Archibald), or **localForage**.
- IndexedDB works in **Web Workers and Service Workers** — it's the only large-storage API available in workers.
- Data persists across sessions but can be evicted under storage pressure unless you request `navigator.storage.persist()`.
- Versioning and migrations are handled via the `onupgradeneeded` event — you must increment the version number to change schema.
- **Structured cloning** is used to store/retrieve data, so you can store objects, arrays, Dates, Blobs, but NOT functions or DOM nodes.

**Where it's applicable:**  
Offline-first PWAs, caching API responses, storing user-generated content, email clients (Gmail Offline), large dataset storage, client-side search indexes.

---

## 41. Service Worker Lifecycle Traps

**What it is:**  
Service Workers have a multi-phase lifecycle (install → waiting → activate → fetch) with behaviors that often surprise developers and cause subtle caching bugs.

**Common traps:**

1. **Waiting phase**: A new SW won't activate while any tab using the old SW is open. The new SW sits in "waiting" state indefinitely.
   - Fix: `self.skipWaiting()` in the install event, but this can cause version mismatches mid-session.
2. **Stale cache served forever**: If you cache responses in `install` but never update the cache, users get stale content forever.
   - Fix: version your cache names and delete old caches in `activate`.
3. **No fetch interception on first load**: The SW only intercepts fetches for pages loaded AFTER it's activated. The very first page load doesn't go through the SW.
   - Fix: `clients.claim()` in the activate event.
4. **Cache-first serving outdated HTML**: Caching the HTML shell means updates require the SW to update first.
   - Fix: Use network-first or stale-while-revalidate for HTML.

**Interview-level insight:**

- The lifecycle is designed for **reliability over convenience** — it ensures all tabs see a consistent version.
- `skipWaiting() + clients.claim()` is the aggressive approach — but it means the new SW may serve new assets to a page that loaded with old HTML.
- Workbox (Google's SW library) handles all of these traps with preconfigured strategies.

**Where it's applicable:**  
PWAs, offline-first applications, any site using service workers for caching.

---

## 42. Cache Invalidation Strategies

**What it is:**  
Cache invalidation is the process of determining when cached data is no longer valid and should be replaced with fresh data. It's famously one of the "two hard things in computer science."

**Strategies:**

1. **Time-based (TTL)** — Cache expires after a fixed duration. Simple but imprecise.
2. **Version-based** — Cache key includes a version or content hash (`app.v2.js`, `app.a1b2c3.js`). New version = new cache entry.
3. **Event-based** — Cache is invalidated when a specific event occurs (webhook, SSE, WebSocket message).
4. **Stale-while-revalidate** — Serve stale data immediately, fetch fresh data in the background, update cache for next request.
5. **Tag-based** — Cache entries are tagged; invalidating a tag invalidates all entries with that tag (e.g., Next.js `revalidateTag`).

**Interview-level insight:**

- Content-hashed filenames (`[name].[contenthash].js`) are the gold standard for static assets — they can be cached forever (`max-age=31536000`) because the URL changes when content changes.
- The HTML file itself should NOT be aggressively cached (use `no-cache` or short `max-age`) because it contains references to the hashed asset URLs.
- CDN purging is a form of event-based invalidation — but CDN propagation has latency.

**Where it's applicable:**  
Static asset caching, API response caching, CDN configuration, SW cache management, SSR page caching.

---

## 43. Stale-While-Revalidate

**What it is:**  
A caching strategy where the cache serves a **stale** (potentially outdated) response immediately for fast UX, while simultaneously fetching a **fresh** response from the network in the background to update the cache for the next request.

**HTTP header:**

```
Cache-Control: max-age=60, stale-while-revalidate=3600
```

This means: use the cache for 60 seconds. After 60 seconds and up to 1 hour, serve stale but revalidate in background.

**In Service Workers:**

```javascript
self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.open("v1").then((cache) =>
      cache.match(event.request).then((cached) => {
        const fetched = fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
        return cached || fetched;
      }),
    ),
  );
});
```

**Interview-level insight:**

- SWR provides the best of both worlds: **instant responses** (from cache) and **eventual consistency** (background fetch).
- SWR libraries for data fetching (SWR by Vercel, TanStack Query) are named after this pattern.
- The trade-off: users see stale data for one request cycle. For most use cases (social feeds, product listings), this is acceptable.
- Not suitable for data that must always be fresh (financial transactions, real-time bidding).

**Where it's applicable:**  
API data fetching (SWR, React Query), Service Worker caching, CDN edge caching, news feeds, product catalogs.

---

## 44. ETag vs Cache-Control

**What it is:**  
Both are HTTP caching mechanisms but work differently:

| Feature         | Cache-Control                                        | ETag                                                  |
| --------------- | ---------------------------------------------------- | ----------------------------------------------------- |
| Type            | Expiration-based                                     | Validation-based                                      |
| How it works    | Browser uses cached response until `max-age` expires | Browser asks server "has this changed?" with the ETag |
| Network request | None (until expired)                                 | Conditional request (`If-None-Match`)                 |
| Server response | N/A                                                  | `304 Not Modified` (no body) or `200` (new body)      |
| Header          | `Cache-Control: max-age=3600`                        | `ETag: "abc123"`                                      |

**Interview-level insight:**

- `Cache-Control` is preferred for **static assets** with hashed filenames — set `max-age=31536000, immutable`.
- `ETag` is better for **dynamic content** — avoids re-downloading unchanged data but still requires a network round-trip.
- `Last-Modified` / `If-Modified-Since` is the older alternative to ETag, based on timestamps instead of hashes.
- `no-cache` does NOT mean "don't cache" — it means "cache, but revalidate with the server every time" (use ETag/Last-Modified).
- `no-store` truly means "don't cache at all."
- `Cache-Control` and `ETag` can be used **together**: use Cache-Control for freshness, ETag as a fallback for revalidation.

**Where it's applicable:**  
HTTP caching configuration, CDN setup, API response headers, static site deployment.

---

## 45. HTTP/3 and QUIC

**What it is:**  
HTTP/3 is the latest version of the HTTP protocol, built on **QUIC** (Quick UDP Internet Connections) instead of TCP. QUIC is a transport protocol that runs over UDP, providing built-in encryption (TLS 1.3) and solving TCP's head-of-line blocking problem.

**Key improvements over HTTP/2:**  
| Feature | HTTP/2 (TCP) | HTTP/3 (QUIC) |
|---------|-------------|---------------|
| Head-of-line blocking | Stream-level (one lost packet blocks ALL streams) | Per-stream (lost packet only blocks its stream) |
| Connection establishment | TCP handshake + TLS handshake (2-3 RTTs) | 0-1 RTT (combined with TLS) |
| Connection migration | New connection on network change | Connections survive network changes (Connection IDs) |
| Packet loss recovery | TCP retransmission (slow) | Per-stream retransmission (faster) |

**Interview-level insight:**

- HTTP/2 solved HTTP/1.1's head-of-line blocking at the HTTP level but introduced it at the TCP level (a single lost TCP packet stalls all multiplexed streams).
- QUIC solves this by implementing streams at the transport layer — each stream has independent loss recovery.
- **0-RTT connection resumption** — returning visitors can start sending data immediately (like TLS session tickets but at the transport level).
- Connection migration: when a user switches from WiFi to cellular, the QUIC connection stays alive (identified by Connection ID, not IP address).
- Supported by all major browsers and CDNs (Cloudflare, Google, Fastly).

**Where it's applicable:**  
Any web application — especially mobile-first apps (connection migration), real-time apps (lower latency), and high-latency networks.

---

## 46. Priority Hints

**What it is:**  
Priority Hints let developers explicitly tell the browser how important a resource is, overriding the browser's default prioritization.

```html
<img src="hero.jpg" fetchpriority="high">      <!-- Above-the-fold hero -->
<img src="carousel-3.jpg" fetchpriority="low">  <!-- Below-the-fold -->
<script src="analytics.js" fetchpriority="low">  <!-- Non-critical script -->
<link rel="preload" href="font.woff2" as="font" fetchpriority="high">
```

**Interview-level insight:**

- The `fetchpriority` attribute accepts `high`, `low`, or `auto` (default).
- Also works in the Fetch API: `fetch(url, { priority: 'high' })`.
- The browser already has internal heuristics (e.g., CSS is high, images are low) — priority hints let you **correct** these heuristics when they're wrong.
- Common use case: the LCP image is typically not prioritized by the browser because it doesn't know which image matters most. `fetchpriority="high"` fixes this.
- Overusing `high` negates the benefit — if everything is high priority, nothing is.

**Where it's applicable:**  
LCP optimization, hero image loading, critical vs. non-critical script ordering, and preload prioritization.

---

## 47. Preload vs Prefetch vs Preconnect

**What it is:**  
Three resource hints that tell the browser to prepare resources ahead of time:

| Hint         | When to use                            | Priority   | Behavior                                    |
| ------------ | -------------------------------------- | ---------- | ------------------------------------------- |
| `preload`    | Current page needs this resource soon  | High       | Fetch immediately, for current navigation   |
| `prefetch`   | Future page/interaction will need this | Low (idle) | Fetch when idle, for future navigation      |
| `preconnect` | Will need a connection to this origin  | N/A        | DNS + TCP + TLS handshake, no data transfer |

```html
<link rel="preload" href="/fonts/inter.woff2" as="font" crossorigin />
<link rel="prefetch" href="/dashboard" />
<link rel="preconnect" href="https://api.example.com" />
```

**Interview-level insight:**

- `preload` is for the **current** page — "fetch this now, I need it." If you preload but never use the resource, the browser warns after 3 seconds.
- `prefetch` is for **future** navigations — "the user will likely go here next." It's low priority and can be cancelled.
- `preconnect` saves **100-300ms** by doing the connection handshake early, without actually downloading anything.
- `dns-prefetch` is a lighter version of `preconnect` — DNS lookup only, broader browser support.
- `modulepreload` is specifically for ES modules — it preloads AND parses/compiles the module.

**Where it's applicable:**  
Font loading (preload), SPA route prefetching (prefetch), third-party API connections (preconnect), performance-critical pages.

---

## 48. CORS Preflight

**What it is:**  
A CORS preflight is an automatic `OPTIONS` request the browser sends before the actual request when certain conditions are met. It asks the server: "will you accept this cross-origin request with these headers/methods?"

**When a preflight is triggered:**

- HTTP method is not `GET`, `HEAD`, or `POST`
- Custom headers beyond "simple" headers (`Authorization`, custom headers)
- `Content-Type` is not `text/plain`, `multipart/form-data`, or `application/x-www-form-urlencoded`

**Preflight flow:**

```
Browser → OPTIONS /api/data HTTP/1.1
           Origin: https://frontend.com
           Access-Control-Request-Method: PUT
           Access-Control-Request-Headers: Authorization

Server  → 200 OK
           Access-Control-Allow-Origin: https://frontend.com
           Access-Control-Allow-Methods: PUT
           Access-Control-Allow-Headers: Authorization
           Access-Control-Max-Age: 86400  ← Cache preflight for 24h

Browser → PUT /api/data HTTP/1.1  (actual request)
```

**Interview-level insight:**

- Preflights add **latency** — each new cross-origin request type requires an extra round-trip.
- `Access-Control-Max-Age` caches the preflight result, avoiding repeated OPTIONS requests.
- "Simple requests" (GET/POST with simple headers) skip the preflight — they're sent directly with an `Origin` header.
- Handling CORS server-side: whitelist specific origins (not `*` for credentialed requests), return proper headers.
- `Access-Control-Allow-Credentials: true` is needed for cookies/auth headers, and the origin MUST be explicit (not `*`).

**Where it's applicable:**  
API integrations, SPA-backend communication, third-party API usage, microservices with different origins.

---

## 49. SameSite Cookie Modes

**What it is:**  
The `SameSite` cookie attribute controls when cookies are sent in cross-site requests, providing protection against CSRF attacks.

| Mode            | Behavior                                                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `Strict`        | Cookie sent ONLY for same-site requests. Never sent on cross-site navigation.                                                        |
| `Lax` (default) | Cookie sent for same-site requests + top-level cross-site `GET` navigations (links). Not sent for cross-site POST, iframes, or AJAX. |
| `None`          | Cookie sent on ALL cross-site requests. Requires `Secure` flag (HTTPS only).                                                         |

**Interview-level insight:**

- `Lax` is the **browser default** since Chrome 80 (2020). Previously, cookies had no SameSite restriction.
- `SameSite=Strict` breaks legitimate use cases — e.g., clicking a link from email to your app won't include the session cookie (user appears logged out).
- `SameSite=None; Secure` is required for cross-site cookies (third-party auth, embedded widgets, payment iframes).
- "Same-site" is defined by the **registrable domain** (eTLD+1), not the exact origin. `app.example.com` and `api.example.com` are same-site.
- Third-party cookie deprecation in Chrome will make `SameSite=None` cookies largely blocked.

**Where it's applicable:**  
Authentication, session management, CSRF protection, third-party integrations, embedded widgets.

---

## 50. CSRF vs XSS Mitigation

**What it is:**  
Two of the most common web security vulnerabilities:

**CSRF (Cross-Site Request Forgery):**  
An attacker tricks a logged-in user's browser into making an unwanted request to a trusted site (e.g., transferring funds).

**XSS (Cross-Site Scripting):**  
An attacker injects malicious JavaScript into a trusted site, which then executes in other users' browsers.

|                  | CSRF                                                    | XSS                                      |
| ---------------- | ------------------------------------------------------- | ---------------------------------------- |
| Attack           | Exploits the server's trust in the user's browser       | Exploits the user's trust in the website |
| Injected content | No code injection — uses existing authenticated session | Injects and executes malicious scripts   |
| Mitigations      | CSRF tokens, SameSite cookies, checking Origin/Referer  | Input sanitization, output encoding, CSP |

**Key mitigations:**

- **CSRF**: Use `SameSite=Lax/Strict` cookies, server-generated CSRF tokens (synchronizer token pattern), verify `Origin` header.
- **XSS**: Escape/encode all user-controlled output, use `Content-Security-Policy` to block inline scripts, use `textContent` instead of `innerHTML`, use frameworks that auto-escape (React, Angular, Vue).

**Where it's applicable:**  
Every web application — these are OWASP Top 10 vulnerabilities.

---

## 51. Content Security Policy (CSP)

**What it is:**  
CSP is an HTTP response header that tells the browser which sources of content (scripts, styles, images, etc.) are allowed to load and execute on your page. It's the strongest defense against XSS.

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' https://cdn.example.com;
  style-src 'self' 'unsafe-inline';
  img-src *;
  connect-src 'self' https://api.example.com;
```

**Interview-level insight:**

- `script-src 'self'` blocks ALL inline scripts and `eval()` — this alone prevents most XSS attacks.
- To allow specific inline scripts, use **nonce-based CSP**: `script-src 'nonce-abc123'` and `<script nonce="abc123">`.
- `'unsafe-inline'` and `'unsafe-eval'` defeat the purpose of CSP — avoid them.
- `report-uri` or `report-to` directives send violation reports to a collector endpoint for monitoring.
- `Content-Security-Policy-Report-Only` header tests a policy without enforcing it — blocks nothing, just reports.
- Modern approach: use **strict CSP** with nonces rather than allowlisting domains.

**Where it's applicable:**  
All web applications. Required for compliance (PCI DSS, HIPAA). Prevents XSS, clickjacking, data injection.

---

## 52. Trusted Types

**What it is:**  
Trusted Types is a browser API that prevents DOM-based XSS by locking down dangerous DOM sinks (`innerHTML`, `document.write`, `eval`, etc.) so they only accept **typed objects** instead of raw strings.

```javascript
// Define a policy
const policy = trustedTypes.createPolicy("myApp", {
  createHTML: (input) => DOMPurify.sanitize(input),
});

// Usage
element.innerHTML = policy.createHTML(userInput); // ✅ Allowed
element.innerHTML = userInput; // ❌ Blocked by browser
```

**Interview-level insight:**

- Enabled via CSP: `Content-Security-Policy: trusted-types myApp; require-trusted-types-for 'script'`.
- Once enabled, assigning a raw string to `innerHTML`, `outerHTML`, `document.write()`, or `eval()` throws a `TypeError`.
- All sanitization is centralized in policy objects — you audit policies instead of auditing every DOM sink.
- Google uses Trusted Types extensively across their properties.
- Libraries: `@anthropic/trusted-types`, DOMPurify integrates natively.

**Where it's applicable:**  
Applications handling user-generated content, security-critical applications, large codebases where auditing every `innerHTML` is impractical.

---

## 53. DOM Clobbering

**What it is:**  
DOM clobbering is an attack technique where HTML elements with specific `id` or `name` attributes overwrite JavaScript global variables or properties, causing unexpected behavior.

```html
<!-- Attacker injects via user content: -->
<img id="createElement" />
<script>
  // document.createElement is now the <img> element, not the function!
  document.createElement("div"); // TypeError: not a function
</script>
```

**Interview-level insight:**

- Named HTML elements (with `id` or `name`) are accessible as properties of `document` and `window` — this is part of the HTML spec.
- An attacker who can inject HTML (but not scripts) can still cause damage by clobbering globals.
- `<form id="x"><input name="action">` clobbers `form.action`, potentially redirecting form submissions.
- Mitigation: use `document.getElementById()` instead of relying on global names, freeze critical objects, use CSP, sanitize HTML.

**Where it's applicable:**  
Security audits, sanitizer library design, applications allowing user-generated HTML (CMS, forums, rich text editors).

---

## 54. Prototype Pollution

**What it is:**  
Prototype pollution is a vulnerability where an attacker modifies `Object.prototype` (or other built-in prototypes), causing malicious properties to appear on ALL objects in the application.

```javascript
// Vulnerable merge function
function merge(target, source) {
  for (let key in source) {
    target[key] = source[key]; // No prototype check!
  }
}

// Attacker payload:
merge({}, JSON.parse('{"__proto__": {"isAdmin": true}}'));

// Now EVERY object has isAdmin = true
const user = {};
console.log(user.isAdmin); // true!
```

**Interview-level insight:**

- Commonly exploited via `__proto__`, `constructor.prototype`, or `prototype` properties in user-supplied JSON.
- Libraries like Lodash `_.merge`, `_.set`, and `jQuery.extend` have had prototype pollution CVEs.
- Mitigation: validate keys (reject `__proto__`, `constructor`, `prototype`), use `Object.create(null)` for lookup maps, use `Map` instead of plain objects, freeze `Object.prototype`.
- `Object.freeze(Object.prototype)` prevents pollution but may break libraries that extend prototypes.
- In Node.js, prototype pollution can lead to **RCE** (Remote Code Execution) in some template engines.

**Where it's applicable:**  
Security audits, library development, any code that deep-merges or recursively processes user-supplied objects.

# Web Vitals, Advanced Patterns & Accessibility

---

## 76. PerformanceObserver API

**What it is:**  
`PerformanceObserver` is a browser API that provides an efficient, callback-based way to observe performance entries (timing data) as they are recorded by the browser, without polling.

```javascript
const observer = new PerformanceObserver((list) => {
  list.getEntries().forEach((entry) => {
    console.log(`${entry.name}: ${entry.duration}ms`);
  });
});
observer.observe({ type: "longtask", buffered: true });
observer.observe({ type: "largest-contentful-paint", buffered: true });
```

**Observable entry types:**  
`navigation`, `resource`, `paint`, `largest-contentful-paint`, `first-input`, `layout-shift`, `longtask`, `mark`, `measure`, `element`

**Interview-level insight:**

- `buffered: true` retrieves entries that occurred **before** the observer was created — essential for metrics that fire early (FCP, LCP).
- This is how libraries like **web-vitals** (Google) collect Core Web Vitals.
- You can create custom performance marks and measures: `performance.mark('start')` → `performance.measure('operation', 'start')`.
- Entries are automatically garbage collected — `PerformanceObserver` is the only reliable way to capture them all.
- Use with analytics to report real-user metrics (RUM — Real User Monitoring).

**Where it's applicable:**  
Performance monitoring, RUM (Real User Monitoring), Core Web Vitals tracking, custom performance metrics, analytics.

---

## 77. Long Tasks API

**What it is:**  
The Long Tasks API identifies JavaScript tasks that monopolize the main thread for **50ms or more**, which is the threshold at which users perceive jank or unresponsiveness.

```javascript
const observer = new PerformanceObserver((list) => {
  list.getEntries().forEach((entry) => {
    console.warn(`Long task detected: ${entry.duration}ms`, entry);
  });
});
observer.observe({ type: "longtask" });
```

**Interview-level insight:**

- A "task" is a single unit of work on the main thread — it includes script execution, layout, paint, and GC.
- The **50ms threshold** comes from RAIL guidelines: Response in <100ms requires individual tasks to be <50ms (leaving 50ms for browser rendering).
- Long tasks directly impact **FID** (First Input Delay) and **INP** (Interaction to Next Paint) — if a long task is running when the user clicks, the interaction is delayed.
- Solutions: break long tasks with `setTimeout(fn, 0)`, `scheduler.postTask()`, `requestIdleCallback`, or React's concurrent rendering.
- Chrome DevTools flags long tasks with red corners in the Performance timeline.

**Where it's applicable:**  
Performance debugging, identifying jank sources, monitoring production performance, optimizing INP.

---

## 78. First Input Delay (FID)

**What it is:**  
FID measures the time from when a user **first interacts** (click, tap, key press) with the page to when the browser is able to **begin processing** the event handler. It quantifies input responsiveness.

**Thresholds:**  
| Rating | FID |
|--------|-----|
| Good | ≤ 100ms |
| Needs Improvement | 100-300ms |
| Poor | > 300ms |

**Interview-level insight:**

- FID only measures the **delay**, not the event handler execution time or the time until the next paint.
- FID only captures the **first** interaction — subsequent slow interactions aren't measured by FID.
- **INP (Interaction to Next Paint) has replaced FID** as a Core Web Vital (March 2024) because INP measures ALL interactions throughout the page lifecycle.
- FID is primarily affected by **main thread blocking** — long JavaScript execution during page load prevents the browser from processing input.
- TBT (Total Blocking Time) in Lighthouse is a lab proxy for FID.

**Where it's applicable:**  
Core Web Vitals (deprecated in favor of INP), SEO ranking signal, page load performance optimization.

---

## 79. Interaction to Next Paint (INP)

**What it is:**  
INP measures the latency of **all user interactions** (clicks, taps, key presses) throughout the entire page lifecycle and reports the worst (or near-worst) interaction. It replaced FID as a Core Web Vital in March 2024.

**What INP measures (per interaction):**

1. **Input delay** — time the main thread is busy before handling the event
2. **Processing time** — time spent executing event handlers
3. **Presentation delay** — time from handler completion to the next paint

**Thresholds:**  
| Rating | INP |
|--------|-----|
| Good | ≤ 200ms |
| Needs Improvement | 200-500ms |
| Poor | > 500ms |

**Interview-level insight:**

- INP is more representative than FID because it covers **all interactions**, not just the first one.
- The reported value is typically the **98th percentile** interaction (to avoid outlier noise).
- Common causes of poor INP: expensive re-renders, synchronous layout calculations in event handlers, heavy JavaScript in click handlers.
- Improvements: debounce/throttle handlers, use `requestAnimationFrame` for visual updates, move computation to Web Workers, use `startTransition` in React.

**Where it's applicable:**  
Core Web Vitals (current), SEO ranking, interactive web application optimization, user experience monitoring.

---

## 80. Cumulative Layout Shift (CLS)

**What it is:**  
CLS measures the sum of all **unexpected layout shifts** that occur during the entire lifespan of a page. A layout shift happens when a visible element changes its position without user interaction.

**Thresholds:**  
| Rating | CLS |
|--------|-----|
| Good | ≤ 0.1 |
| Needs Improvement | 0.1-0.25 |
| Poor | > 0.25 |

**Common causes:**

- Images/videos without explicit `width`/`height` or `aspect-ratio`
- Ads or embeds without reserved space
- Dynamically injected content above existing content
- Web fonts causing FOUT (Flash of Unstyled Text) with different metrics
- Late-loading CSS pushing content around

**Interview-level insight:**

- Layout shifts caused by **user interaction** (within 500ms of an input) are excluded from CLS.
- The `layout-shift` entry in PerformanceObserver has a `hadRecentInput` boolean to distinguish user-initiated vs unexpected shifts.
- CLS uses **session windows**: shifts within 1 second of each other (max 5 seconds total) are grouped. The largest session window's sum is the CLS value.
- Fix: always set dimensions on images/video (`<img width="800" height="600">`), use `aspect-ratio` CSS, reserve space for ads with `min-height`.

**Where it's applicable:**  
Core Web Vitals, SEO ranking, content-heavy pages, pages with ads, any page with dynamic content loading.

---

## 81. Largest Contentful Paint (LCP)

**What it is:**  
LCP measures when the **largest visible content element** (image, video, text block) in the viewport finishes rendering. It's a proxy for "when did the page look loaded to the user."

**Thresholds:**  
| Rating | LCP |
|--------|-----|
| Good | ≤ 2.5s |
| Needs Improvement | 2.5-4.0s |
| Poor | > 4.0s |

**LCP candidates:**

- `<img>` elements
- `<video>` poster images
- Elements with `background-image` (CSS)
- Block-level text elements (`<h1>`, `<p>`, etc.)

**Optimization strategies:**

1. **Eliminate render-blocking resources** — defer/async scripts, critical CSS inlining
2. **Optimize the LCP resource** — compress images, use modern formats (WebP/AVIF), set `fetchpriority="high"`
3. **Reduce TTFB** — use a CDN, optimize server response time
4. **Preload the LCP image** — `<link rel="preload" as="image" href="hero.jpg">`
5. **Avoid LCP invalidation** — late-loading content can change which element is "largest"

**Interview-level insight:**

- The LCP element can **change** as the page loads — each larger element that renders becomes the new LCP candidate. The final candidate when the user first interacts (or 10 seconds pass) is the reported LCP.
- `fetchpriority="high"` on the LCP image is one of the highest-impact single optimizations.
- Server-rendering the page significantly improves LCP vs. client-rendered SPAs because content is visible before JS loads.

**Where it's applicable:**  
Core Web Vitals, SEO ranking, landing page optimization, e-commerce product pages, any content-first page.

---

## 82. Speculative Prerendering

**What it is:**  
Speculative prerendering fully renders a page **in the background** before the user navigates to it, so when they click the link, the page appears **instantly**.

```html
<!-- Speculation Rules API -->
<script type="speculationrules">
  {
    "prerender": [{ "urls": ["/about", "/pricing"] }],
    "prefetch": [{ "where": { "href_matches": "/blog/*" } }]
  }
</script>
```

**Interview-level insight:**

- The **Speculation Rules API** (Chrome 109+) replaces the old `<link rel="prerender">` which was limited and rarely used.
- Prerendering loads the page, executes JS, and renders the full DOM in a hidden tab — navigation is essentially instant.
- **Eagerness levels**: `immediate`, `moderate` (on hover), `conservative` (on mousedown/touchstart).
- Constraints: prerendered pages can't trigger alerts, access certain APIs, or play media until activated.
- Can be wasteful if the user doesn't navigate to the prerendered page — use analytics to identify likely navigation targets.

**Where it's applicable:**  
E-commerce (product pages from listings), search results, multi-step forms (prerender next step), content sites.

---

## 83. Priority Inversion in Async Code

**What it is:**  
Priority inversion occurs when a low-priority task holds a resource (or blocks the event loop) that a high-priority task needs, causing the high-priority task to wait for the low-priority one.

**Frontend example:**

```javascript
// Low-priority: background analytics processing (microtask chain)
Promise.resolve().then(processAnalyticsBatch); // Runs as microtask

// High-priority: user click handler
button.addEventListener("click", () => {
  // Can't execute until ALL microtasks (analytics) complete!
  updateUI();
});
```

**Interview-level insight:**

- In JavaScript, microtasks always preempt macrotasks — a flood of microtasks from a low-priority operation starves high-priority macrotask handlers.
- `scheduler.postTask()` (Scheduler API) provides explicit priority levels to avoid this: `scheduler.postTask(fn, { priority: 'user-blocking' })`.
- React's scheduler handles this internally — user interactions get "sync" or "user-blocking" priority, deferring low-priority work.
- Solution: move low-priority work to `setTimeout(fn, 0)` (macrotask) or `requestIdleCallback` to yield to high-priority tasks.

**Where it's applicable:**  
Performance optimization, scheduler design, understanding why user interactions feel sluggish despite low CPU usage.

---

## 84. Deterministic Rendering

**What it is:**  
Deterministic rendering means that given the same input (state + props), a component always produces the **exact same output**. This is a core principle of functional UI programming.

**Requirements:**

- Components are **pure functions** of their props/state. No side effects during render.
- No reliance on timing (`Date.now()`), randomness (`Math.random()`), or external mutable state during render.
- `StrictMode` in React double-renders to detect non-deterministic components.

**Interview-level insight:**

- Deterministic rendering enables: memoization, server-side rendering (server and client produce identical output), time-travel debugging, and snapshot testing.
- Non-deterministic renders cause **hydration mismatches** in SSR — e.g., rendering `new Date()` on the server produces a different result on the client.
- Solution for time-dependent rendering: pass the current time as a prop or use `useEffect` (runs only on the client).
- React Compiler (Forget) assumes components are pure — non-deterministic components may behave unexpectedly.

**Where it's applicable:**  
SSR, testing (snapshot tests), concurrent rendering (renders may be discarded and replayed), debugging.

---

## 85. Idempotent UI Actions

**What it is:**  
An idempotent UI action produces the **same result** regardless of how many times it's performed. Clicking a "save" button once or ten times should result in only one save operation.

**Techniques:**

1. **Disable button after click** — prevent double submissions
2. **Request deduplication** — track in-flight requests, skip duplicates
3. **Idempotency keys** — send a unique key with each request; server ignores duplicates
4. **Optimistic locking** — version numbers prevent duplicate writes
5. **UI state management** — button shows loading state, preventing re-clicks

**Interview-level insight:**

- **Server-side idempotency keys** are the robust solution — even if the client sends a request twice (network retry), the server processes it once.
- Stripe uses idempotency keys for payment API calls — essential for financial transactions.
- React 18's automatic batching helps prevent some double-update bugs, but network idempotency requires explicit implementation.
- Forms should use `<form onSubmit>` with submit prevention rather than `<button onClick>` for proper form semantics and keyboard support.

**Where it's applicable:**  
Payment forms, data submission, any mutation operation, e-commerce checkout, API design.

---

## 86. Accessibility Tree

**What it is:**  
The accessibility tree is a parallel structure to the DOM tree that the browser constructs for assistive technologies (screen readers, switch devices). It contains only **semantically meaningful** information — roles, names, states, and relationships.

**DOM → Accessibility tree mapping:**

```html
<button aria-label="Close dialog">×</button>
```

Accessibility tree node: `Role: button, Name: "Close dialog", Focusable: true`

```html
<div onclick="...">Click me</div>
```

Accessibility tree node: `Role: generic, Name: none` ❌ (not interactive)

**Interview-level insight:**

- Chrome DevTools has a dedicated **Accessibility tab** showing the accessibility tree for any element.
- **Semantic HTML** automatically creates correct accessibility tree nodes — `<button>`, `<nav>`, `<main>`, `<article>` all have implicit ARIA roles.
- `<div>` and `<span>` have the **generic** role — they convey no semantic meaning to assistive technologies.
- The accessibility tree determines what screen readers announce, what's focusable, and how keyboard navigation works.
- `aria-hidden="true"` removes an element from the accessibility tree entirely.
- `role="presentation"` or `role="none"` strips semantic meaning from an element.

**Where it's applicable:**  
WCAG compliance, building accessible components, screen reader testing, automated accessibility testing (axe-core, Lighthouse).

---

## 87. ARIA Live Regions Internals

**What it is:**  
ARIA live regions are areas of the page that **announce content changes** to screen readers without requiring the user to navigate to that area. They're essential for dynamic content updates.

```html
<div aria-live="polite" aria-atomic="true">
  3 items in your cart
  <!-- Screen reader announces when this text changes -->
</div>
```

**Attributes:**  
| Attribute | Values | Purpose |
|-----------|--------|---------|
| `aria-live` | `off`, `polite`, `assertive` | When to announce (never, after current speech, immediately) |
| `aria-atomic` | `true`, `false` | Announce entire region vs. only changed nodes |
| `aria-relevant` | `additions`, `removals`, `text`, `all` | What types of changes to announce |

**Interview-level insight:**

- `aria-live="polite"` waits for the screen reader to finish its current announcement. `assertive` interrupts — use sparingly (only for errors or critical alerts).
- Implicit live regions: `role="alert"` implicitly has `aria-live="assertive"`, `role="status"` has `aria-live="polite"`.
- The live region must **exist in the DOM before the content changes** — dynamically inserting a live region with content may not be announced.
- Screen reader support varies — test with NVDA (Windows), VoiceOver (Mac/iOS), and TalkBack (Android).
- Toast notifications, form validation errors, and chat messages are classic live region use cases.

**Where it's applicable:**  
Dynamic content updates, toast notifications, form validation errors, chat messages, live scores, loading status indicators.

---

## 88. Pointer Events

**What it is:**  
Pointer Events are a unified input API that handles mouse, touch, and stylus/pen input through a single set of events, replacing the need to handle `mouse*` and `touch*` events separately.

**Event types:**  
`pointerdown`, `pointermove`, `pointerup`, `pointerenter`, `pointerleave`, `pointerover`, `pointerout`, `pointercancel`, `gotpointercapture`, `lostpointercapture`

**Key properties:**

```javascript
element.addEventListener("pointermove", (e) => {
  e.pointerId; // Unique identifier for this pointer (multi-touch!)
  e.pointerType; // "mouse", "touch", or "pen"
  e.pressure; // 0-1 (pen/touch pressure)
  (e.tiltX, e.tiltY); // Pen tilt angle
  (e.width, e.height); // Contact size (touch)
  e.isPrimary; // Is this the primary pointer?
});
```

**Interview-level insight:**

- **Pointer capture** (`element.setPointerCapture(pointerId)`) directs all future events for that pointer to the element, even if the pointer moves outside it. Essential for drag-and-drop.
- `touch-action: none` in CSS prevents the browser from handling touch gestures (scrolling, zooming), letting JS handle them instead.
- Pointer events support **coalesced events** (`e.getCoalescedEvents()`) for high-fidelity drawing — the browser batches rapid movements, and coalesced events give you every intermediate point.
- **Multi-touch**: each finger gets a unique `pointerId` — track them independently for pinch-zoom, multi-finger gestures.
- React uses pointer events internally for its event system in modern browsers.

**Where it's applicable:**  
Drawing/canvas apps, drag-and-drop, gesture recognition, games, any touch-friendly interactive UI.

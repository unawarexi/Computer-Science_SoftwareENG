# Frontend Engineering — Industry-Standard Interview Guide

> As a Frontend Developer, these are the **88 advanced concepts** you need to master for senior-level interviews. Each topic includes a detailed explanation, how it works under the hood, interview-level insights, and where it's applicable in production.

---

## 📑 Table of Contents

### [01 — Rendering & Hydration](./01-rendering-and-hydration.md)

1. Hydration
2. Partial Hydration
3. Islands Architecture
4. Streaming SSR
5. Concurrent Rendering
6. Time Slicing

### [02 — React Internals & Data Patterns](./02-react-internals.md)

7. Reconciliation Algorithm
8. Fiber Architecture
9. Virtual DOM Diffing Complexity
10. Structural Sharing
11. Immutable Data Patterns
12. Referential Equality
13. Memoization Pitfalls
14. Stale Closure Problem

### [03 — JavaScript Runtime & Performance](./03-js-runtime-and-performance.md)

15. Event Loop (Macro vs Microtasks)
16. Task Starvation
17. Layout Thrashing
18. Critical Rendering Path
19. Render Blocking Resources
20. Tree Shaking Internals
21. Code Splitting Strategies
22. Dynamic Import Chunking
23. Module Federation

### [04 — Web Components & Web APIs](./04-web-components-and-apis.md)

24. Shadow DOM
25. Custom Elements Lifecycle
26. Web Components Interoperability
27. Web Workers vs Service Workers
28. SharedArrayBuffer
29. Transferable Objects
30. OffscreenCanvas
31. WebAssembly Integration

### [05 — Browser Rendering & Observers](./05-browser-rendering-and-observers.md)

32. Browser Compositing Layers
33. Paint vs Composite vs Layout
34. GPU Acceleration in CSS
35. CSS Containment
36. Subpixel Rendering
37. IntersectionObserver Internals
38. ResizeObserver Loop Limits
39. MutationObserver Cost

### [06 — Caching, Networking & Security](./06-caching-networking-security.md)

40. IndexedDB
41. Service Worker Lifecycle Traps
42. Cache Invalidation Strategies
43. Stale-While-Revalidate
44. ETag vs Cache-Control
45. HTTP/3 and QUIC
46. Priority Hints
47. Preload vs Prefetch vs Preconnect
48. CORS Preflight
49. SameSite Cookie Modes
50. CSRF vs XSS Mitigation
51. Content Security Policy (CSP)
52. Trusted Types
53. DOM Clobbering
54. Prototype Pollution

### [07 — Concurrent UI & Architecture Patterns](./07-concurrent-ui-and-architecture.md)

55. Race Conditions in UI State
56. Tearing in Concurrent UI
57. Scheduler Priorities
58. Render Waterfalls
59. Suspense Boundaries
60. Selective Hydration
61. Server Components
62. Edge Rendering
63. Micro-Frontend Orchestration
64. Finite State Modeling
65. Event Sourcing in Frontend
66. Optimistic UI Rollback Strategy
67. Offline Conflict Resolution
68. CRDT Basics for Collaboration

### [08 — Streaming, Communication & Memory](./08-streaming-communication-memory.md)

69. WebRTC
70. Backpressure in Streams API
71. AbortController
72. Streaming Fetch Response Handling
73. Browser Memory Leak Detection
74. Detached DOM Nodes
75. Garbage Collection Timing

### [09 — Web Vitals, Advanced Patterns & Accessibility](./09-vitals-patterns-accessibility.md)

76. PerformanceObserver API
77. Long Tasks API
78. First Input Delay (FID)
79. Interaction to Next Paint (INP)
80. Cumulative Layout Shift (CLS)
81. Largest Contentful Paint (LCP)
82. Speculative Prerendering
83. Priority Inversion in Async Code
84. Deterministic Rendering
85. Idempotent UI Actions
86. Accessibility Tree
87. ARIA Live Regions Internals
88. Pointer Events

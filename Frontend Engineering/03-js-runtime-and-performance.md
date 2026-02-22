# JavaScript Runtime & Performance

---

## 15. Event Loop (Macro vs Microtasks)

**What it is:**  
The event loop is the mechanism that allows JavaScript — a single-threaded language — to handle asynchronous operations. It continuously checks the call stack and task queues, executing tasks in a specific priority order.

**Execution order:**

1. Execute all synchronous code on the call stack.
2. Drain the **microtask queue** completely (Promises `.then`/`.catch`/`.finally`, `queueMicrotask`, `MutationObserver`).
3. Execute ONE **macrotask** (`setTimeout`, `setInterval`, `setImmediate`, I/O, UI rendering).
4. Drain the microtask queue again.
5. Browser may render (paint) if needed.
6. Repeat.

**Interview-level insight:**

- Microtasks have **higher priority** than macrotasks and are drained exhaustively before the next macrotask or render.
- An infinite microtask loop will **starve rendering and macrotasks**, freezing the UI.
- `requestAnimationFrame` runs **before paint** but after microtasks.
- `Promise.resolve().then(cb)` runs before `setTimeout(cb, 0)` — always.
- Node.js has an additional `process.nextTick` queue that runs before other microtasks.

**Where it's applicable:**  
Understanding async behavior, debugging timing issues, performance tuning, avoiding UI jank. Essential knowledge for every JS developer.

---

## 16. Task Starvation

**What it is:**  
Task starvation occurs when high-priority tasks (microtasks) continuously monopolize the event loop, preventing lower-priority tasks (macrotasks, rendering) from ever executing.

**Example:**

```javascript
function starve() {
  Promise.resolve().then(starve); // Infinite microtask — nothing else runs
}
starve(); // UI freezes, setTimeout callbacks never fire
```

**Interview-level insight:**

- A recursive or looping chain of microtasks will block **rendering, click handlers, and all macrotasks**.
- The browser's rendering pipeline gets no opportunity to paint, causing a frozen screen.
- Solution: break work into macrotasks (`setTimeout`) or use `requestIdleCallback` to yield.
- React's scheduler deliberately uses `MessageChannel` (macrotask) to **avoid microtask starvation** and let the browser paint between work units.

**Where it's applicable:**  
Debugging frozen UIs, designing background processing, understanding scheduler design in frameworks.

---

## 17. Layout Thrashing

**What it is:**  
Layout thrashing (forced synchronous layout) occurs when JavaScript **reads** a layout property (e.g., `offsetHeight`, `getBoundingClientRect()`) and then **writes** a style change in rapid alternation, forcing the browser to recalculate layout multiple times per frame instead of batching.

**Problematic pattern:**

```javascript
// BAD — forces layout recalculation on every iteration
elements.forEach((el) => {
  const height = el.offsetHeight; // READ → triggers layout
  el.style.height = height * 2 + "px"; // WRITE → invalidates layout
});
```

**Optimized pattern:**

```javascript
// GOOD — batch reads, then batch writes
const heights = elements.map((el) => el.offsetHeight); // All reads first
elements.forEach((el, i) => {
  el.style.height = heights[i] * 2 + "px"; // All writes second
});
```

**Interview-level insight:**

- Layout is normally **lazy** — the browser batches style changes and recalculates layout before the next paint. Thrashing forces **synchronous** recalculation mid-JavaScript.
- Properties that trigger forced layout: `offsetTop/Left/Width/Height`, `scrollTop/Left/Width/Height`, `clientTop/Left/Width/Height`, `getComputedStyle()`, `getBoundingClientRect()`.
- Libraries like **FastDOM** queue reads and writes to avoid thrashing.
- In Chrome DevTools, forced layout appears as a purple "Layout" event with a warning triangle.

**Where it's applicable:**  
Animation code, DOM measurement libraries, virtual scrolling implementations, drag-and-drop, responsive layout calculations.

---

## 18. Critical Rendering Path

**What it is:**  
The critical rendering path (CRP) is the sequence of steps the browser takes to convert HTML, CSS, and JavaScript into pixels on the screen. Optimizing the CRP directly improves **First Contentful Paint (FCP)**.

**The steps:**

1. **HTML parsing** → constructs the DOM tree.
2. **CSS parsing** → constructs the CSSOM tree.
3. **Render tree** = DOM + CSSOM (only visible nodes).
4. **Layout** — calculates the geometry (position, size) of each node.
5. **Paint** — fills in pixels (colors, text, images, shadows).
6. **Composite** — layers are composited together and sent to the GPU.

**Interview-level insight:**

- CSS is **render-blocking** — the browser won't paint until the CSSOM is fully built.
- JavaScript is **parser-blocking** — `<script>` tags (without `async`/`defer`) halt HTML parsing.
- Minimizing the CRP means: inline critical CSS, defer non-critical CSS/JS, reduce DOM depth, avoid complex selectors.
- **Critical CSS** = the minimum CSS needed to render above-the-fold content. Tools: `critical` npm package.

**Where it's applicable:**  
Page load performance optimization, Lighthouse/PageSpeed audits, SEO, any web application concerned with FCP and LCP.

---

## 19. Render Blocking Resources

**What it is:**  
Render-blocking resources are files (CSS, JS) that prevent the browser from rendering any content until they've been fully downloaded and processed.

**Types:**

- **CSS** — All stylesheets linked with `<link rel="stylesheet">` are render-blocking by default. The browser won't render until the CSSOM is complete.
- **JavaScript** — `<script>` tags without `async` or `defer` block HTML parsing AND rendering.
- **Fonts** — Web fonts can delay text rendering (FOIT — Flash of Invisible Text).

**Solutions:**  
| Technique | What it does |
|-----------|-------------|
| `async` on scripts | Download in parallel, execute immediately when ready (order not guaranteed) |
| `defer` on scripts | Download in parallel, execute after HTML parsing, in order |
| `media` attribute on CSS | Make CSS non-blocking for non-matching media (e.g., `media="print"`) |
| Inline critical CSS | Embed above-the-fold CSS directly in `<head>` |
| `font-display: swap` | Show fallback font immediately, swap when web font loads |

**Where it's applicable:**  
Web performance optimization, Lighthouse audits. Any site aiming for fast FCP/LCP.

---

## 20. Tree Shaking Internals

**What it is:**  
Tree shaking is a dead code elimination technique that removes unused exports from JavaScript bundles during the build process. It relies on the **static structure** of ES Modules (`import`/`export`) to determine which exports are actually referenced.

**How it works:**

1. Bundler (Webpack, Rollup, esbuild) builds a **dependency graph** of all imports.
2. Starting from entry points, it marks which exports are actually imported ("used").
3. Unused exports are removed from the final bundle.
4. A minifier (Terser) then removes any code that became unreachable.

**Interview-level insight:**

- **Only works with ES Modules** — `require()` (CommonJS) is dynamic and can't be statically analyzed.
- `sideEffects: false` in `package.json` tells the bundler it's safe to tree-shake the entire package.
- **Barrel files** (`index.js` re-exporting everything) can defeat tree shaking in Webpack 4 because the barrel import pulls in all modules. Webpack 5 handles this better with `sideEffects` optimization.
- Classes are often not tree-shakeable because property access is dynamic — this is why utility libraries like **Lodash** offer per-function imports (`lodash/debounce`).

**Where it's applicable:**  
Build optimization, reducing bundle size, library design (designing for tree-shakeability), choosing between CJS and ESM dependencies.

---

## 21. Code Splitting Strategies

**What it is:**  
Code splitting divides your JavaScript bundle into smaller chunks that are loaded on demand, rather than sending one monolithic bundle to the browser.

**Strategies:**

1. **Route-based splitting** — Each route/page is a separate chunk. Most common and effective.
2. **Component-based splitting** — Heavy components (modals, charts, editors) are lazy-loaded.
3. **Vendor splitting** — Third-party dependencies are in a separate chunk (cache-friendly).
4. **Entry point splitting** — Multiple entry points produce separate bundles.

**Implementation:**

```javascript
// React lazy loading (route-based)
const Dashboard = React.lazy(() => import("./Dashboard"));

// Next.js automatic route-based splitting
// pages/dashboard.js → automatically code-split

// Dynamic import for component splitting
const HeavyChart = React.lazy(() => import("./HeavyChart"));
```

**Interview-level insight:**

- The goal is to send the **minimum JS needed** for the current view.
- Over-splitting creates too many HTTP requests and negates the benefit. Finding the right granularity is key.
- **Webpack magic comments**: `import(/* webpackChunkName: "chart" */ './Chart')` name chunks for debugging.
- Preloading upcoming chunks (`<link rel="prefetch">`) prevents latency when the user navigates.

**Where it's applicable:**  
SPAs, large dashboards, any app exceeding ~100KB of JS. Frameworks: Next.js, Nuxt.js, Remix, Webpack, Vite.

---

## 22. Dynamic Import Chunking

**What it is:**  
Dynamic imports (`import()`) return a Promise for a module, enabling loading code at runtime rather than at initial parse time. The bundler automatically creates separate chunks for dynamically imported modules.

**How it works:**

```javascript
// Bundler creates a separate chunk for './analytics'
button.addEventListener("click", async () => {
  const { trackEvent } = await import("./analytics");
  trackEvent("button_clicked");
});
```

**Interview-level insight:**

- `import()` is a **language feature** (TC39 Stage 4), not framework-specific.
- Bundlers use dynamic imports as **split points** — each `import()` call generates a new chunk.
- Webpack generates chunk filenames with content hashes for long-term caching.
- You can prefetch chunks: `import(/* webpackPrefetch: true */ './HeavyModule')` adds `<link rel="prefetch">`.
- **Error handling is critical** — network failures should be caught: `import('./Module').catch(handleError)`.

**Where it's applicable:**  
Lazy loading routes, loading polyfills conditionally, A/B testing (load variant code only for test group), feature flagging.

---

## 23. Module Federation

**What it is:**  
Module Federation is a Webpack 5 feature that allows separate builds (applications) to share code at **runtime** — one application can dynamically load modules exposed by another application, without needing to rebuild.

**How it works:**

```javascript
// App A (host) - webpack.config.js
new ModuleFederationPlugin({
  remotes: { appB: "appB@https://appb.com/remoteEntry.js" },
});

// App B (remote) - webpack.config.js
new ModuleFederationPlugin({
  exposes: { "./Button": "./src/Button" },
  shared: ["react", "react-dom"],
});

// App A can now do:
const Button = React.lazy(() => import("appB/Button"));
```

**Interview-level insight:**

- Solves the **micro-frontend sharing problem** — teams can deploy independently and share components at runtime.
- **Shared dependencies** — React, React DOM, etc. are loaded once and shared, rather than duplicated across federated apps.
- Version mismatch handling: `singleton: true, requiredVersion: "^18"` ensures only one version loads.
- **Security concern**: You're loading and executing code from another origin at runtime — requires trust.
- Can be bidirectional — App A loads from App B and vice versa.

**Where it's applicable:**  
Micro-frontend architectures, multi-team organizations, plugin systems, gradually migrating legacy apps.

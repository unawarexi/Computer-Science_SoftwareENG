# Rendering & Hydration

---

## 1. Hydration

**What it is:**  
Hydration is the process by which a client-side JavaScript framework (React, Vue, Angular, etc.) "attaches" event listeners and component state to server-rendered HTML markup, making the static HTML interactive without re-rendering it from scratch.

**How it works:**

1. The server renders the full HTML and sends it to the browser.
2. The browser displays this HTML immediately (fast First Contentful Paint).
3. The JS bundle loads and the framework walks the existing DOM, attaches event handlers, and initializes state — this is "hydration."

**Interview-level insight:**

- Hydration does NOT re-create the DOM; it reuses the server-rendered DOM nodes.
- If there's a mismatch between server-rendered HTML and client-rendered output, you get a **hydration mismatch error** (React warns about this).
- The **cost** of hydration is proportional to the component tree size — every component must execute its render function even if the output matches exactly.
- This is why hydration is sometimes called **"the cost of interactivity."**

**Where it's applicable:**  
SSR frameworks — Next.js, Nuxt.js, Remix, SvelteKit, Angular Universal. Any scenario where you serve pre-rendered HTML and then need client-side interactivity.

---

## 2. Partial Hydration

**What it is:**  
Partial hydration is an optimization strategy where only specific parts of the page are hydrated on the client, rather than hydrating the entire component tree. Static or non-interactive sections remain as plain HTML.

**How it works:**

- The framework identifies components that need interactivity (e.g., buttons, forms, dropdowns).
- Only those components receive JavaScript and become interactive.
- The remaining HTML stays inert — no JS is loaded or executed for those sections.

**Interview-level insight:**

- Traditional hydration is "all-or-nothing"; partial hydration is **selective**.
- Dramatically reduces the **Total Blocking Time (TBT)** because less JS runs on page load.
- Implementation approaches: directive-based (`client:load`, `client:idle` in Astro), compiler-based analysis, or manual component boundaries.
- The challenge is determining the "island boundary" — where interactive and static content meet.

**Where it's applicable:**  
Content-heavy sites (blogs, documentation, e-commerce product pages) where most of the page is static text/images and only small regions need interactivity. Frameworks: **Astro**, **Qwik**, **Marko**.

---

## 3. Islands Architecture

**What it is:**  
Islands architecture is a rendering pattern where the page is composed of static HTML "ocean" with isolated interactive "islands" that hydrate independently. Each island is a self-contained, interactive widget embedded in otherwise static markup.

**How it works:**

1. Server renders the full page as static HTML.
2. Each interactive component is marked as an "island."
3. Islands hydrate independently, potentially with different strategies (on load, on idle, on visible, on interaction).
4. Islands are isolated — they don't share a single component tree or state.

**Interview-level insight:**

- Coined by Katie Sylor-Miller and popularized by Jason Miller (Preact creator).
- Unlike SPAs where the entire page is one React/Vue app, islands are **multiple independent mini-apps** on a single page.
- Each island can use a **different framework** if desired (React island + Vue island on the same page).
- The key benefit is **progressive enhancement** — the page works without JS, and islands enhance it.

**Where it's applicable:**  
Marketing sites, blogs, e-commerce storefronts, documentation sites. Frameworks: **Astro** (primary), **Fresh** (Deno), **Îles**.

---

## 4. Streaming SSR

**What it is:**  
Streaming SSR sends server-rendered HTML to the browser in chunks as they become ready, rather than waiting for the entire page to render before sending any HTML. The browser can start parsing and displaying content as each chunk arrives.

**How it works:**

1. Server starts rendering the component tree.
2. As soon as a section is ready (e.g., the header), it's flushed to the client as a chunk.
3. Components that depend on slow data sources (APIs, DB queries) show fallback content initially.
4. When the data resolves, a subsequent chunk replaces the fallback inline.

**Interview-level insight:**

- Uses HTTP **chunked transfer encoding** or the Web Streams API (`ReadableStream`).
- In React 18+, `renderToPipeableStream` (Node) and `renderToReadableStream` (edge) enable streaming.
- Combined with `<Suspense>`, you can stream shell content first and **inject data-dependent content later** using inline `<script>` tags that swap placeholders.
- **TTFB (Time to First Byte)** improves dramatically because the server doesn't block on the slowest data fetch.

**Where it's applicable:**  
Data-heavy pages with multiple independent data sources (dashboards, e-commerce PDPs, social feeds). Frameworks: **React 18+**, **Next.js App Router**, **Remix**, **SolidStart**.

---

## 5. Concurrent Rendering

**What it is:**  
Concurrent rendering is a rendering model (pioneered by React 18) where the framework can work on multiple versions of the UI simultaneously, interrupt rendering work, and prioritize urgent updates over less critical ones.

**How it works:**

- Rendering is **interruptible**: the framework can pause work on a low-priority update to handle a high-priority one (e.g., user input).
- Uses a **cooperative scheduling** model — the framework yields to the browser's main thread periodically to keep the UI responsive.
- Multiple "in-progress" trees can exist at once; the framework commits only the final, consistent state.

**Interview-level insight:**

- **Not the same as multi-threading** — JavaScript is still single-threaded. Concurrency here means interleaving and prioritizing work, not parallelism.
- Enables features like `useTransition`, `useDeferredValue`, and `<Suspense>` for data fetching.
- A "transition" update (e.g., filtering a list) won't block an "urgent" update (e.g., typing in an input).
- The old synchronous rendering model ("stack reconciler") couldn't pause — once it started rendering, it ran to completion.

**Where it's applicable:**  
Complex interactive UIs — search-as-you-type, data tables with filters, tab switching with heavy content, collaborative editors. **React 18+** is the primary framework implementing this.

---

## 6. Time Slicing

**What it is:**  
Time slicing is the technique of breaking a long-running rendering task into small chunks ("slices") and spreading them across multiple frames, yielding control back to the browser between slices so the main thread remains responsive.

**How it works:**

1. The framework has a unit of work to do (e.g., render 1000 list items).
2. Instead of doing all 1000 in one synchronous block, it processes a batch (e.g., 5ms worth).
3. It checks if there's remaining time in the current frame (using `requestIdleCallback` or a scheduler).
4. If the frame budget is exceeded, it yields and resumes in the next frame.

**Interview-level insight:**

- The goal is to keep frame time under **16ms** (for 60fps) or at least avoid "long tasks" (>50ms).
- React's Fiber architecture was specifically designed to enable time slicing by making the work tree a linked list that can be traversed incrementally.
- `scheduler` package in React implements a priority-based, time-sliced work loop using `MessageChannel` (not `requestIdleCallback` in practice, for consistency).
- Time slicing is an **implementation detail** of concurrent rendering — it's how concurrency is achieved on a single thread.

**Where it's applicable:**  
Rendering very large lists, complex data visualizations, CPU-intensive UI updates. Any scenario where a single synchronous render would cause visible jank. **React 18+** uses this internally.

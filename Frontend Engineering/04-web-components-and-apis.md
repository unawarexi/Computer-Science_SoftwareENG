# Web Components & Web APIs

---

## 24. Shadow DOM

**What it is:**  
Shadow DOM is a web standard that provides **encapsulation** for a component's internal DOM tree and styles. A shadow root creates a boundary — styles inside don't leak out, and styles outside don't leak in.

**How it works:**

```javascript
const host = document.querySelector("#my-widget");
const shadow = host.attachShadow({ mode: "open" });
shadow.innerHTML = `
  <style>p { color: red; }</style>  <!-- Only applies inside shadow -->
  <p>I'm encapsulated!</p>
`;
```

**Interview-level insight:**

- `mode: 'open'` — the shadow root is accessible via `element.shadowRoot`. `mode: 'closed'` — it's not (used by browser internal elements like `<video>`).
- CSS encapsulation is **bidirectional**: external stylesheets can't style shadow internals, and shadow styles can't affect the outer DOM.
- **CSS Custom Properties (variables)** DO penetrate the shadow boundary — this is the intended styling API for shadow DOM components.
- `::slotted()` pseudo-element styles slotted content; `::part()` exposes specific elements for external styling.
- Event retargeting: events from inside the shadow DOM appear to come from the host element when crossing the boundary.

**Where it's applicable:**  
Web Components, design system component libraries (e.g., Salesforce Lightning, Shoelace), browser extensions, any scenario requiring style isolation.

---

## 25. Custom Elements Lifecycle

**What it is:**  
Custom Elements are a web standard for defining new HTML tags with custom behavior. They have a defined set of lifecycle callbacks that fire at specific moments.

**Lifecycle callbacks:**  
| Callback | When it fires |
|----------|--------------|
| `constructor()` | Element created or upgraded. Set up state, shadow DOM. Don't access attributes or children. |
| `connectedCallback()` | Element inserted into the DOM. Set up event listeners, fetch data, start timers. |
| `disconnectedCallback()` | Element removed from the DOM. Clean up listeners, timers, subscriptions. |
| `attributeChangedCallback(name, oldVal, newVal)` | An observed attribute changes. React to attribute changes. |
| `adoptedCallback()` | Element moved to a new document (rare, via `document.adoptNode()`). |

**Interview-level insight:**

- You must declare `static get observedAttributes()` returning an array of attribute names for `attributeChangedCallback` to fire.
- `constructor` has strict rules: must call `super()` first, can't read attributes, can't add children (unless shadow DOM).
- `connectedCallback` may fire multiple times if the element is moved in the DOM.
- Custom elements must contain a hyphen in their name (`my-button`, not `mybutton`) to avoid conflicts with future HTML elements.
- Two variants: **Autonomous** (`extends HTMLElement`) and **Customized built-in** (`extends HTMLButtonElement`, `is="my-button"`) — Safari doesn't support the latter.

**Where it's applicable:**  
Building framework-agnostic component libraries, design systems, CMS widget systems, embedding interactive elements in static HTML.

---

## 26. Web Components Interoperability

**What it is:**  
Web Components interoperability refers to the ability to use Web Components (Custom Elements + Shadow DOM) seamlessly within and across JavaScript frameworks (React, Vue, Angular, Svelte).

**Key challenges:**

1. **React** treats custom element properties as attributes (strings) rather than passing objects/arrays as properties. React 19 fixes this.
2. **Event handling** — React's synthetic event system doesn't natively listen for custom events from custom elements.
3. **SSR** — Most frameworks can't server-render custom elements natively (Declarative Shadow DOM helps).
4. **Forms** — Custom elements don't participate in form submission natively unless using `ElementInternals` API.

**Interview-level insight:**

- Use `@lit-labs/react` or similar wrappers to generate React components from Web Components with proper property/event bindings.
- Vue and Angular handle Web Components natively with minimal configuration.
- **Declarative Shadow DOM** (`<template shadowrootmode="open">`) enables SSR for shadow DOM.
- The `ElementInternals` API lets custom elements participate in form validation, accessibility, and form data.

**Where it's applicable:**  
Multi-framework organizations, migrating between frameworks, building universal design systems, micro-frontend architectures.

---

## 27. Web Workers vs Service Workers

**What it is:**  
Both are scripts that run on a **background thread** separate from the main thread, but they serve fundamentally different purposes.

| Feature               | Web Worker                                      | Service Worker                                |
| --------------------- | ----------------------------------------------- | --------------------------------------------- |
| **Purpose**           | Offload CPU-heavy computations                  | Network proxy, caching, push notifications    |
| **Lifetime**          | Lives as long as the page (or until terminated) | Event-driven; lives independently of any page |
| **Scope**             | Tied to a single page/tab                       | Controls all pages under its scope            |
| **DOM access**        | No                                              | No                                            |
| **Network intercept** | No                                              | Yes (via `fetch` event)                       |
| **Communication**     | `postMessage` / `MessageChannel`                | `postMessage` / Clients API                   |
| **Registration**      | `new Worker('worker.js')`                       | `navigator.serviceWorker.register('sw.js')`   |

**Interview-level insight:**

- Service Workers require **HTTPS** (except localhost).
- Service Workers survive page closes and can wake up for push notifications or background sync.
- **Shared Workers** are a third type — shared across tabs/windows of the same origin.
- Service Workers have a complex lifecycle (install → waiting → activate) and can cause subtle caching bugs if not managed carefully.

**Where it's applicable:**  
Web Workers: image processing, data parsing, crypto, ML inference. Service Workers: PWAs, offline support, caching strategies, push notifications.

---

## 28. SharedArrayBuffer

**What it is:**  
`SharedArrayBuffer` (SAB) is a low-level API that creates a **shared memory region** accessible from multiple threads (main thread and Web Workers) without copying data.

**How it works:**

```javascript
// Main thread
const sab = new SharedArrayBuffer(1024); // 1KB shared memory
const view = new Int32Array(sab);
worker.postMessage(sab); // Worker gets same memory

// Worker
onmessage = (e) => {
  const view = new Int32Array(e.data);
  Atomics.add(view, 0, 1); // Thread-safe increment
};
```

**Interview-level insight:**

- Unlike `postMessage` which **copies** data (or transfers ownership), SAB truly **shares** the same bytes.
- Requires `Atomics` API for thread-safe operations (compare-and-swap, wait/notify).
- **Security**: Disabled after Spectre/Meltdown. Re-enabled only with **cross-origin isolation headers**: `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp`.
- Use cases include porting C/C++ multi-threaded code via WebAssembly (e.g., FFmpeg, game engines).

**Where it's applicable:**  
WebAssembly multi-threading, real-time audio/video processing, scientific computing, multiplayer game state synchronization.

---

## 29. Transferable Objects

**What it is:**  
Transferable objects can be **moved** (not copied) between threads via `postMessage`. After transfer, the original thread loses access to the data — ownership is transferred to the receiving thread in near-zero time.

**Transferable types:**  
`ArrayBuffer`, `MessagePort`, `ReadableStream`, `WritableStream`, `TransformStream`, `ImageBitmap`, `OffscreenCanvas`, `VideoFrame`

```javascript
const buffer = new ArrayBuffer(1024 * 1024); // 1MB
worker.postMessage(buffer, [buffer]); // Transfer — O(1)
console.log(buffer.byteLength); // 0! Buffer is neutered
```

**Interview-level insight:**

- Without transfer, `postMessage` uses **structured clone** which copies data — O(n) for large buffers.
- Transferring a 100MB ArrayBuffer takes **microseconds** instead of tens of milliseconds.
- After transfer, the source's buffer becomes **neutered** (length 0) — this prevents data races.
- Combined with `OffscreenCanvas`, you can transfer canvas rendering to a worker.

**Where it's applicable:**  
Image/video processing pipelines, large dataset handling between workers, streaming data between threads.

---

## 30. OffscreenCanvas

**What it is:**  
`OffscreenCanvas` allows canvas rendering to happen in a **Web Worker**, off the main thread. This prevents heavy canvas operations (WebGL, 2D drawing) from blocking the UI.

```javascript
// Main thread
const canvas = document.querySelector("canvas");
const offscreen = canvas.transferControlToOffscreen();
worker.postMessage(offscreen, [offscreen]);

// Worker
onmessage = (e) => {
  const canvas = e.data;
  const ctx = canvas.getContext("2d");
  // Render loop runs on worker thread — main thread stays responsive
};
```

**Interview-level insight:**

- Two ways to use: `new OffscreenCanvas(w, h)` (standalone, no DOM connection) or `canvas.transferControlToOffscreen()` (DOM-connected).
- WebGL contexts work on OffscreenCanvas — enables GPU-accelerated rendering on a worker.
- Use `canvas.convertToBlob()` or `transferToImageBitmap()` to get results back.
- Browser support: Chrome, Edge, Firefox; partial in Safari.

**Where it's applicable:**  
Data visualization dashboards, games, image editing tools, video processing, generative art.

---

## 31. WebAssembly Integration

**What it is:**  
WebAssembly (Wasm) is a binary instruction format that runs alongside JavaScript at near-native speed. It enables running code written in C, C++, Rust, Go, etc. in the browser.

**Integration pattern:**

```javascript
// Load and instantiate a Wasm module
const response = await fetch("module.wasm");
const { instance } = await WebAssembly.instantiateStreaming(response);
const result = instance.exports.fibonacci(40); // Call Wasm function from JS
```

**Interview-level insight:**

- Wasm is NOT a replacement for JS — it's a **complement** for performance-critical code.
- **Memory model**: Wasm uses a linear memory (`ArrayBuffer`) shared with JS. Strings must be manually copied between JS and Wasm memory.
- **Common tools**: Emscripten (C/C++ → Wasm), wasm-pack (Rust → Wasm), TinyGo (Go → Wasm).
- **WASI** (WebAssembly System Interface) enables Wasm to run outside the browser with system-level access.
- Use cases: image/video codecs (AVIF decoder), crypto, PDF rendering, SQLite in the browser, game engines.
- `instantiateStreaming` compiles while downloading — faster than downloading then compiling.

**Where it's applicable:**  
Figma (C++ rendering engine), Google Earth, AutoCAD, Photoshop Web, Squoosh (image compression), SQLite via `sql.js`.

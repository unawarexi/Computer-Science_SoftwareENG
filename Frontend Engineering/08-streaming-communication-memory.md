# Streaming, Communication & Memory

---

## 69. WebRTC

**What it is:**  
WebRTC (Web Real-Time Communication) is a browser API that enables **peer-to-peer** audio, video, and data communication directly between browsers without a central server relaying the media.

**Core components:**

1. **RTCPeerConnection** — manages the peer-to-peer connection (ICE, DTLS, SRTP)
2. **MediaStream** — captures audio/video from camera/microphone
3. **RTCDataChannel** — sends arbitrary data peer-to-peer (like WebSocket but P2P)

**Connection flow (simplified):**

1. **Signaling** (via your server — WebSocket/HTTP): peers exchange SDP offers/answers describing their capabilities.
2. **ICE candidate gathering**: each peer discovers its network paths (local, STUN-derived public IP, TURN relay).
3. **Connection established**: peers communicate directly (or via TURN relay if direct fails).

**Interview-level insight:**

- WebRTC still needs a **signaling server** to exchange connection metadata — it's NOT fully serverless.
- **STUN servers** help discover public IPs. **TURN servers** relay media when direct P2P fails (firewalls, symmetric NATs) — TURN is expensive (bandwidth costs).
- Latency is typically **sub-100ms** for P2P connections — much better than server-relayed approaches.
- `RTCDataChannel` enables P2P file sharing, game state sync, and collaborative editing without a server.
- SFU (Selective Forwarding Unit) architecture is used for group calls — a server forwards streams without processing them.

**Where it's applicable:**  
Video conferencing (Google Meet, Zoom Web), screen sharing, P2P file sharing, multiplayer games, IoT remote control.

---

## 70. Backpressure in Streams API

**What it is:**  
Backpressure is a mechanism where a slow consumer signals a fast producer to **slow down or pause**, preventing memory from filling up with unprocessed data. The Web Streams API has built-in backpressure support.

**How it works in Web Streams:**

```javascript
const readable = new ReadableStream({
  pull(controller) {
    // Only called when the consumer wants more data
    // If consumer is busy, pull() is NOT called → producer pauses
    controller.enqueue(data);
  },
});
```

- `ReadableStream` → `TransformStream` → `WritableStream` pipeline
- Each stream has an internal buffer with a **high water mark** (default: 1 chunk for bytes, count-based for objects).
- When the buffer fills, the stream applies backpressure upstream.

**Interview-level insight:**

- Without backpressure, a fast producer (e.g., server sending data at 1Gbps) overwhelms a slow consumer (e.g., browser processing at 10Mbps), causing memory exhaustion.
- `pipeTo()` and `pipeThrough()` handle backpressure automatically.
- The `desiredSize` property on `ReadableStreamDefaultController` indicates how much capacity remains — when ≤ 0, the producer should pause.
- Fetch API returns a `ReadableStream` body, enabling streaming processing of large responses.

**Where it's applicable:**  
Streaming file uploads/downloads, video processing pipelines, real-time data feeds, large file parsing, server-sent data processing.

---

## 71. AbortController

**What it is:**  
`AbortController` is a standard API for cancelling asynchronous operations — primarily `fetch` requests, but also event listeners, streams, and any custom async operation.

```javascript
const controller = new AbortController();

// Fetch with cancellation
fetch("/api/data", { signal: controller.signal }).catch((err) => {
  if (err.name === "AbortError") console.log("Request cancelled");
});

// Cancel after 5 seconds
setTimeout(() => controller.abort(), 5000);

// Or cancel on component unmount (React)
useEffect(() => {
  const controller = new AbortController();
  fetchData(controller.signal);
  return () => controller.abort(); // Cleanup
}, []);
```

**Interview-level insight:**

- The `signal` is an `AbortSignal` that can be passed to `fetch`, `addEventListener`, `ReadableStream`, and custom APIs.
- `AbortSignal.timeout(5000)` creates a signal that auto-aborts after 5 seconds (modern browsers).
- `AbortSignal.any([signal1, signal2])` combines multiple signals — aborts when any one does.
- In React, EVERY `useEffect` that fetches data should use `AbortController` for cleanup to prevent setting state on unmounted components and race conditions.
- You can listen for abort: `signal.addEventListener('abort', () => cleanup())`.

**Where it's applicable:**  
Data fetching cleanup in React, request timeouts, search cancellation, user-initiated cancellation, debounced requests.

---

## 72. Streaming Fetch Response Handling

**What it is:**  
The Fetch API returns a `Response` object whose `body` is a `ReadableStream`, enabling **incremental processing** of the response as chunks arrive rather than waiting for the complete download.

```javascript
const response = await fetch("/large-file.json");
const reader = response.body.getReader();
const decoder = new TextDecoder();

while (true) {
  const { done, value } = await reader.read();
  if (done) break;
  const text = decoder.decode(value, { stream: true });
  processChunk(text);
}
```

**Interview-level insight:**

- `response.json()` and `response.text()` buffer the entire response in memory — streaming avoids this for large payloads.
- Use cases: **NDJSON** (newline-delimited JSON) streams, **Server-Sent Events** (manual parsing), streaming AI chat responses (GPT-style token-by-token output).
- You can pipe the response through a `TransformStream` for parsing: `response.body.pipeThrough(new TextDecoderStream()).pipeThrough(ndjsonParser)`.
- **Progress tracking**: track `loaded` bytes vs `Content-Length` for upload/download progress.
- Combined with `AbortController`, you can cancel a large download mid-stream.

**Where it's applicable:**  
AI chat interfaces (streaming tokens), large file downloads with progress, real-time log streaming, NDJSON API consumption.

---

## 73. Browser Memory Leak Detection

**What it is:**  
Memory leaks in web applications occur when memory that's no longer needed is not released, causing the page's memory usage to grow continuously until performance degrades or the tab crashes.

**Common frontend memory leak sources:**

1. **Forgotten event listeners** — listeners not cleaned up on unmount
2. **Detached DOM nodes** — removed from DOM but still referenced in JS
3. **Closures** — holding references to large objects
4. **Timers** — `setInterval` not cleared
5. **Global variables** — accidental globals or growing global arrays
6. **Observers** — `IntersectionObserver`, `MutationObserver` not disconnected

**Detection tools:**

- **Chrome DevTools Memory tab**: Heap snapshots, allocation timeline, allocation profiling
- **Performance Monitor**: real-time JS heap size, DOM node count
- **`performance.measureUserAgentSpecificMemory()`** — programmatic memory measurement

**Interview-level insight:**

- Take **two heap snapshots** (before and after an action, like opening/closing a modal) and compare — objects that exist only in the second snapshot are potential leaks.
- Use the "Retainers" view to find WHAT is keeping a leaked object alive.
- SPAs are particularly susceptible because the page never fully reloads, so leaks accumulate.
- React's `useEffect` cleanup is the primary defense — every effect that creates a resource must return a cleanup function.

**Where it's applicable:**  
Long-lived SPAs, dashboards left open for hours/days, real-time apps, progressive web apps.

---

## 74. Detached DOM Nodes

**What it is:**  
Detached DOM nodes are elements that have been removed from the document but are still retained in memory because JavaScript code holds a reference to them.

```javascript
// Memory leak example
const elements = [];
function addItem() {
  const div = document.createElement("div");
  document.body.appendChild(div);
  elements.push(div); // JS reference retained
  document.body.removeChild(div); // Removed from DOM but NOT from memory
}
```

**Interview-level insight:**

- In Chrome DevTools: take a heap snapshot → filter by "Detached" → see all detached DOM nodes.
- Common causes: cached DOM references, event handlers that reference removed elements, closures in frameworks.
- In React, detached DOM leaks are less common because React manages the DOM, but they still occur with direct DOM manipulation (`ref.current`), third-party libraries, and manual event listeners.
- A single detached node can retain an entire **DOM subtree** — removing a parent but keeping a reference to a child retains the whole subtree.

**Where it's applicable:**  
SPA memory optimization, debugging growing memory usage, component unmount cleanup.

---

## 75. Garbage Collection Timing

**What it is:**  
JavaScript engines use automatic garbage collection (GC) to reclaim memory from objects that are no longer reachable. The timing and behavior of GC can cause performance issues if not understood.

**V8's GC strategy (Chrome, Node.js):**

- **Minor GC (Scavenge)** — collects short-lived objects in the "young generation." Fast (~1-2ms), frequent.
- **Major GC (Mark-Sweep-Compact)** — collects long-lived objects in the "old generation." Slower (~10-100ms), less frequent.
- **Incremental marking** — spreads marking work across multiple smaller pauses instead of one big pause.
- **Concurrent GC** — some GC work runs on helper threads while JS executes.

**Interview-level insight:**

- GC pauses can cause **jank** in animations — a 50ms GC pause during a 60fps animation drops multiple frames.
- **Object pooling** reduces GC pressure by reusing objects instead of creating/destroying them (useful for particles, game entities).
- `WeakRef` and `FinalizationRegistry` let you observe GC behavior programmatically (but don't rely on timing).
- `WeakMap` and `WeakSet` hold weak references — they don't prevent GC of their keys.
- Avoid creating many short-lived objects in hot paths (tight loops, animation callbacks).

**Where it's applicable:**  
Performance-critical animations, games, real-time audio processing, large-scale data processing in the browser.

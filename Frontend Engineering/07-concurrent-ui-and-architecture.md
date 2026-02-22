# Concurrent UI & Architecture Patterns

---

## 55. Race Conditions in UI State

**What it is:**  
A race condition in UI occurs when the outcome of UI state depends on the **timing or ordering** of asynchronous operations, leading to inconsistent or incorrect states.

**Classic example — search type-ahead:**

```javascript
// User types "ab" → fires fetch("ab")
// User types "abc" → fires fetch("abc")
// fetch("abc") returns first → UI shows results for "abc" ✓
// fetch("ab") returns second → UI shows results for "ab" ✗ (stale!)
```

**Mitigations:**

1. **AbortController** — cancel previous request when a new one starts.
2. **Request ID tracking** — only accept the response matching the latest request.
3. **Debouncing** — wait for user to stop typing before sending the request.
4. **State machines** — model valid state transitions explicitly to prevent impossible states.

**Interview-level insight:**

- React 18's `useTransition` helps by marking updates as interruptible, but doesn't eliminate API race conditions.
- `useEffect` cleanup functions should abort in-flight requests: `return () => controller.abort()`.
- TanStack Query and SWR handle this automatically by tracking query keys and discarding stale responses.
- Race conditions also occur with optimistic updates — if the server rejects the update, rolling back becomes complex when subsequent operations depend on the optimistic state.

**Where it's applicable:**  
Search, autocomplete, pagination, tab switching with data fetching, any UI with multiple concurrent async operations.

---

## 56. Tearing in Concurrent UI

**What it is:**  
Tearing occurs when different parts of the UI render with **different versions of the same state** at the same time, causing visual inconsistency. This is a specific problem in concurrent rendering where renders can be interrupted.

**Example:**

```
Component A reads external store → shows value 1
--- React yields to the browser ---
External store updates to value 2
--- React resumes rendering ---
Component B reads external store → shows value 2
// UI shows value 1 AND value 2 simultaneously = TEARING
```

**Interview-level insight:**

- Tearing occurs with **external stores** (Redux, Zustand, global variables) because they can change between renders in concurrent mode.
- React's own `useState`/`useReducer` are immune — React manages their snapshots per render.
- `useSyncExternalStore` (React 18) solves this by forcing a synchronous re-render when an external store changes mid-concurrent-render.
- Redux, Zustand, and Jotai all use `useSyncExternalStore` internally to prevent tearing.
- The visual effect: one part of the UI shows stale data while another shows fresh data.

**Where it's applicable:**  
Any React 18+ app using external state management libraries with concurrent features enabled.

---

## 57. Scheduler Priorities

**What it is:**  
The scheduler is the system that determines which rendering work gets done first. Tasks have different priority levels, and the scheduler ensures high-priority work (user interactions) preempts low-priority work (background updates).

**React's priority levels (internal):**  
| Priority | Example | Behavior |
|----------|---------|----------|
| Immediate (Sync) | Controlled input typing | Runs synchronously, can't be interrupted |
| User-blocking | Click handlers, hover | High priority, processed quickly |
| Normal | Data fetching results | Default priority |
| Low | Offscreen updates | Deferred, interruptible |
| Idle | Analytics, logging | Only runs when browser is idle |

**Interview-level insight:**

- `useTransition` marks an update as "transition" (low priority) — it won't block urgent updates like typing.
- `useDeferredValue` creates a deferred copy of a value — the original updates urgently, the copy updates at lower priority.
- The React scheduler uses `MessageChannel` for scheduling (not `requestIdleCallback`, which is unreliable) and implements time slicing with 5ms task budgets.
- The Scheduler API (`scheduler.postTask()`) is a browser-native version of this concept, but browser support is limited.

**Where it's applicable:**  
React concurrent features, complex interactive UIs, framework internals, understanding performance profiles.

---

## 58. Render Waterfalls

**What it is:**  
A render waterfall occurs when data fetching is serialized due to component hierarchy — a parent must finish rendering and fetching before its child can start fetching, creating a cascade of sequential network requests.

**Example:**

```
App renders → fetches user data
  └── Dashboard renders (waits for user) → fetches projects
        └── ProjectList renders (waits for projects) → fetches tasks
              └── TaskItem renders (waits for tasks)
// Each fetch waits for the previous one = waterfall
```

**Solutions:**

1. **Hoist data fetching** — fetch all data at the route/page level, pass down as props.
2. **Parallel fetching** — use `Promise.all` to fetch independent data simultaneously.
3. **Suspense + streaming** — let React stream shell content and fill in data as it arrives.
4. **Loader patterns** — Remix/React Router loaders fetch data before rendering.
5. **Prefetching** — start fetching before navigation (on hover/focus).

**Interview-level insight:**

- "Fetch-on-render" (fetch in `useEffect`) inherently creates waterfalls because children don't mount until parents render.
- "Render-as-you-fetch" (start fetch, then render) avoids this by decoupling fetch initiation from render.
- Next.js App Router allows parallel data fetching in nested layouts via parallel async server components.

**Where it's applicable:**  
Data-heavy SPAs, dashboard applications, nested route layouts, any app using component-level data fetching.

---

## 59. Suspense Boundaries

**What it is:**  
`<Suspense>` is a React component that lets you define a **fallback UI** (loading state) to show while waiting for its children to finish loading (code splitting via `React.lazy` or data fetching).

```jsx
<Suspense fallback={<Spinner />}>
  <Comments /> {/* This component fetches data */}
</Suspense>
```

**Interview-level insight:**

- **Granularity matters**: one giant `<Suspense>` around the whole app = big loading spinner. Many small boundaries = progressive loading experience.
- Nested Suspense boundaries create **loading state hierarchy** — outer boundaries catch anything not caught by inner ones.
- With streaming SSR, each `<Suspense>` boundary is a streaming point — the fallback HTML is sent first, then replaced by the resolved content via inline `<script>`.
- `<Suspense>` integrates with `useTransition` — you can avoid showing a fallback by keeping the old UI visible during a transition.
- Error handling: pair with `<ErrorBoundary>` for a complete loading/error/success pattern.

**Where it's applicable:**  
Code splitting, data fetching (React 18+), streaming SSR, progressive page loading, route transitions.

---

## 60. Selective Hydration

**What it is:**  
Selective hydration is a React 18 feature where the framework **prioritizes hydrating** the component the user is interacting with, rather than hydrating the entire page in DOM order.

**How it works:**

1. Server streams HTML with multiple `<Suspense>` boundaries.
2. Browser displays the HTML immediately.
3. React starts hydrating components.
4. If the user clicks on a not-yet-hydrated component, React **reprioritizes** and hydrates that component first.
5. The click event is replayed after hydration completes.

**Interview-level insight:**

- Without selective hydration, a click on an unhydrated button is simply lost.
- Each `<Suspense>` boundary is a unit of selective hydration — finer boundaries = finer-grained prioritization.
- Combined with streaming SSR, parts of the page can arrive and hydrate independently.
- This makes **TTI (Time to Interactive)** less meaningful as a single metric — different parts of the page become interactive at different times.

**Where it's applicable:**  
Large server-rendered pages where full hydration takes time (e-commerce, news sites, dashboards). React 18+.

---

## 61. Server Components

**What it is:**  
Server Components (RSC) are React components that execute **exclusively on the server** and send only their rendered output (a serialized component tree) to the client — no component code is sent to the browser.

**Key characteristics:**

- ✅ Can directly access databases, file systems, server-only APIs
- ✅ Send zero JavaScript to the client for the component itself
- ✅ Can `await` async operations directly
- ❌ Cannot use hooks (`useState`, `useEffect`)
- ❌ Cannot use browser APIs or event handlers
- ❌ Cannot hold interactive state

**Interview-level insight:**

- RSC is NOT SSR — SSR renders HTML on the server but still ships Component JS to the client for hydration. RSC ships **no component JS** at all.
- The "use client" directive marks the boundary — below it, components are client components (shipped as JS and hydrated).
- RSC + streaming = server renders components as data becomes available and streams results to the client.
- Server Components can import Client Components (but not vice versa). You can pass serializable props across the boundary.
- Bundle size benefit: libraries used only in Server Components (e.g., syntax highlighters, markdown parsers, date formatters) are excluded from the client bundle.

**Where it's applicable:**  
Next.js App Router (primary implementation), data-heavy pages, SEO content, admin panels, reducing client bundle size.

---

## 62. Edge Rendering

**What it is:**  
Edge rendering executes server-side rendering logic at **CDN edge nodes** geographically close to the user, rather than at a centralized origin server, resulting in lower latency.

**Interview-level insight:**

- Edge runtimes (Cloudflare Workers, Vercel Edge Functions, Deno Deploy) use V8 isolates, NOT full Node.js — they have **limited APIs** (no `fs`, limited `node:` modules).
- Cold start times are ~0ms for isolates vs ~100-1000ms for Lambda functions.
- Trade-off: edge functions can't do heavy computation or access databases directly (latency to origin DB). Solutions: edge databases (Turso, PlanetScale, Neon) or edge KV stores.
- Best for: personalization (geolocation, A/B tests, auth checks), transforming responses, adding headers.
- Not ideal for: heavy DB queries, long-running computations.

**Where it's applicable:**  
Next.js edge runtime, Remix edge deployments, personalized marketing pages, geo-specific content, A/B testing.

---

## 63. Micro-Frontend Orchestration

**What it is:**  
Micro-frontends decompose a large web application into smaller, independently deployable frontend applications owned by different teams. Orchestration is how these independently deployed pieces are composed into a cohesive user experience.

**Orchestration approaches:**

1. **Build-time composition** — NPM packages. Simple but requires coordinated releases.
2. **Server-side composition** — Edge/origin stitches HTML fragments (Podium, Tailor).
3. **Client-side composition** — JavaScript loads micro-frontends at runtime (Module Federation, Single-SPA, iframe).
4. **Hybrid** — Shell renders some MFEs server-side, others client-side.

**Interview-level insight:**

- **Shared dependencies** are the hardest problem — duplicating React across 5 MFEs is wasteful. Module Federation's shared scope solves this.
- **Routing** — either the shell owns all routing, or each MFE owns its routes (harder to coordinate).
- **Styling conflicts** — CSS modules, Shadow DOM, or CSS-in-JS scoping prevent style leakage.
- **Communication** — use custom events, a shared event bus, or a lightweight pub/sub for cross-MFE communication. Avoid shared state stores.
- Trade-offs: team autonomy and independent deployability at the cost of increased complexity, larger bundles, and harder consistent UX.

**Where it's applicable:**  
Large organizations with multiple frontend teams (IKEA, Spotify, Zalando), legacy migration (strangling a monolith), plugin-based platforms.

---

## 64. Finite State Modeling

**What it is:**  
Finite state modeling represents UI behavior as a finite state machine (FSM) or statechart where the system is always in exactly one of a finite number of states, and transitions between states are triggered by events.

```javascript
// XState example
const fetchMachine = createMachine({
  initial: "idle",
  states: {
    idle: { on: { FETCH: "loading" } },
    loading: {
      on: { SUCCESS: "success", FAILURE: "error" },
      invoke: { src: "fetchData", onDone: "success", onError: "error" },
    },
    success: { on: { FETCH: "loading" } },
    error: { on: { RETRY: "loading" } },
  },
});
```

**Interview-level insight:**

- FSMs make **impossible states impossible** — you can't be in "loading" and "error" simultaneously.
- Traditional boolean state management (`isLoading`, `isError`, `isSuccess`) creates `2³ = 8` possible combinations, most of which are invalid.
- Statecharts (Harel, 1987) extend FSMs with **hierarchy**, **parallelism**, **guards**, and **actions** — industrial strength.
- **XState** is the leading JavaScript statechart library with visual inspector tools.
- Useful for complex flows: multi-step forms, payment flows, authentication, drag-and-drop.

**Where it's applicable:**  
Complex UI workflows, form wizards, authentication flows, media players, game logic, protocol implementations.

---

## 65. Event Sourcing in Frontend

**What it is:**  
Event sourcing stores the **complete sequence of events** (actions/mutations) that led to the current state, rather than just the current state itself. The current state is derived by replaying events.

**Frontend application:**

```javascript
// Event log
const events = [
  { type: "ITEM_ADDED", payload: { id: 1, name: "Widget" } },
  { type: "ITEM_QUANTITY_CHANGED", payload: { id: 1, qty: 3 } },
  { type: "ITEM_REMOVED", payload: { id: 1 } },
];

// Current state = reduce(events)
const currentState = events.reduce(reducer, initialState);
```

**Interview-level insight:**

- Redux IS a form of event sourcing — every dispatched action is an event, and the state is derived by reducing the action stream.
- Enables **time-travel debugging** — replay events up to any point to see historical state.
- Combined with **undo/redo** — undo pops the last event, redo re-applies it.
- The event log can be synchronized across clients for **collaborative editing** (similar to CRDTs/OT).
- Trade-off: event log grows indefinitely. Solutions: snapshotting (periodically save the reduced state) and log compaction.

**Where it's applicable:**  
Undo/redo systems, collaborative editing, audit trails, time-travel debugging (Redux DevTools), state synchronization.

---

## 66. Optimistic UI Rollback Strategy

**What it is:**  
Optimistic UI immediately updates the interface as if a server operation succeeded, then reverts (rolls back) if the server response indicates failure.

**Strategy:**

```javascript
async function likePost(postId) {
  // 1. Save current state (for rollback)
  const previousState = queryClient.getQueryData(["post", postId]);

  // 2. Optimistically update UI
  queryClient.setQueryData(["post", postId], (old) => ({
    ...old,
    likes: old.likes + 1,
  }));

  try {
    // 3. Send to server
    await api.likePost(postId);
  } catch {
    // 4. Rollback on failure
    queryClient.setQueryData(["post", postId], previousState);
    toast.error("Failed to like post");
  }
}
```

**Interview-level insight:**

- The key challenge is **ordering** — if the user makes 3 optimistic updates before any server response, rolling back #2 must not affect #1 or #3.
- TanStack Query handles optimistic updates with built-in rollback via `onMutate` / `onError`.
- **Conflict resolution**: if two users optimistically update the same resource, the server response determines the truth.
- Consider **retry + exponential backoff** before rolling back — transient network errors shouldn't disrupt UX.

**Where it's applicable:**  
Social media (likes, comments), task managers (drag-and-drop reordering), chat apps (message sending), any low-risk user action.

---

## 67. Offline Conflict Resolution

**What it is:**  
When an application works offline and later syncs with the server, conflicts arise when the same data was modified both offline (locally) and by another client (remotely). Conflict resolution determines which version wins.

**Strategies:**

1. **Last Writer Wins (LWW)** — most recent timestamp wins. Simple but lossy.
2. **Client wins** — local changes always override. Risky for shared data.
3. **Server wins** — server changes always override. Safe but may lose user work.
4. **Manual merge** — present both versions to the user (like Git merge conflicts).
5. **Operational Transform (OT)** — transform operations based on concurrent edits (Google Docs).
6. **CRDTs** — data structures that automatically merge without conflicts (see next topic).

**Interview-level insight:**

- Timestamps for LWW require **synchronized clocks** — use **Lamport timestamps** or **Hybrid Logical Clocks** instead.
- **Versioning** — include a version number with each record. On sync, reject updates with stale versions (optimistic locking).
- **Change sets** — sync individual field-level changes rather than whole documents. This reduces conflicts.
- IndexedDB + background sync API is the typical offline storage + sync mechanism.

**Where it's applicable:**  
Offline-first apps, PWAs, note-taking apps, project management tools, any app that stores and syncs local data.

---

## 68. CRDT Basics for Collaboration

**What it is:**  
CRDTs (Conflict-free Replicated Data Types) are data structures that can be independently modified on multiple replicas and **automatically merged** without conflicts, producing a consistent result regardless of operation order.

**Types:**

- **G-Counter** — grow-only counter (each node increments its own slot)
- **PN-Counter** — increment and decrement
- **G-Set** — grow-only set (add only)
- **OR-Set** — observed-remove set (add and remove)
- **LWW-Register** — last-writer-wins register
- **RGA/YATA** — replicated growable array (for text editing)

**Interview-level insight:**

- CRDTs guarantee **strong eventual consistency** — all replicas converge to the same state without coordination.
- Two categories: **State-based** CRDTs (merge full states) and **Operation-based** CRDTs (broadcast operations).
- **Yjs** and **Automerge** are the leading JS CRDT libraries for building collaborative apps.
- CRDTs vs OT: CRDTs are simpler (no central server needed), OT is more space-efficient for text.
- Trade-off: CRDTs have higher memory overhead (they grow monotonically — deletions don't free space immediately. Garbage collection is needed.).

**Where it's applicable:**  
Real-time collaborative editing (Figma, Notion, Linear), peer-to-peer apps, offline-first apps, distributed systems.

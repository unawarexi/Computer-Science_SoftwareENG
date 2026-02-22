# React Internals & Data Patterns

---

## 7. Reconciliation Algorithm

**What it is:**  
Reconciliation is the algorithm a UI framework uses to determine what changed between the previous virtual DOM tree and the new one, so it can apply the minimum number of DOM mutations necessary.

**How it works:**

1. When state/props change, the framework produces a new virtual DOM tree.
2. It compares (diffs) the new tree against the old tree.
3. Two heuristics make O(n³) tree diff feasible as O(n):
   - **Different element types** produce entirely different trees (no deep comparison).
   - **Keys** on lists let the framework match children across re-renders.
4. The diff produces a list of DOM operations (insert, remove, update, move).

**Interview-level insight:**

- A naive tree diff is O(n³) — React's heuristic approach is O(n) because it only compares nodes **at the same level** (no cross-level moves).
- **Keys are critical** for list reconciliation. Without stable keys, React can't distinguish between reordering and replacement, leading to unnecessary DOM destruction/recreation.
- Using `index` as a key is an anti-pattern for dynamic lists because it breaks identity when items are inserted/removed.
- React, Vue, and Preact all use variations of this approach.

**Where it's applicable:**  
Any Virtual DOM–based framework. Understanding reconciliation is essential for optimizing re-render performance and correctly structuring component hierarchies.

---

## 8. Fiber Architecture

**What it is:**  
Fiber is React's internal reconciliation engine (introduced in React 16) that replaced the legacy "stack reconciler." It represents the component tree as a linked list of "fiber nodes," enabling **incremental rendering** — the ability to pause, abort, and resume rendering work.

**How it works:**

- Each component instance has a corresponding **fiber node** object.
- Fiber nodes are connected in a linked list using `child`, `sibling`, and `return` (parent) pointers.
- The reconciler traverses this linked list performing "units of work" — each unit processes one fiber node.
- After each unit, the scheduler can check if there's higher-priority work to do, and if so, interrupt the current traversal.
- Work happens in two phases:
  1. **Render phase** (interruptible): builds the work-in-progress tree, computes diffs.
  2. **Commit phase** (synchronous): applies DOM mutations, runs effects.

**Interview-level insight:**

- The old stack reconciler used the **call stack** itself for recursion — once it started, it couldn't be interrupted.
- Fiber replaces the call stack with a **virtual stack** (the fiber linked list), enabling cooperative scheduling.
- Each fiber has a `tag` (function component, class component, host component, etc.), `pendingProps`, `memoizedState`, and an `effectTag` (placement, update, deletion).
- There are **two trees**: the "current" tree (what's on screen) and the "work-in-progress" tree (being built). When WIP is complete, they swap — this is called **double buffering**.

**Where it's applicable:**  
React 16+ internals. Understanding Fiber is crucial for debugging performance issues, understanding why `useEffect` timing works the way it does, and reasoning about concurrent features.

---

## 9. Virtual DOM Diffing Complexity

**What it is:**  
This refers to the computational cost of comparing two virtual DOM trees to determine the minimal set of changes needed. The theoretical complexity depends on the diffing algorithm used.

**Key complexities:**  
| Algorithm | Complexity | Notes |
|-----------|-----------|-------|
| Optimal tree edit distance | O(n³) | Academically correct, impractical |
| React's heuristic diff | O(n) | Two assumptions: different types = different trees; keys identify children |
| List diff (keyed children) | O(n) with hashing | Key-based lookup for matching children |

**Interview-level insight:**

- React achieves O(n) by **sacrificing optimality** — it won't detect that a component moved from one branch to another; it'll destroy and recreate it.
- The trade-off is pragmatic: cross-level moves are rare in real UIs, and the O(n) scan is fast enough.
- Vue 3 uses a **longest increasing subsequence** algorithm for keyed list diffing, which minimizes DOM moves.
- Svelte and SolidJS **skip the VDOM diff entirely** — they compile components into direct DOM instructions, which is O(1) per reactive update.

**Where it's applicable:**  
Framework selection decisions, optimizing list rendering, understanding why `key` props matter.

---

## 10. Structural Sharing

**What it is:**  
Structural sharing is a technique used in immutable data structures where unchanged portions of a data structure are **shared by reference** between the old and new versions, rather than being deeply cloned.

**How it works:**

```
Old state:  { user: { name: "Alice", prefs: { theme: "dark" } }, posts: [...] }
Update:     Change user.name to "Bob"
New state:  { user: { name: "Bob",   prefs: ← same ref }, posts: ← same ref }
```

- Only the path from root to the changed leaf is recreated.
- Siblings and subtrees that didn't change share the same reference.

**Interview-level insight:**

- Libraries like **Immer** and **Immutable.js** use structural sharing internally.
- Redux relies on this: `===` checks on slices of state can quickly determine if a subtree changed, enabling efficient `useSelector` / `mapStateToProps`.
- React Query / TanStack Query uses structural sharing on API responses to preserve referential equality for unchanged data, preventing unnecessary re-renders.
- Without structural sharing, immutability would be impractically expensive for large state trees.

**Where it's applicable:**  
State management (Redux, Zustand, MobX State Tree), query libraries (TanStack Query), undo/redo implementations, time-travel debugging.

---

## 11. Immutable Data Patterns

**What it is:**  
Immutable data patterns involve treating data as read-only — instead of mutating an existing object/array, you create a new one with the desired changes. The original data is never altered.

**Common patterns:**

```javascript
// Spread operator (shallow copy)
const newObj = { ...obj, name: "Bob" };
const newArr = [...arr, newItem];

// Array methods that return new arrays
const filtered = arr.filter((x) => x.active);
const mapped = arr.map((x) => ({ ...x, count: x.count + 1 }));

// Immer (write mutable-looking code, get immutable output)
const next = produce(state, (draft) => {
  draft.user.name = "Bob";
});
```

**Interview-level insight:**

- Immutability enables **cheap equality checks** (`===`) — if references differ, data changed; if same, data didn't. This is the foundation of React's rendering optimizations.
- **Shallow copying is NOT deep immutability** — nested mutations can still occur. Use Immer or deep-freeze utilities for safety.
- React's `useState` and Redux both **require** immutable updates. Direct mutation won't trigger re-renders.
- The performance concern ("copying is expensive") is addressed by **structural sharing** (see above).

**Where it's applicable:**  
React state updates, Redux reducers, functional programming, undo/redo systems, any system where change detection via reference comparison is desired.

---

## 12. Referential Equality

**What it is:**  
Referential equality means two variables point to the **exact same object in memory** (`===` for objects). In contrast, structural equality means two variables have the same shape and values, even if they're different objects.

**Why it matters in frontend:**

```javascript
// This creates a NEW object every render
<Child style={{ color: "red" }} />; // New object each time → Child re-renders

// This preserves referential equality
const style = useMemo(() => ({ color: "red" }), []);
<Child style={style} />; // Same reference → Child can skip re-render
```

**Interview-level insight:**

- `React.memo`, `useEffect` dependency arrays, `useMemo`, and `useCallback` all rely on referential equality (`Object.is`) to determine if values changed.
- **Common pitfall**: Inline objects, arrays, and functions create new references every render, defeating memoization.
- `useSelector` in Redux uses `===` by default — returning a new object from the selector (e.g., `.map()`) causes unnecessary re-renders. Solutions: return primitives, use `shallowEqual`, or use `createSelector` (reselect).
- Understanding referential equality is the key to fixing "why does my component keep re-rendering?" bugs.

**Where it's applicable:**  
React performance optimization, Redux selectors, memoization strategies, effect dependency tuning.

---

## 13. Memoization Pitfalls

**What it is:**  
Memoization caches the result of expensive computations so they're not recalculated when the inputs haven't changed. In React, this surfaces as `React.memo`, `useMemo`, and `useCallback`. The "pitfalls" are the common ways developers misuse these tools.

**Common pitfalls:**

1. **Memoizing everything** — `useMemo`/`useCallback` have overhead (storing previous values, running comparisons). For cheap computations, the memoization cost exceeds the computation cost.
2. **Unstable dependencies** — If a dependency changes every render (e.g., an inline object), the memo is useless.
3. **Forgetting `React.memo` on the child** — `useCallback` on a handler is pointless if the child receiving it isn't wrapped in `React.memo`.
4. **Stale values** — Incorrect dependency arrays lead to memos returning outdated results.
5. **Memory cost** — Every memo stores a previous value in memory. Over-memoizing bloats memory usage.

**Interview-level insight:**

- The React team advises: **measure before memoizing**. Use React DevTools Profiler to identify actual performance bottlenecks.
- React Compiler (React Forget) aims to automate memoization, making manual `useMemo`/`useCallback` largely unnecessary.
- `useMemo` is **not a semantic guarantee** — React may discard cached values (e.g., offscreen components). Don't use it for side effects.

**Where it's applicable:**  
Performance optimization in React apps, especially with large lists, expensive computations, or frequently re-rendering parent components.

---

## 14. Stale Closure Problem

**What it is:**  
The stale closure problem occurs when a function "closes over" a variable from a previous render cycle, capturing an outdated snapshot of that variable instead of the current value.

**Classic example:**

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const id = setInterval(() => {
      console.log(count); // Always logs 0! Stale closure.
      setCount(count + 1); // Always sets to 1!
    }, 1000);
    return () => clearInterval(id);
  }, []); // Empty deps → closure captures count = 0 forever
}
```

**Fix:**

```javascript
setCount((prev) => prev + 1); // Functional update — no dependency on closure
// OR
useEffect(() => {
  /* ... */
}, [count]); // Re-create closure when count changes
```

**Interview-level insight:**

- This is NOT a React bug — it's fundamental **JavaScript closure behavior**. Each render creates a new scope; callbacks capture values from that scope.
- `useRef` can serve as an escape hatch: `ref.current` always points to the latest value because it's a mutable container.
- Event handlers in React also capture per-render values — this is intentional ("each render has its own props and state").
- The stale closure problem is the #1 source of bugs with `useEffect`, `setInterval`, `setTimeout`, and event listeners.

**Where it's applicable:**  
Any use of closures in React hooks — timers, WebSocket handlers, event listeners, debounced functions, animation callbacks.

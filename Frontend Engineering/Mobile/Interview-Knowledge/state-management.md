# Top 50 State Management Questions & Answers

A comprehensive guide covering Zustand, Context API, Redux, React Query, Bloc, GetX, and Riverpod.

## Core State Management Principles (1-10)

### 1. What's the purpose of state management in mobile apps?

To control how data flows between UI and logic layers, keeping UI reactive to data changes without unnecessary rebuilds.

### 2. What's the difference between local state and global state?

- **Local state**: widget/screen-specific (e.g., text input)
- **Global state**: shared across multiple widgets/screens (e.g., user session, theme, auth)

### 3. What's the difference between UI state and business logic state?

- **UI state**: drives visuals (loading, selected tab)
- **Business logic state**: handles data processing (auth status, API data)

### 4. Explain "single source of truth" in state management

All state mutations originate from one controlled data store, preventing desync or duplication across widgets.

### 5. What's reactive state?

Reactive state auto-updates the UI when data changes — achieved through listeners, not manual triggers.

### 6. What's the "immutable state" pattern?

Each state update creates a new state snapshot (not mutated in place). Helps in debugging, time travel, and predictability.

### 7. Why is over-rendering dangerous in state management?

It wastes CPU cycles, reduces FPS, and causes unnecessary widget rebuilds or component re-renders.

### 8. What are "selectors" or "computed states"?

Derived state based on base state (e.g., totalCartPrice from item list). Zustand/Redux/Bloc all support selectors to prevent recalculations.

### 9. What's a "store" in state management?

A centralized container that holds global state and exposes methods/actions for updates.

### 10. How do you debug complex state flows?

Redux DevTools, Flutter BlocObserver, Zustand middleware logs, or Riverpod ProviderObserver.

## React Native (11-30)

### Zustand

#### 11. Walk me through Zustand setup

Install:
```bash
npm install zustand
```

Create store:
```javascript
import { create } from 'zustand'
const useStore = create(set => ({
  count: 0,
  increment: () => set(state => ({ count: state.count + 1 }))
}))
```

Use in component:
```javascript
const { count, increment } = useStore()
```

#### 12. Why is Zustand preferred for performance?

It uses a global store with selector-based subscriptions — only re-renders components using changed slices.

#### 13. What are "slices" in Zustand?

Modularized store segments (e.g., authSlice, uiSlice) for better scaling and separation.

#### 14. How would you persist Zustand state?

Use zustand/middleware with persist:
```javascript
persist(set => ({ theme: 'dark' }), { name: 'theme-storage' })
```

#### 15. Why is Zustand better than Context API for large apps?

Context re-renders entire trees; Zustand re-renders only subscribed components.

### Context API

#### 16. Walk me through Context setup

Create context:
```javascript
const ThemeContext = createContext()
```

Provide:
```javascript
<ThemeContext.Provider value={theme}>...</ThemeContext.Provider>
```

Consume:
```javascript
const theme = useContext(ThemeContext)
```

#### 17. Why can Context cause performance issues?

Every context change re-renders all consumers, even if they don't depend on the changed value.

#### 18. How do you optimize Context updates?

Split contexts (e.g., ThemeContext, UserContext) and memoize values with `useMemo()`.

#### 19. Why is Context still useful despite its limits?

Perfect for low-frequency, global data (themes, localization).

#### 20. When to combine Context and Zustand?

Context for providers (dependency injection), Zustand for state logic.

### Redux

#### 21. Explain Redux flow

Action → Reducer → Store → UI Update (via subscription)

#### 22. How do you set up Redux in React Native?

Install:
```bash
npm install @reduxjs/toolkit react-redux
```

Create slice:
```javascript
const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: { increment: state => { state.value++ } }
})
```

Configure store:
```javascript
const store = configureStore({ reducer: counterSlice.reducer })
```

Provide store:
```javascript
<Provider store={store}><App/></Provider>
```

#### 23. Why Redux Toolkit over classic Redux?

Less boilerplate, built-in immutability, and middleware handling.

#### 24. How do you optimize Redux to prevent over-rendering?

Use `useSelector` with shallow comparison, memoized selectors (reselect).

#### 25. When would you not use Redux?

For small apps or screens without shared state — too much setup overhead.

### React Query

#### 26. Walk me through React Query setup

Install:
```bash
npm install @tanstack/react-query
```

Create client:
```javascript
const queryClient = new QueryClient()
```

Wrap app:
```javascript
<QueryClientProvider client={queryClient}><App/></QueryClientProvider>
```

Use hook:
```javascript
const { data, isLoading } = useQuery(['todos'], fetchTodos)
```

#### 27. Why use React Query?

Handles caching, deduplication, background refetch, and auto state syncing — replaces manual fetch + state handling.

#### 28. How does React Query differ from Redux?

Redux stores data manually; React Query manages server cache automatically.

#### 29. How do you persist query cache?

Use `persistQueryClient` from `@tanstack/react-query-persist-client`.

#### 30. Why is React Query ideal for offline-first apps?

It auto retries failed requests and syncs stale data when connectivity resumes.

## Flutter (31-45)

### Bloc

#### 31. Walk me through Bloc setup

Install:
```bash
flutter_bloc
```

Create state + event + bloc:
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}
```

Provide + consume via `BlocProvider` and `BlocBuilder`.

#### 32. Why Bloc over setState()?

Bloc separates UI and logic cleanly, supports streams, and scales for large apps.

#### 33. What's the difference between Bloc and Cubit?

Cubit = simplified Bloc (no events, direct function calls).

#### 34. How does Bloc prevent redundant rebuilds?

`BlocBuilder` rebuilds only when the emitted state differs from the previous one.

#### 35. Why use BlocObserver?

Global logging and state transition debugging.

### GetX

#### 36. How do you set up GetX?

Install:
```bash
get
```

Create controller:
```dart
class CounterController extends GetxController {
  var count = 0.obs;
  void increment() => count++;
}
```

Bind + use:
```dart
final controller = Get.put(CounterController());
Obx(() => Text("${controller.count}"));
```

#### 37. Why is GetX popular?

Minimal boilerplate, reactive .obs properties, integrated routing and DI.

#### 38. What's the drawback of GetX?

Tight coupling and difficulty testing large, layered systems.

#### 39. When would you avoid GetX?

For large enterprise apps needing clear architecture boundaries.

#### 40. Why does GetX outperform setState()?

Reactive observers rebuild only affected widgets.

### Riverpod

#### 41. Walk me through Riverpod setup

Install:
```bash
flutter_riverpod
```

Create provider:
```dart
final counterProvider = StateProvider((ref) => 0);
```

Use in widget:
```dart
ref.watch(counterProvider)
```

#### 42. Why is Riverpod better than Provider?

No BuildContext dependency, compile-time safety, supports auto disposal, and better performance.

#### 43. What's the difference between StateProvider, FutureProvider, and StreamProvider?

- **StateProvider**: simple state
- **FutureProvider**: async tasks
- **StreamProvider**: real-time streams

#### 44. What is a "ref" in Riverpod?

Dependency handle that provides access to other providers and lifecycle events.

#### 45. Why is Riverpod test-friendly?

Providers can be overridden in test environments for mocking.

## Cross-Framework Concepts & Best Practices (46-50)

### 46. What's the biggest performance trap in all state managers?

Uncontrolled rebuilds and side-effects in UI listeners instead of pure logic layers.

### 47. Which is best for real-time sync apps (e.g., chat)?

React Query or Riverpod StreamProvider — both handle reactive streams efficiently.

### 48. Which is best for complex enterprise logic?

Bloc or Redux — predictable event-driven flow and middleware support.

### 49. Which is best for fast MVPs and startups?

Zustand (React Native) or GetX (Flutter) — minimal setup, instant reactivity.

### 50. Which state manager is most future-proof?

Riverpod (Flutter) and Zustand + React Query combo (React Native) — scalable, minimal boilerplate, and high performance.
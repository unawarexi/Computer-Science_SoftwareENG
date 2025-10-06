# STATE MANAGEMENT - TOP 50 INTERVIEW QUESTIONS & ANSWERS

## 1. How would you explain state management across Flutter and React Native?

**Answer:**

State management is the way an app stores, updates, and propagates data across UI components.

Flutter: uses StatefulWidget, setState, and external managers like Bloc, Riverpod, GetX.

React Native: uses useState, useReducer, Context API, Redux, Zustand, React Query.

The goal is predictable state flow and UI reactivity with minimal rebuilds.

## 2. Walk me through the process of setting up Zustand in React Native.

**Answer:**

Steps:

1. `npm install zustand`

2. Create store:

```javascript
import { create } from 'zustand';
const useStore = create((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
}));
```

3. Use in component:

```javascript
const count = useStore((state) => state.count);
const increment = useStore((state) => state.increment);
```

Lingo: Store = Global State Container.

Why: Lightweight, no boilerplate, great for small to medium apps.

## 3. How does Zustand differ from Redux?

**Answer:**

- Zustand uses simpler syntax, direct mutable state, no reducers/actions.
- Redux uses strict immutability, reducers, and actions - better for large, structured state.
- Zustand performs faster for UI states; Redux is preferred for business logic-heavy apps.

## 4. Walk me through setting up Redux Toolkit in React Native.

**Steps:**

1. `npm install @reduxjs/toolkit react-redux`

2. Create store:

```javascript
import { configureStore } from '@reduxjs/toolkit';
import counterReducer from './counterSlice';
export const store = configureStore({ reducer: { counter: counterReducer }});
```

3. Wrap app:

```javascript
<Provider store={store}><App /></Provider>
```

4. Use hooks:

```javascript
const count = useSelector((state) => state.counter.value);
const dispatch = useDispatch();
dispatch(increment());
```

Why: Predictable global state flow; great debugging via Redux DevTools.

## 5. Explain the Redux flow.

**Answer:**

UI → Dispatch(Action) → Reducer → Store → UI Re-render.

Predictable unidirectional data flow ensures clean debugging and testability.

## 6. Walk me through using React Context API.

**Steps:**

1. Create context:

```javascript
const ThemeContext = createContext();
```

2. Provide value:

```javascript
<ThemeContext.Provider value={{ theme, toggleTheme }}>
  {children}
</ThemeContext.Provider>
```

3. Consume:

```javascript
const { theme } = useContext(ThemeContext);
```

Why: Simple for small app states, but causes re-renders with large trees.

## 7. Compare Context API vs Zustand.

**Answer:**

Context is static and causes re-renders across all consumers. Zustand uses selectors to re-render only the affected part of the state → better performance.

## 8. Walk me through React Query setup and how it differs from Redux.

**Steps:**

1. `npm install @tanstack/react-query`

2. Wrap app:

```javascript
const queryClient = new QueryClient();
<QueryClientProvider client={queryClient}><App /></QueryClientProvider>
```

3. Fetch data:

```javascript
const { data, isLoading } = useQuery(['todos'], fetchTodos);
```

**Difference:**

- React Query = Server State (auto-cache, refetch)
- Redux = Client State

## 9. What's the difference between server state and client state?

**Answer:**

- Server state: Data fetched remotely (React Query handles this).
- Client state: Locally controlled data (Redux/Zustand/Context handle this).

## 10. Walk me through Bloc pattern setup in Flutter.

**Steps:**

1. Add packages:

```yaml
flutter_bloc: ^8.1.0
```

2. Create Bloc:

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}
```

3. Provide Bloc:

```dart
BlocProvider(create: (_) => CounterBloc(), child: MyApp())
```

4. Consume:

```dart
BlocBuilder<CounterBloc, int>(builder: (_, count) => Text('$count'))
```

Why: Clean separation of logic and presentation.

## 11. Compare Bloc vs Riverpod in Flutter.

**Answer:**

- Bloc: Strict event-based structure, more boilerplate.
- Riverpod: Functional and reactive, less code, integrates easily with async providers.

## 12. Walk me through Riverpod setup in Flutter.

**Steps:**

1. Add:

```yaml
flutter_riverpod: ^2.0.0
```

2. Wrap app:

```dart
ProviderScope(child: MyApp())
```

3. Create provider:

```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

4. Use:

```dart
ref.watch(counterProvider);
ref.read(counterProvider.notifier).state++;
```

Why: No context dependency, easy testing, compile-time safety.

## 13. Walk me through GetX setup in Flutter.

**Steps:**

1. Add:

```yaml
get: ^4.6.5
```

2. Create controller:

```dart
class CounterController extends GetxController {
  var count = 0.obs;
  increment() => count++;
}
```

3. Use in UI:

```dart
final controller = Get.put(CounterController());
Obx(() => Text("${controller.count}"));
```

Why: Reactive, minimal boilerplate, global access without context.

## 14. Compare GetX vs Bloc.

**Answer:**

- GetX: Simpler, reactive syntax, less ceremony.
- Bloc: Better for large-scale predictable enterprise apps with event-driven patterns.

## 15. What is an Atom or Provider in Riverpod terms?

**Answer:**

A Provider exposes reactive state; similar to a mini-store that rebuilds UI when its value changes.

Different provider types:

- Provider → read-only
- StateProvider → mutable
- FutureProvider → async
- StreamProvider → stream-based

## 16. How does Flutter rebuild optimization tie into state management?

**Answer:**

Use granular providers or builders (e.g., BlocBuilder, ConsumerWidget) to rebuild only necessary widgets, reducing unnecessary re-renders.

## 17. How does Zustand handle async logic?

**Answer:**

Directly in the store:

```javascript
fetchUser: async () => {
  const res = await fetch('/api/user');
  set({ user: await res.json() });
}
```

No need for middlewares like thunk.

## 18. How to persist Zustand/Redux state across app restarts?

**Answer:**

- Zustand: persist middleware
- Redux: redux-persist
- Flutter: hydrated_bloc or shared_preferences

## 19. Explain Bloc-to-Bloc communication.

**Answer:**

Use BlocListener or inject one Bloc into another. For example, AuthenticationBloc notifies UserBloc upon login.

## 20. How does React Query handle refetching?

**Answer:**

It automatically refetches on window focus or interval via refetchOnWindowFocus and staleTime.

## Advanced Senior-Level Questions (21-50)

**21.** Difference between ref.watch and ref.read in Riverpod → reactive vs non-reactive reads.

**22.** Redux selectors → memoized derived state using reselect.

**23.** GetX lifecycle methods → onInit, onClose.

**24.** Bloc transition logs → for debugging state changes.

**25.** Zustand's subscribe → custom reactions outside React.

**26.** Why avoid overusing Context → causes massive re-renders.

**27.** How to debounce Redux actions → via middleware.

**28.** How to handle optimistic updates → React Query mutation rollback.

**29.** Flutter Riverpod autoDispose → clears unused providers.

**30.** GetX bindings → lazy dependency injection setup.

**31.** Riverpod family → dynamic parameterized providers.

**32.** Redux DevTools → visualize dispatched actions.

**33.** BlocObserver → global event logging.

**34.** Zustand persist config → create(persist(...)).

**35.** How to combine multiple Blocs → MultiBlocProvider.

**36.** Use Redux middleware for side effects.

**37.** React Query invalidate queries for data refresh.

**38.** Flutter Riverpod asyncValue states: loading, data, error.

**39.** GetX routing integrated with controller lifecycles.

**40.** Zustand vs Context for performance profiling.

**41.** Bloc vs Cubit difference → Cubit has direct state emit, no events.

**42.** Riverpod vs Provider package → compile-time safety.

**43.** Redux thunk vs saga → async logic handling difference.

**44.** Zustand action batching → automatic via React 18.

**45.** Flutter performance optimization using const constructors with Bloc.

**46.** Cross-stack principle: one source of truth.

**47.** Riverpod providers can depend on other providers (provider chaining).

**48.** Redux normalizing state for large lists.

**49.** Flutter Bloc BlocSelector for fine-grained rebuilds.

**50.** Zustand selectors prevent over-rendering by shallow comparing slices.
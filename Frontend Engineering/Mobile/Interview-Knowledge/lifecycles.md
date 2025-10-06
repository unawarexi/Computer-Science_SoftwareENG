# Top 50 Questions: Lifecycle & Methods

A comprehensive guide for Flutter and React Native developers covering widget and component lifecycles.

## Widget/Component Initialization (Mounting Phase)

### 1. Walk me through the widget/component lifecycle in Flutter vs React Native

**Flutter**: constructor → initState() → didChangeDependencies() → build()

**React Native (Class)**: constructor → componentDidMount()

**React Native (Hooks)**: useEffect(() => {...}, [])

### 2. When does initState() run in Flutter?

Once — before build() and after the widget is inserted into the tree.

### 3. What's the React Native equivalent of initState()?

componentDidMount() (class) or useEffect(..., []) (hooks).

### 4. When should you make API calls on mount?

**Flutter**: inside initState()

**React Native**: inside useEffect(() => {...}, [])

### 5. Can initState() be async in Flutter? Why or why not?

No — must stay synchronous. Use async method inside it.

### 6. What's the right way to call setState() in React Native and Flutter initialization?

After component mounts or widget tree is ready, not in constructor.

### 7. How does dependency injection affect lifecycle initialization?

Must resolve dependencies before build/render.

### 8. When is didChangeDependencies() called in Flutter?

After initState() or when an inherited widget changes (e.g., Theme, Locale).

### 9. In React, when would you use cleanup logic after mount?

Return a cleanup function in useEffect.

### 10. Why avoid heavy logic inside build() or render()?

Rebuilds frequently; heavy logic causes UI lag.

## Rebuilds & Updates (State Changes)

### 11. How does Flutter rebuild a widget tree after setState()?

Calls build() again but reuses the existing State object.

### 12. What happens when React state changes?

React re-renders that component and diff-checks the Virtual DOM.

### 13. When is didUpdateWidget() called in Flutter?

When the parent rebuilds and passes new widget config to the same State.

### 14. How do you detect prop changes in React Native?

componentDidUpdate(prevProps, prevState) or useEffect watching dependencies.

### 15. How to prevent unnecessary rebuilds/renders?

**Flutter**: Use const constructors, ValueListenableBuilder, Selector

**React**: React.memo, useMemo, useCallback

### 16. Explain widget identity using keys in Flutter

Keys preserve state when widget order changes; avoids losing state on rebuild.

### 17. How does shouldComponentUpdate() compare to setState() optimization?

Controls re-render conditions in React class components.

### 18. When to use AutomaticKeepAliveClientMixin in Flutter?

To preserve tab/page state when switching between screens.

### 19. What is buildContext in Flutter lifecycle?

Reference to widget location in tree — only valid after initState().

### 20. How would you debounce frequent state updates?

**Flutter**: Timer or RxDart

**React Native**: useCallback + debounce utils

## Unmounting / Disposal Phase

### 21. What's the purpose of dispose() in Flutter?

Clean up controllers, streams, focus nodes, animation controllers.

### 22. When is dispose() called?

When widget is permanently removed from widget tree.

### 23. React Native equivalent of dispose()?

componentWillUnmount() or cleanup in useEffect(() => {...; return () => cleanup();}, []).

### 24. Why is cleanup essential in lifecycles?

Prevent memory leaks or zombie listeners (especially async calls).

### 25. How do you cancel async subscriptions in Flutter?

Store in variable → cancel in dispose().

### 26. How do you unsubscribe from listeners in React Native?

Cleanup functions in useEffect.

### 27. What happens if setState() is called after dispose()?

**Flutter**: Throws setState() called after dispose() exception

**React**: React 18 warns about updating unmounted components

### 28. How would you handle component unmount triggered by navigation?

Clean up observers, cancel timers, close streams.

### 29. Can Flutter widgets resurrect after disposal?

No — must rebuild with new state object.

### 30. How do you handle AppLifecycleState when user minimizes app?

**Flutter**: Listen to WidgetsBindingObserver

**React Native**: AppState from react-native

## App Lifecycle (Foreground, Background, Resume)

### 31. Explain Flutter's app lifecycle states

inactive, paused, resumed, detached.

### 32. How to listen to app lifecycle changes in Flutter?

Implement WidgetsBindingObserver → override didChangeAppLifecycleState().

### 33. React Native equivalent of app lifecycle monitoring?

AppState.addEventListener('change', handler) with 'active' | 'background' | 'inactive'.

### 34. What happens when the app is backgrounded on Android?

UI paused, but memory may be retained or reclaimed.

### 35. How do you restore state after app resume?

Persist critical state to local storage or provider.

### 36. What's the impact of hot reload vs hot restart on lifecycle?

Hot reload keeps state; restart resets widget tree.

### 37. How to handle background tasks while respecting app lifecycle?

**Flutter**: workmanager / background_fetch

**React Native**: react-native-background-fetch or headless tasks

### 38. When would you use WidgetsBinding.instance.addPostFrameCallback()?

To execute code after first build frame renders (like componentDidMount()).

### 39. Explain cold start vs warm start in mobile lifecycle

Cold = app process start; Warm = resume from background.

### 40. How to detect if app was launched by a notification or deep link?

Use initial intent (React Native: Linking.getInitialURL() / Flutter: getInitialLink()).

## Navigation & Lifecycle Integration

### 41. What's the lifecycle impact of navigation in Flutter?

Old route's dispose() runs when popped; new route triggers initState().

### 42. How to persist state across route changes in Flutter?

AutomaticKeepAliveClientMixin or external state (Provider/Riverpod).

### 43. How does navigation affect lifecycle in React Native?

React Navigation fires focus / blur events; use hooks like useFocusEffect().

### 44. When should you refresh data on screen focus?

On re-entry (useFocusEffect or didPushNext).

### 45. How do you prevent data reload when returning to a tab?

Cache data, conditionally refresh only if expired.

### 46. What's the difference between pushReplacement and push in lifecycle?

Replacement disposes current route's state immediately.

### 47. How does modal navigation affect lifecycle?

Modal pushes new route layer; base screen stays alive but inactive.

### 48. How do you restore widget state on orientation change?

Persist to state management or PageStorage.

### 49. How do you track if a component is visible in viewport (for analytics)?

**React Native**: onLayout + intersection observer

**Flutter**: VisibilityDetector

### 50. How to debug lifecycle issues across async rebuilds?

Use Flutter DevTools "Rebuild Counts" / React Native React Profiler to trace render cycles.

## Pro Tips for Senior Interviews

- Avoid async state mutations in initState or after dispose
- Separate UI rebuilds from business logic (Bloc, Redux, Provider)
- Use mounted checks before calling setState() in async callbacks
- Always decouple lifecycle cleanup from dependency injection
- Log transitions to detect memory leaks or redundant rebuilds
# APP SCREEN OPTIMIZATION - 50 INTERVIEW QUESTIONS & ANSWERS

## Beginner Level (1-15)

**1. What is screen optimization in mobile apps?**

Answer: It's improving how fast screens load, render, and respond to user actions to enhance UX and reduce lag.

**2. Why is screen optimization important?**

Answer: It improves app performance, battery life, and user retention by preventing UI lag and jank.

**3. What are the most common causes of slow screen rendering?**

Answer: Heavy images, unnecessary re-renders, complex layouts, and blocking main-thread tasks.

**4. How can you measure screen performance?**

- React Native (Expo): Use Flipper, React DevTools, or Perf Monitor.
- Flutter: Use Flutter DevTools → Performance tab.

**5. What is the main thread (UI thread)?**

Answer: The thread responsible for rendering UI and handling gestures. Long tasks here cause visible lag.

**6. How do you reduce layout complexity?**

- React Native: Use fewer nested Views and leverage Flexbox.
- Flutter: Use Const widgets and simplify widget trees.

**7. How can images slow down screens?**

Answer: Large, uncompressed images increase memory use and load time.

**8. How do you optimize images?**

- React Native: Use react-native-fast-image or Expo's Image caching.
- Flutter: Use cached_network_image and compress assets.

**9. How to handle screen transitions efficiently?**

- React Native: Use react-navigation with enableScreens() and react-native-screens.
- Flutter: Use Navigator 2.0 or pre-cache next screens.

**10. What's the best way to handle large lists?**

- React Native: Use FlatList or SectionList with virtualization.
- Flutter: Use ListView.builder() or ListView.separated().

**11. Why use lazy loading for screens?**

Answer: It prevents loading all screens at once, saving memory and improving startup speed.

**12. How can animations affect screen performance?**

Answer: Poorly optimized animations can cause frame drops and lag if run on the main thread.

**13. How to optimize animations?**

- React Native: Use Reanimated 2, which runs on the UI thread.
- Flutter: Use AnimatedBuilder and TweenAnimationBuilder efficiently.

**14. What is a render pass?**

Answer: The process of drawing UI elements on screen each frame; fewer passes mean smoother performance.

**15. How to reduce re-renders in UI components?**

- React Native: Use React.memo() and useCallback().
- Flutter: Use const constructors and separate widgets logically.

## Intermediate Level (16-35)

**16. What is screen frame rate (FPS)?**

Answer: Frames per second the screen renders - aim for 60 FPS for smooth UIs.

**17. How to check dropped frames?**

- React Native: Enable performance monitor.
- Flutter: Use "Performance Overlay" (showPerformanceOverlay: true).

**18. How to reduce screen flickering?**

Answer: Preload data before navigation and use placeholder skeletons or shimmer effects.

**19. How to handle heavy screen data fetching?**

- React Native: Use pagination and background threads via InteractionManager.
- Flutter: Use FutureBuilder or background isolates.

**20. How do you optimize screen state management?**

- React Native: Use Zustand, Jotai, or Recoil instead of heavy Redux for small screens.
- Flutter: Use Provider, Riverpod, or Bloc effectively to rebuild minimal widgets.

**21. What's the role of memoization?**

Answer: Prevents unnecessary re-calculations and re-renders.

**22. How to optimize navigation stack performance?**

- React Native: Use react-native-screens to keep screens mounted efficiently.
- Flutter: Use Navigator.pushReplacement() or AutoRoute for better memory use.

**23. How to optimize scrolling performance?**

Answer: Use lazy-loading lists, windowing, and avoid nested scroll views.

**24. How to prefetch screen assets?**

- React Native: Use Asset.loadAsync() in Expo.
- Flutter: Use precacheImage() before navigation.

**25. What's batching in UI updates?**

Answer: Grouping UI updates to minimize re-render overhead and layout recalculations.

**26. What is layout thrashing?**

Answer: Frequent layout recalculations due to changing UI properties - avoid by batching state updates.

**27. How to optimize screen rebuilds during navigation?**

- React Native: Cache or memoize screen components.
- Flutter: Use AutomaticKeepAliveClientMixin.

**28. What is deferred rendering?**

Answer: Delaying rendering of non-critical widgets to focus on above-the-fold UI first.

**29. How to handle expensive computations in UI?**

- React Native: Use Web Workers or offload logic to backend.
- Flutter: Use compute() or isolate.

**30. What is the difference between synchronous and asynchronous rendering?**

Answer: Async rendering allows smoother UI updates without blocking user interactions.

**31. How to reduce app start-up (first screen) time?**

- React Native: Lazy load heavy components, use Hermes engine.
- Flutter: Minimize work in main() and initState.

**32. How do you monitor memory leaks in screens?**

- React Native: Use Flipper Memory plugin.
- Flutter: Use DevTools → "Memory" tab.

**33. What is screen jank?**

Answer: Noticeable stutter caused by dropped frames when rendering takes longer than 16ms.

**34. How to prevent jank?**

Answer: Avoid doing work on the main thread and precompute heavy operations off-screen.

**35. How can you profile screen performance?**

- React Native: Flipper → Performance Plugin.
- Flutter: DevTools → Timeline.

## Senior Level (36-50)

**36. How do you manage screen rendering priorities?**

Answer: Render above-the-fold first, defer below content using placeholders.

**37. How to use code splitting for screen optimization?**

- React Native: Use dynamic imports with React.lazy().
- Flutter: Use deferred imports via deferred as.

**38. What's the role of background preloading?**

Answer: Load upcoming screen data/images while user interacts with current screen.

**39. How to optimize offline-first screens?**

- React Native: Cache data using AsyncStorage or SQLite.
- Flutter: Use Hive, Drift, or shared_preferences.

**40. What is the impact of overdraw on screen rendering?**

Answer: Drawing pixels multiple times slows rendering. Reduce overlapping layers.

**41. How to minimize overdraw?**

Answer: Use flat layouts, remove unnecessary transparency, and clip widgets properly.

**42. How to handle screen-level caching?**

- React Native: Use state caching or React Query.
- Flutter: Use KeepAlive or PageStorage.

**43. What is UI virtualization?**

Answer: Only render visible items on screen - used in lists to improve performance.

**44. How to optimize tabbed screens?**

- React Native: Use react-native-screens or lazy loading in Tab.Navigator.
- Flutter: Use IndexedStack or AutomaticKeepAliveClientMixin.

**45. How to optimize accessibility performance?**

Answer: Reduce excessive accessible elements, group semantic nodes efficiently.

**46. How to optimize dark/light mode rendering?**

Answer: Avoid full rebuilds; use dynamic theme listeners efficiently.

**47. How to handle large canvas/drawing screens efficiently?**

- React Native: Use react-native-skia.
- Flutter: Use CustomPaint and RepaintBoundary wisely.

**48. How to detect and fix slow screen transitions?**

Answer: Use profiler tools to locate heavy builds and delay or prefetch assets.

**49. How to optimize gesture-heavy screens?**

- React Native: Use react-native-gesture-handler.
- Flutter: Use lightweight gesture detectors and avoid rebuilding parent widgets.

**50. What's a full strategy to optimize an app's screen performance?**

Answer:

1. Measure and profile performance.
2. Reduce layout depth and re-renders.
3. Optimize images and animations.
4. Lazy load and cache.
5. Offload heavy logic.
6. Re-test and monitor continuously.
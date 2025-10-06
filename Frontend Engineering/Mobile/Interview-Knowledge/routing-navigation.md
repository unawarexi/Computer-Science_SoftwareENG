# Top 50 Questions: Navigation, Stack Management, Deep Linking & Route Lifecycle

A comprehensive guide for Flutter and React Native developers covering navigation fundamentals, stack management, deep linking, and advanced routing patterns.

## Navigation Fundamentals (1-10)

### 1. Walk me through how navigation works in Flutter and React Native

**Flutter**: Uses Navigator with a stack-based route system (push, pop).

**React Native**: Uses React Navigation — manages routes via stacks, tabs, and drawers.

### 2. How do you define routes in Flutter?

In `MaterialApp(routes: {...})` or via `onGenerateRoute`.

Example: `Navigator.pushNamed(context, '/profile')`

### 3. How do you define routes in React Navigation?

`createStackNavigator()` or `createNativeStackNavigator()`.

Example: `<Stack.Screen name="Profile" component={ProfileScreen} />`

### 4. Explain the navigation stack concept

Every new screen is pushed onto a stack; back navigation pops the last screen.

### 5. How do you navigate back?

**Flutter**: `Navigator.pop(context)`

**React Native**: `navigation.goBack()` or `navigation.pop()`

### 6. How do you pass data between screens?

**Flutter**: `Navigator.push(context, MaterialPageRoute(builder: ..., settings: RouteSettings(arguments: data)))`

**React Native**: `navigation.navigate('Profile', {userId: 1})`

### 7. How do you receive arguments?

**Flutter**: `ModalRoute.of(context)!.settings.arguments`

**React Native**: `route.params`

### 8. How do you prevent multiple navigations at once (debounce)?

Guard navigation actions with a flag or async lock to prevent double taps.

### 9. What's the difference between named and anonymous routes?

**Named** = pre-declared with keys

**Anonymous** = inline MaterialPageRoute / dynamic creation

### 10. When would you use nested navigation?

For independent tab stacks (e.g., Home tab vs Profile tab) — keeps back navigation isolated.

## Stack & Route Management (11-20)

### 11. What is the difference between pushReplacement and push in Flutter?

pushReplacement removes the current route and replaces it with a new one.

### 12. React equivalent of pushReplacement?

`navigation.replace('RouteName')`

### 13. How to clear navigation history?

**Flutter**: `Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)`

**React Native**: `navigation.reset({ index: 0, routes: [{ name: 'Home' }] })`

### 14. How would you handle stack overflow or route memory leaks?

Use guarded navigation, WillPopScope (Flutter) or BackHandler (React Native).

### 15. How do you persist navigation state on app restart?

Store last route path in secure/local storage, rehydrate navigation tree on boot.

### 16. What's the difference between pop and popUntil?

`pop()` removes top; `popUntil()` pops until condition is met.

### 17. How do you implement conditional navigation guards?

**Flutter**: onGenerateRoute intercepts before route build

**React Native**: Wrap navigators with auth check HOC or beforeEnter hook (custom)

### 18. Explain "pushNamedAndRemoveUntil" in Flutter

Pushes a new route, removes all others until predicate is true (commonly to reset navigation after login).

### 19. How do you simulate browser-like history?

**Flutter**: Use Navigator.pages or GoRouter for declarative routing

**React Native**: Use deep linking-enabled navigators with URL persistence

### 20. When should you use a navigation observer?

**Flutter**: NavigatorObserver to track route changes (analytics, logs)

**React Native**: `navigation.addListener('focus', callback)`

## Deep Linking & URL Handling (21-30)

### 21. What is deep linking?

Launching a specific screen directly from a URL (e.g., myapp://profile/1).

### 22. How to configure deep links in Flutter?

uni_links, firebase_dynamic_links, or GoRouter with URL mapping.

### 23. How to configure deep links in React Native?

Use Linking API or @react-navigation/native's linking config.

### 24. What's the difference between deep link and universal link?

**Deep link** works only if app installed

**Universal/App Links** work both in web and app

### 25. How do you handle initial deep links?

**Flutter**: `getInitialLink()` or via intent filter

**React Native**: `Linking.getInitialURL()`

### 26. How do you listen for link changes while the app is open?

**Flutter**: `linkStream.listen(...)`

**React Native**: `Linking.addEventListener('url', handler)`

### 27. How to structure URL routes to map nested screens?

Define pattern `/home/profile/:id`; extract params inside route.

### 28. What's a dynamic link in Firebase?

Smart deep link that survives app installs — sends user to Play Store / App Store first.

### 29. How do you test deep links locally?

Use `adb shell am start -W -a android.intent.action.VIEW -d "myapp://screen"` or iOS `xcrun simctl openurl`.

### 30. How to handle invalid deep links gracefully?

Redirect to default screen with alert.

## Navigation Lifecycle & Events (31-40)

### 31. What lifecycle methods are triggered on navigation push in Flutter?

Old screen → deactivate() → dispose() (if popped)

New screen → initState() → build()

### 32. React Native lifecycle during navigation?

blur (old screen), focus (new screen) events fire.

### 33. How to run actions when screen appears again?

**Flutter**: Use `didPopNext()`, `didPushNext()`

**React Native**: Use `useFocusEffect()` or `navigation.addListener('focus')`

### 34. How to handle back press actions?

**Flutter**: `WillPopScope(onWillPop: ...)`

**React Native**: `BackHandler.addEventListener('hardwareBackPress', handler)`

### 35. Explain RouteObserver in Flutter

Observer that tracks route transitions (enter/exit) globally.

### 36. How to detect if user navigated back manually?

Compare pop vs programmatic navigation events.

### 37. When does didChangeDependencies() get triggered due to route changes?

When an inherited dependency (like locale or theme) changes along route.

### 38. How do you optimize rebuilds when navigating frequently?

Keep heavy widgets alive via AutomaticKeepAliveClientMixin or React.memo.

### 39. What happens if you trigger navigation inside build()?

Causes unwanted loops; must defer using `WidgetsBinding.instance.addPostFrameCallback`.

### 40. How to handle nested navigation events (tab in tab)?

**React Native**: useNavigation() inside child

**Flutter**: nested Navigator instances

## Advanced Scenarios & Patterns (41-50)

### 41. Explain declarative routing

Routes defined as part of widget tree (GoRouter, Navigator.pages); better for state-driven navigation.

### 42. Compare imperative vs declarative navigation

**Imperative** = command (push/pop)

**Declarative** = UI-driven via route state list

### 43. When should you use GoRouter or Beamer in Flutter?

For web-friendly routing, URL sync, or nested flow navigation.

### 44. When to use nested stack navigators in React Native?

When tabs require independent stack history.

### 45. How do you integrate deep linking with authentication flows?

Intercept link → check token → redirect appropriately.

### 46. How to secure deep links from malicious triggers?

Validate input, enforce signed URLs, verify source.

### 47. Explain navigation state hydration

Saving and restoring route hierarchy after app restart.

### 48. How do you handle navigation race conditions (async events + nav)?

Use guards to ensure route is still mounted; check `mounted` or `isFocused()`.

### 49. What's the difference between popUntil and maybePop in Flutter?

`popUntil` pops until condition true; `maybePop` pops only if possible (no root screen).

### 50. How do you track navigation analytics?

**Flutter**: add RouteObserver with analytics logger

**React Native**: add navigation listener to log route.name

## Senior Notes

- Always decouple navigation logic from UI (e.g., using a NavigationService)
- Use declarative routing for predictable state-driven flows
- Persist navigation stack on app resume for continuity
- Handle lifecycle + navigation together for a seamless user experience
- Always test deep links on all platforms and routes
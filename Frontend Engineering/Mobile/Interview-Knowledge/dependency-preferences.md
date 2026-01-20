⚙️ TOP 50 INTERVIEW QUESTIONS & ANSWERS
📦 Dependency Preferences, Tools, and Setup Flow (React Native + Flutter)
🔹 1. Walk me through the process of setting up dependencies for a new Flutter or React Native app.

Answer:

Flutter: Use pubspec.yaml for version pinning. Run flutter pub get.

React Native: Use package.json, manage with npm or yarn. Run npx expo install or npm install.
Best Practice: Lock versions and use .nvmrc or fvm for consistent SDK versions.

🔹 2. How would you decide between using a third-party library vs building in-house?

Answer:
Use a third-party if:

It’s actively maintained.

It solves a non-core problem (e.g., date picker, maps).
Build in-house if:

It’s core to your business logic.

You need control, customization, or performance optimization.

🔹 3. What tools do you use to manage environment variables?

Answer:

React Native (Expo): react-native-dotenv or Expo config plugins.

Flutter: .env with flutter_dotenv or native .env.json.
Keep secrets off Git, use .gitignore.

🔹 4. How do you handle dependency versioning consistency across teams?

Answer:

Lock file (package-lock.json / pubspec.lock)

Enforce SDK versioning: engines in package.json or fvm.

Use CI step to verify dependency drift (npm ci, flutter pub outdated).

🔹 5. Which package managers are preferred and why?

Answer:

React Native: Yarn for deterministic installs.

Flutter: Built-in pub.
Yarn uses parallel installs; Pub has checksum validation.

🔹 6. Walk me through the process of setting up secure local storage dependencies.

Answer:

React Native: expo-secure-store or react-native-encrypted-storage.

Flutter: flutter_secure_storage.
Flow: Encrypt data → store in OS secure enclave → retrieve with authentication.

🔹 7. How would you integrate offline data caching dependencies?

Answer:

React Native: @react-native-async-storage/async-storage + query library caching (React Query).

Flutter: hive or sqflite.
Combine with background sync queue for consistency.

🔹 8. How do you choose between SQLite, Hive, and MMKV?

Answer:

SQLite: Structured, relational (analytics, filters).

Hive: Fast key-value, unstructured.

MMKV: Low-level, C++ fast key-value (lightweight cache).
Tradeoff: Hive < SQLite in complex queries, but faster for reads.

🔹 9. What tools would you use for API communication?

Answer:

React Native: axios or fetch.

Flutter: dio (interceptors, cancel tokens).
Include retry interceptors and request caching for resilience.

🔹 10. How do you handle dependency injection (DI) in both stacks?

Answer:

React Native: Context, custom hooks, or InversifyJS.

Flutter: get_it or riverpod (dependency provider).
Promotes testability and modularity.

🔹 11. What’s your preferred navigation library and why?

Answer:

React Native: @react-navigation/native (deep linking + stack + tabs).

Flutter: go_router or auto_route for declarative routing.
Focus on dynamic deep linking and modular route separation.

🔹 12. How do you choose tools for authentication?

Answer:

React Native: expo-auth-session, Firebase Auth, or OAuth with AppAuth.

Flutter: firebase_auth, flutter_appauth.
Choose based on provider flexibility and token refresh control.

🔹 13. What’s your dependency stack for notifications?

Answer:

React Native: @react-native-firebase/messaging or expo-notifications.

Flutter: firebase_messaging + flutter_local_notifications.
Flow: FCM token → store → handle background and foreground payloads.

🔹 14. Walk me through setting up WebSocket dependencies.

Answer:

React Native: socket.io-client, or native WebSocket.

Flutter: web_socket_channel.
Flow: Connect → listen → handle reconnection → message parsing.

🔹 15. Which dependency do you prefer for state persistence?

Answer:

React Native: Zustand persist, Redux persist.

Flutter: Hive, shared_preferences, hydrated_bloc.
Ensures state recovery after app restart.

🔹 16. How would you handle dependency conflicts?

Answer:

Use resolution strategies (resolutions in Yarn, dependency overrides in Flutter).

Audit versions and lock dependencies.

Prefer patching via patch-package for JS or dependency_overrides for Dart.

🔹 17. How do you choose UI component libraries?

Answer:

React Native: react-native-paper, native-base, or ui-kitten.

Flutter: flutter_hooks, getwidget, shadcn_ui.
Choose based on theme extensibility and accessibility support.

🔹 18. How do you manage app icons, splash, and branding assets?

Answer:

React Native: expo-splash-screen, expo-icons.

Flutter: flutter_native_splash, flutter_launcher_icons.
Automate generation to avoid manual scaling.

🔹 19. Walk me through Firebase integration setup.

Answer:

Add Firebase project.

Add GoogleService files (JSON/plist).

Install dependencies (@react-native-firebase/app, firebase_core).

Initialize on startup.
Use environment-specific Firebase projects for staging and prod.

🔹 20. How do you configure crash reporting and analytics?

Answer:

React Native: @react-native-firebase/crashlytics, Sentry.

Flutter: firebase_crashlytics, sentry_flutter.
Automate logging errors to backend dashboards.

🔹 21. Which dependency do you use for app performance profiling?

Answer:

React Native: Flipper plugins, Hermes profiling.

Flutter: DevTools performance tab.
Use to detect UI jank, slow rebuilds, and memory leaks.

🔹 22. How would you set up feature flags or A/B testing?

Answer:

React Native: launchdarkly, configcat, or Firebase Remote Config.

Flutter: firebase_remote_config.
Use config values to enable/disable experimental features dynamically.

🔹 23. How do you handle app permissions?

Answer:

React Native: react-native-permissions.

Flutter: permission_handler.
Centralize permission logic and gracefully degrade for denied states.

🔹 24. What tool would you use for background tasks?

Answer:

React Native: react-native-background-fetch.

Flutter: workmanager.
Used for periodic sync and background updates.

🔹 25. How would you set up logging and monitoring?

Answer:

React Native: Winston, Sentry, or LogRocket.

Flutter: logger, Firebase Analytics, or Sentry.
Include structured logs with timestamps and context.

🔹 26. How do you prefer dependency architecture for modularization?

Answer:
Split modules by feature and layer:

Flutter: use packages inside /packages folder.

React Native: modularize with monorepo setup (Turborepo / NX).

🔹 27. Walk me through the process of setting up testing tools.

Answer:

React Native: Jest + React Testing Library.

Flutter: flutter_test, mocktail, integration_test.
Include CI hooks to run tests pre-deployment.

🔹 28. Which dependency would you use for form validation?

Answer:

React Native: react-hook-form + zod/yup.

Flutter: flutter_form_builder, formz.
Encapsulate validation logic in stateful controllers.

🔹 29. How do you manage dependencies for localization?

Answer:

React Native: react-native-localize, i18next.

Flutter: flutter_localizations, intl.
Setup localization delegates and JSON-based translations.

🔹 30. How do you handle dependency cleanup?

Answer:
Run periodic audits:

npm audit fix / flutter pub outdated.
Remove unused packages using depcheck or manual pruning.

🔹 31. Preferred animation libraries?

Answer:

React Native: Reanimated 3, Moti.

Flutter: animations, rive, lottie.
Focus on 60fps smoothness and hardware-accelerated rendering.

🔹 32. How do you manage API versioning dependencies?

Answer:
Abstract API client; use constants or environment layers for v1, v2 versions.
Keep migration handlers per version.

🔹 33. How do you prefer to configure dependency injection for analytics?

Answer:
Inject via singleton service class in DI container, ensuring it’s initialized once.

🔹 34. What are your preferred security dependencies?

Answer:

Encryption: crypto-js (JS), encrypt (Dart).

Key storage: expo-secure-store, flutter_secure_storage.

Network security: certificate pinning via dio interceptors.

🔹 35. Which dependency setup do you use for file handling?

Answer:

React Native: react-native-fs.

Flutter: path_provider, file_picker, image_picker.

🔹 36. How would you configure a monorepo dependency setup?

Answer:
Use Turborepo or NX for React Native, and Melos for Flutter.
Centralizes versioning and builds for shared modules.

🔹 37. Walk me through the setup of dependency aliases.

Answer:

React Native: babel-plugin-module-resolver.

Flutter: Use import_aliases via relative or package imports.
Simplifies long path imports for scalability.

🔹 38. How do you ensure dependency security compliance?

Answer:
Use CI tools like Snyk, Dependabot.
Run audits before deployment and pin versions explicitly.

🔹 39. How do you handle dependency-heavy build times?

Answer:
Cache builds in CI, use Yarn Plug’n’Play (React) or Flutter build cache.
Split dependencies by environments (dev, prod).

🔹 40. How do you manage native dependency linking?

Answer:

Expo: Managed config plugins.

React Native CLI: react-native link or pod install.

Flutter: auto-link via pubspec.
Verify Gradle/Xcode linkage post-install.

🔹 41. How would you configure CI/CD to handle dependencies?

Answer:
Use caching layers:

React: .yarn/cache

Flutter: ~/.pub-cache
Run integrity checks (yarn check, flutter pub deps).

🔹 42. What dependency helps with app versioning and OTA updates?

Answer:

React Native: Expo OTA updates, CodePush.

Flutter: shorebird.
Reduces resubmission to app stores for small updates.

🔹 43. Which dependency do you use for deep linking?

Answer:

React Native: expo-linking, react-navigation.

Flutter: uni_links, go_router.

🔹 44. How do you manage dev vs prod dependencies?

Answer:
Separate:

JS: devDependencies in package.json.

Dart: dev_dependencies in pubspec.yaml.
Run conditional imports.

🔹 45. Preferred dependency for animations with physics?

Answer:

React Native: Reanimated spring physics.

Flutter: physics_based_animation or custom CurvedAnimation.

🔹 46. What tools do you use for dependency documentation?

Answer:
Use Storybook (React) or Widgetbook (Flutter) for visual dependency docs.

🔹 47. Which dependency setup supports analytics dashboards?

Answer:

Firebase Analytics, Amplitude, or Mixpanel SDKs.
Inject via DI for flexible event tracking.

🔹 48. How do you optimize dependency loading at runtime?

Answer:
Code-splitting (React) with dynamic imports, deferred imports in Flutter (deferred as).

🔹 49. What’s your strategy for dependency upgrades in production?

Answer:
Use feature branches → canary builds → gradual rollout.
Automate with Dependabot or Renovate.

🔹 50. How do you handle dependency fallback strategies?

Answer:
Implement graceful fallback —
e.g., if firebase fails, fallback to REST API.
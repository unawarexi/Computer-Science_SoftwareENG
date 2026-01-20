⚙️ Top 50 App Configuration & Setup Questions (Senior Level)

(Covers Secure Storage, Hive, WebSockets, FCM, Notifications, App Environment, etc.)

🧩 App Foundation & Environment

1. How would you set up and explain the flow of app environment configuration (dev, staging, prod)?

React Native (Expo):

Create .env files (.env.dev, .env.prod).

Use expo-constants or react-native-config to load variables.

Configure scripts in app.config.js to load proper env file.

Use CI/CD variables to inject secrets dynamically.

Flutter:

Create lib/environment.dart with --dart-define flags.

Configure build flavors in pubspec.yaml (dev, staging, prod).

Automate with flutter_flavorizr for builds.

Inject API keys via CI/CD pipelines.

2. Walk me through the process of setting up app-level constants and config management.

Centralize configuration in /core/config/.

Load constants from .env or dotenv.

Create interfaces to expose constants, ensuring no hardcoded secrets.

Example: Config.apiBaseUrl references environment variable.

3. How would you set up and explain the flow of app initialization (splash + preloading)?

Run setup functions in main() or App.tsx.

Initialize critical services (storage, analytics, theme, localization).

Preload assets (images, fonts).

Load user session/token before routing to main UI.

4. Walk me through the process of handling app versioning and updates.

Integrate with app store APIs or Expo Updates.

Fetch version metadata from API.

If outdated → show update modal or trigger OTA (Over-The-Air) update.

Use CodePush (RN) or in_app_update (Flutter).

5. How would you set up and explain the flow of logging & crash reporting?

React Native: Integrate Sentry or Firebase Crashlytics.

Flutter: Use firebase_crashlytics + runZonedGuarded() for global errors.

Log network and logic errors with correlation IDs for backend traceability.

🔐 Storage & Security

6. How would you set up and explain the flow of secure storage for sensitive data?

React Native:

Use expo-secure-store or react-native-keychain.

Encrypt tokens before saving.

Flutter:

Use flutter_secure_storage.

Store tokens/keys, not large data.

Use platform keychain (iOS) / Keystore (Android).

7. Walk me through the process of setting up Hive for offline persistence.

Flutter only:

Install hive, hive_flutter.

Call Hive.initFlutter() in main().

Register adapters for models.

Open boxes (tables).

Wrap Hive usage in Repository layer for modularity.

8. How would you set up and explain the flow of AsyncStorage/local caching?

React Native: Use @react-native-async-storage/async-storage.

Wrap get/set calls in service functions.

Avoid large objects; store references or IDs only.

9. Walk me through the process of encrypting local storage data.

Encrypt values before saving to Hive/AsyncStorage.

Use AES-256 with a locally derived key (SecureStore).

Never store encryption key in plain form.

10. How would you handle session management securely?

Store JWT in Secure Storage.

Refresh tokens via background service before expiry.

Clear session on logout or token expiry.

☁️ Networking, WebSockets, and APIs

11. How would you set up and explain the flow of API client configuration?

Centralize Axios/Dio client.

Configure interceptors for:

Request logging

JWT injection

Retry logic on 401

Use base URLs from environment config.

12. Walk me through the process of setting up WebSocket connections.

React Native: Use socket.io-client or native WebSocket.

Flutter: Use web_socket_channel.

Implement connection states: connecting, connected, disconnected.

Auto-reconnect on failure.

Use listener streams for incoming data and broadcast updates.

13. How would you handle WebSocket authentication flow?

Pass access token in connection query/header.

Reconnect with refreshed token if expired.

Disconnect on logout.

14. Walk me through the process of setting up API versioning and base URLs.

Define Config.apiBaseUrl per environment.

Append version path (/v1/, /v2/) dynamically.

Handle migrations in data layer (version switcher).

15. How would you set up and explain the flow of network connectivity handling?

Subscribe to connectivity changes.

React Native: @react-native-community/netinfo.

Flutter: connectivity_plus.

Notify user if offline.

Queue unsent requests until online (background sync).

16. Walk me through the process of implementing background sync.

Use background task manager.

React Native: react-native-background-fetch.

Flutter: workmanager.

Queue requests while offline, replay when connection restores.

17. How would you set up and explain the flow of caching API responses?

Implement local cache using Hive/AsyncStorage.

Tag cache keys by endpoint and params.

Apply cache-first or stale-while-revalidate strategy.

18. Walk me through the process of implementing SSL pinning.

Use libraries like react-native-ssl-pinning or http_certificate_pinning.

Store certificate fingerprints in app.

Verify SSL on connection start.

19. How would you handle proxy or network timeouts configuration?

Define custom timeout (e.g., 10s).

Gracefully handle network exceptions and retries.

20. Walk me through the process of monitoring API latency.

Capture timestamps before and after each call.

Log duration metrics to analytics.

Optimize endpoints or CDN usage if latency spikes.

🔔 Notifications (FCM, Local, Push)

21. How would you set up and explain the flow of Firebase Cloud Messaging (FCM)?

React Native (Expo):

Use expo-notifications + Firebase project setup.

Request permissions.

Get FCM token and register on backend.

Flutter:

Use firebase_messaging.

Handle onMessage, onBackgroundMessage.

Manage tokens and topic subscriptions.

22. Walk me through the process of handling foreground vs background notifications.

Foreground: Show in-app modal/snackbar.

Background: Use notification tray.

Tap → deep link into app screen.

23. How would you configure topic-based notifications?

Backend assigns user topics (e.g., “news”, “promotions”).

FCM subscribes users to those topics.

Notifications broadcasted to topic channels.

24. Walk me through the process of scheduling local notifications.

React Native: Use expo-notifications.

Flutter: Use flutter_local_notifications.

Set schedule time and payload, e.g., reminders or tasks.

25. How would you handle notification actions (e.g., “Reply”, “Mark as Read”)?

Define action identifiers.

Capture events on tap.

Route to screen or trigger local logic.

26. Walk me through the process of securing notification payloads.

Avoid sending sensitive data in payload.

Send minimal IDs → fetch data via API upon open.

27. How would you handle notification token refresh?

Listen to token refresh events.

Update backend token registry on refresh.

📡 Realtime & Background Tasks

28. How would you set up and explain the flow of background location tracking?

React Native: expo-location with background tasks.

Flutter: geolocator + background_fetch.

Request permissions, handle OS lifecycle.

29. Walk me through the process of implementing background data uploads.

Use OS background tasks or headless JS.

Store pending uploads in local DB.

Process them when online or battery > threshold.

30. How would you handle background notifications with payload actions?

Register background handlers.

Execute logic silently (no UI render).

Post results via headless task.

31. Walk me through the process of setting up analytics and user tracking.

React Native: @react-native-firebase/analytics.

Flutter: firebase_analytics.

Track screens, events, retention metrics.

Never log PII.

32. How would you set up and explain the flow of in-app update prompts?

Check remote config version.

If outdated → trigger modal → direct to store or OTA.

Handle mandatory and optional update types.

💾 Database & Persistence

33. Walk me through the process of setting up SQLite database.

React Native: react-native-sqlite-storage.

Flutter: sqflite.

Create DB helper service, define tables and CRUD methods.

Handle migrations manually or via version scripts.

34. How would you set up and explain the flow of syncing local DB with server?

Compare timestamps.

Apply differential sync (only changed records).

Resolve conflicts by priority or merge policy.

35. Walk me through the process of implementing data encryption at rest.

Use encrypted DB packages.

React Native: react-native-sqlcipher.

Flutter: sqflite_sqlcipher.

36. How would you structure database models and repositories?

Use domain-based model classes.

Implement Repository layer to abstract DB logic.

Repositories return clean domain entities, not raw DB data.

🧠 App Optimization Configs

37. Walk me through the process of setting up lazy loading and code splitting.

React Native: Use React.lazy() for routes.

Flutter: Use deferred imports.

Split modules like Auth, Dashboard, Settings.

38. How would you handle configuration for asset preloading and caching?

Cache images and fonts on startup.

Use LRU cache strategy.

Clear cache on version upgrade.

39. Walk me through setting up device orientation and screen density configuration.

Lock orientation where necessary.

Scale layouts based on device pixel ratio.

Use responsive design utilities.

40. How would you configure app theme switching (dark/light mode)?

Use system theme listeners.

Save preference to local storage.

Trigger rebuild of theme context/provider.

🧭 App Integrations

41. Walk me through the process of setting up Deep Links and Universal Links.

Define URL schemes and intent filters.

React Native: Use expo-linking or react-navigation deep link config.

Flutter: Use uni_links.

Parse incoming link and navigate accordingly.

42. How would you set up and explain the flow of Dynamic Links (Firebase)?

Enable Firebase Dynamic Links.

Generate short links with metadata.

Parse them at app launch or resume.

43. Walk me through the process of setting up biometric authentication.

React Native: react-native-touch-id / expo-local-authentication.

Flutter: local_auth.

Request face/fingerprint auth for sensitive actions.

44. How would you set up and explain the flow of social login integrations?

Configure provider OAuth credentials.

Use SDKs (GoogleSignIn, AppleAuth).

Exchange token → backend → create session.

45. Walk me through setting up app localization and i18n.

Define en.json, fr.json, etc.

React Native: Use react-intl or i18next.

Flutter: Use flutter_localizations + intl.

Detect device locale → load correct language pack.

🧱 Build, CI/CD & Deployment Configs

46. How would you set up and explain the flow of app signing & build configuration?

Generate keystore or provisioning profile.

Add secure env secrets to CI/CD.

Automate signing with Fastlane or EAS Build.

47. Walk me through setting up continuous integration (CI/CD).

Use GitHub Actions, Bitrise, or Codemagic.

Run lint → tests → build → deploy pipeline.

Auto-publish dev/staging builds.

48. How would you handle secure config variables in CI/CD pipelines?

Store in CI secrets manager.

Never hardcode in repo.

Use environment mapping per build flavor.

49. Walk me through the process of setting up OTA (Over-The-Air) updates.

React Native: Use expo-updates or CodePush.

Flutter: Use remote config triggers with update prompt.

Rollback if update fails (fail-safe).

50. How would you set up and explain the flow of app performance monitoring?

Integrate Firebase Performance or Sentry.

Log cold start times, slow renders, memory usage.

Set up alerting thresholds in dashboard.
# APP ARCHITECTURE & STRUCTURE - 50 INTERVIEW QUESTIONS & ANSWERS

## Beginner Level (1-15)

**1. What is app architecture?**

Answer: It's the organized structure and flow of an app's code - how components, data, and logic are arranged for scalability and maintainability.

**2. Why is architecture important?**

Answer: It ensures cleaner code, easier testing, reusability, scalability, and efficient teamwork.

**3. What's the difference between architecture and folder structure?**

Answer:

- Architecture: Conceptual pattern (MVC, MVVM, etc.).
- Structure: Physical file/folder layout implementing that architecture.

**4. What is the most common architecture pattern for mobile apps?**

Answer: MVC, MVVM, and Clean Architecture (Layered).

**5. What are the main layers in a clean architecture?**

Answer:

- Presentation (UI)
- Domain (Business logic)
- Data (APIs, databases)

**6. How do React Native and Flutter differ in app structure?**

- React Native: JS-based; component folders, hooks, and context organization.
- Flutter: Dart-based; feature modules with widgets, blocs, and repositories.

**7. What is component-based architecture?**

Answer: Building UI using independent, reusable components/widgets.

**8. Where should business logic go?**

- React Native: In custom hooks or service modules.
- Flutter: In Bloc, Provider, or Controller classes.

**9. What is a feature-based folder structure?**

Answer: Group files by feature (e.g., /auth, /profile) instead of by type (e.g., /components).

**10. How do you structure reusable UI components?**

- React Native: /components/common/
- Flutter: /widgets/common/

**11. What is a "screen" in architecture?**

Answer: A full page or route that composes multiple smaller UI widgets/components.

**12. How to separate UI from logic?**

- React Native: Use hooks and contexts.
- Flutter: Use Bloc, ChangeNotifier, or Riverpod.

**13. What are services in app architecture?**

Answer: Classes handling network calls, database access, or device APIs.

**14. What is a state management layer?**

Answer: Controls how data flows and changes across screens.

**15. How to name folders for clarity?**

Answer: Use consistent lowercase-hyphenated names, e.g., user-profile/, data-layer/.

## Intermediate Level (16-35)

**16. What is separation of concerns?**

Answer: Each layer or module should have one clear responsibility.

**17. What is dependency injection (DI)?**

Answer: Supplying class dependencies externally rather than creating them inside.

**18. How to implement DI?**

- React Native: Use context or providers.
- Flutter: Use get_it, riverpod, or provider.

**19. What is a domain layer in clean architecture?**

Answer: Contains entities and use cases - pure logic independent of frameworks.

**20. What is a repository pattern?**

Answer: A layer that abstracts data sources (API, local DB) from the rest of the app.

**21. How to structure an API layer?**

- React Native: /services/api.js or /network/api.ts.
- Flutter: /data/network/api_client.dart.

**22. What is a data model?**

Answer: A class representing structured app data - e.g., User, Product.

**23. How do you handle configuration files?**

- React Native: .env with react-native-config.
- Flutter: Use flutter_dotenv package.

**24. How to organize constants and utilities?**

Answer: Keep them in /core/constants/ and /core/utils/ folders.

**25. How to structure navigation?**

- React Native: /navigation/AppNavigator.js.
- Flutter: /routes/app_routes.dart.

**26. What is module decoupling?**

Answer: Making features independent so they can be developed/tested separately.

**27. How to manage app-wide themes?**

- React Native: Use a ThemeContext.
- Flutter: Define ThemeData in main.dart or provider.

**28. What is MVVM architecture?**

Answer: Model-View-ViewModel - separates UI from data and logic clearly.

**29. How to implement MVVM?**

- React Native: Components (View) + Hooks (ViewModel) + APIs (Model).
- Flutter: Widgets (View) + Bloc/Provider (ViewModel) + Repository (Model).

**30. How do you handle global app state?**

- React Native: Use Context API, Zustand, or Redux.
- Flutter: Use Riverpod or Bloc.

**31. What is modularization in architecture?**

Answer: Splitting the app into independent feature modules.

**32. How to handle offline-first architecture?**

- React Native: Combine local DB and sync service.
- Flutter: Use repositories with cache-then-network logic.

**33. How to organize tests in architecture?**

Answer:

- /test/unit/ for logic.
- /test/widget/ for UI components.
- /test/integration/ for full flows.

**34. What are the principles of a scalable architecture?**

Answer: Modularity, testability, separation, and predictable state flow.

**35. How to plan your folder layout before coding?**

Answer: Identify core features, define shared modules, then apply chosen architecture (MVC, MVVM, etc.).

## Senior Level (36-50)

**36. How do you maintain consistency across multiple developers?**

Answer: Enforce architectural guidelines, code review templates, and linting rules.

**37. How to handle app-layer communication?**

Answer: Use service interfaces or event streams between layers.

**38. How to integrate native modules cleanly?**

- React Native: Create /native/ folder and use bridge pattern.
- Flutter: Use platform channels organized in /platform/.

**39. How to ensure testability in your architecture?**

Answer: Write pure functions, use DI, and avoid singletons tightly coupled to frameworks.

**40. How to manage error handling globally?**

- React Native: Global ErrorBoundary.
- Flutter: runZonedGuarded() or FlutterError.onError.

**41. How to handle app lifecycle events structurally?**

- React Native: Use AppState listeners.
- Flutter: Implement WidgetsBindingObserver.

**42. How to integrate analytics without polluting business logic?**

Answer: Wrap analytics calls in a separate service injected into logic layers.

**43. What is event-driven architecture?**

Answer: Components communicate via events or streams instead of direct calls.

**44. How to structure multi-environment builds (dev, staging, prod)?**

- React Native: Use .env variants.
- Flutter: Use --dart-define or flavor setups.

**45. How to structure monorepo apps?**

- React Native: Use Nx or Turborepo.
- Flutter: Use Melos for multi-package management.

**46. How to integrate micro-frontend or modular features?**

- React Native: Dynamic imports or navigation-based lazy modules.
- Flutter: Use deferred imports and feature isolation.

**47. How to design an app for future scalability?**

Answer: Use clean boundaries, shared interfaces, and abstract logic from frameworks.

**48. How do you handle architectural refactors safely?**

Answer: Incrementally migrate modules, maintain tests, and run parallel old/new flows.

**49. How to document architecture decisions?**

Answer: Use ADR (Architecture Decision Record) files per major change.

**50. What's your ideal mobile app architecture?**

Answer:

- React Native: Feature-based clean architecture → Context/Service/Hook/Component layers.
- Flutter: Clean + MVVM → UI (Widget), Logic (Bloc/ViewModel), Domain (UseCase), Data (Repo/API).
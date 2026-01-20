# TOP 50 CROSS-STACK PREFERENCE INTERVIEW QUESTIONS

Senior-Level

## Framework & Language Decisions

**Why would you choose Flutter over React Native for mobile apps?**

Flutter offers consistent UI across platforms with a single Skia-rendered layer, ensuring pixel-perfect design. RN depends on native views, making UI inconsistent across Android/iOS. However, RN integrates better with native APIs and web codebases (React).

**Why might React Native be a better choice than Flutter?**

RN has better web interop, JS ecosystem support, and lower entry barriers for React devs. Flutter apps are heavier and can have slower startup times.

**How do you decide between using Dart (Flutter) and JavaScript/TypeScript (React Native)?**

Dart provides AOT compilation and performance consistency; TypeScript provides ecosystem flexibility and faster iteration cycles. For long-term maintainability and multi-platform web sharing, TS wins.

**When would you use Expo over pure React Native CLI?**

Use Expo for rapid prototyping or small-to-medium apps needing consistent configs. For enterprise-level apps with deep native dependencies, eject to bare RN or use RN CLI.

**Why might you eject from Expo?**

To integrate custom native modules, handle push notifications natively, or reduce bundle size. Expo can restrict native-level flexibility.

**Why is Flutter better for complex custom animations than React Native?**

Flutter's rendering pipeline (Skia) directly draws UI elements with 60fps control. RN bridges to native animations, causing occasional frame drops.

**Why does Flutter struggle with web performance compared to React?**

Flutter Web renders via CanvasKit/WebGL, not DOM, leading to heavy bundle sizes and less SEO. React uses the DOM natively.

**Why would you pick Next.js over Flutter Web for production web apps?**

Next.js provides SSR, SEO optimization, and smaller bundle sizes. Flutter Web is best for internal dashboards or app-like web experiences.

**In what cases would you combine React Native and Flutter in one ecosystem?**

Rare, but possible: Flutter for highly animated UI modules; RN for shared business logic with React Web.

**Why is Flutter preferred for embedded device UIs (e.g., IoT, automotive)?**

Because Flutter compiles to native ARM code and runs without a JavaScript runtime dependency.

## Architectural & Performance Considerations

**Why is React Native's bridge architecture sometimes a bottleneck?**

JS ↔ Native bridge causes async serialization overhead during frequent UI updates or animation frames.

**How does Flutter's architecture solve the bridge problem?**

Flutter eliminates bridges by compiling Dart directly into ARM code and managing UI with its own rendering engine.

**How do you reduce bundle size in React Native apps?**

Use Hermes engine, code-splitting, and minify assets. Avoid unnecessary libraries and tree-shake dead code.

**How do you reduce Flutter APK/IPA size?**

Use --split-per-abi, remove debug symbols, and strip unused assets and fonts.

**When would you use Hermes in React Native?**

For smaller app size, faster startup, and better memory efficiency—especially beneficial on low-end Android devices.

**Why might Flutter have smoother 120Hz rendering than RN?**

Its rendering engine supports higher refresh rates natively, while RN relies on OS-level rendering syncs.

**Why would you use React Native Reanimated instead of Animated API?**

Reanimated runs animations on the UI thread, avoiding JS bridge delays.

**Why might Flutter feel "heavier" on startup than RN?**

Flutter initializes its own rendering engine, whereas RN relies on the native view system.

**Why is the React Native Metro bundler sometimes slower than Flutter's build runner?**

Metro compiles JS bundles dynamically, while Flutter's AOT compilation optimizes at build time.

**Why use CodePush (AppCenter) in React Native but not in Flutter?**

RN allows JS bundle updates OTA; Flutter's compiled binaries can't update logic without full re-deployment.

## Tools, Libraries, and Ecosystem

**Why is TypeScript a must for large RN projects?**

Ensures type safety, maintainability, and cleaner contracts across complex multi-module codebases.

**Why is Flutter's ecosystem sometimes criticized?**

Some packages are immature or abandoned; RN benefits from the mature NPM ecosystem.

**Why might Flutter's DevTools outperform RN debugging tools?**

Flutter DevTools integrates with Dart VM, offering memory profiling, rebuild tracing, and frame visualization natively.

**Why would you prefer Firebase integration in Flutter vs RN?**

FlutterFire is officially maintained by Google, ensuring tighter integration. RN Firebase relies on community modules.

**Why do RN apps benefit more from modular architecture (e.g., monorepo + Lerna/Turborepo)?**

Because JS's dynamic imports allow efficient module splitting across mobile and web.

**Why might you prefer Riverpod or Bloc over Provider in Flutter?**

Riverpod and Bloc offer better scalability and testability for complex reactive flows.

**Why would you use React Query or Zustand instead of Redux in RN?**

For cleaner async management, simpler API, and reduced boilerplate.

**Why is dependency injection simpler in Flutter (GetIt) than RN?**

Dart's static typing enables compile-time validation of DI graphs.

**Why might you prefer native navigation (React Navigation vs Flutter Navigator)?**

React Navigation offers modular stack/tab management; Flutter's Navigator 2.0 supports declarative route graphs but adds verbosity.

**Why is code sharing across web and mobile easier with RN than Flutter?**

RN shares JS/TS logic with React Web; Flutter Web uses a different rendering stack.

## Cross-Platform, Web, and Desktop Decisions

**Why might you use Flutter for desktop apps instead of Electron?**

Flutter compiles to native desktop binaries; Electron ships a Chromium instance, inflating memory and size.

**Why would you pick Electron/Next.js over Flutter Desktop?**

For better web integration, SEO, and plugin maturity.

**Why is RN less suitable for desktop apps?**

RN Desktop (macOS, Windows) is still experimental and lacks official support and native plugin maturity.

**Why might you combine Flutter Web and REST API for dashboards?**

For real-time, internal tools requiring fast rendering and minimal SEO.

**Why choose Flutter for embedded screens over RN?**

Flutter can run headless or on custom engines; RN requires Android/iOS runtimes.

**Why is Flutter better suited for UI consistency in enterprise apps?**

Single rendering engine → identical UI behavior across OS versions.

**Why do RN apps look more native?**

RN wraps real native components (UIButton, View), whereas Flutter re-draws them.

**Why might Flutter outperform RN in offline-first apps?**

Dart isolates handle background tasks efficiently without blocking the main thread.

**Why is RN more maintainable for cross-platform teams?**

Shared code with React Web allows unified front-end hiring and reusable business logic.

**Why is Flutter preferred by design-heavy startups?**

The control over pixels, shaders, and animations allows perfect design parity.

## Industry-Standard Choices & Tradeoffs

**Why do large companies still choose React Native despite Flutter's speed?**

JS ecosystem maturity, shared React expertise, and extensive third-party toolchains.

**Why do startups often choose Flutter?**

Faster MVP build time, consistent UI, and strong developer experience out-of-the-box.

**What is the biggest tradeoff between React Native and Flutter?**

RN: integration flexibility but inconsistent visuals; Flutter: performance consistency but heavier footprint.

**When is React Native less ideal for real-time UIs?**

When frequent bridge crossings cause UI lag (e.g., games, live charts).

**Why would you pair React Native with Rust backend over Flutter?**

Easier API communication with JavaScript via FFI and WASM bindings.

**Why might you pick Flutter for banking/finance apps?**

Flutter's deterministic rendering ensures predictable layouts across devices.

**Why would a web-heavy team prefer React Native?**

React paradigm and JSX knowledge translate directly to mobile.

**Why is Dart less prone to runtime errors than JS/TS?**

Strong typing + AOT prevents runtime null reference issues.

**Why is Flutter CI/CD easier with Fastlane and Codemagic?**

Built-in support for Flutter workflows and automatic environment setup.

**Which framework scales better for multi-platform enterprise teams?**

React Native (JS ecosystem, monorepo tooling, web parity). Flutter wins for visual consistency and performance-critical apps.
🔗 Top 50 Questions — Native Bridging (Flutter + React Native)
⚙️ 1 – 10 : Core Concepts

What does “native bridging” mean?

The mechanism connecting JavaScript/Dart code to native Android (Java/Kotlin) and iOS (Swift/Obj-C) APIs.

How does Flutter’s bridging differ from React Native’s?

Flutter: Uses a binary PlatformChannel bridge (method/event channels).

React Native: Uses a JavaScript ↔ C++ ↔ Java/Obj-C bridge with JSON-serialized messages.

Why do we need bridging at all?

To access platform-only capabilities (Bluetooth, ARKit, sensors, permissions, etc.).

What’s the overhead difference?

RN bridge = async JSON serialization → slower.

Flutter channel = binary message codec → faster, near-native latency.

When should you write your own bridge?

When no existing package exposes required native APIs or for internal SDKs.

What language is each side written in?

Android: Kotlin/Java. iOS: Swift/Obj-C. Bridge: JS for RN, Dart for Flutter.

How do threads interact across the bridge?

Calls marshaled off-UI thread; Flutter isolates; RN uses message queues per bridge context.

Can both stacks share the same native module?

Yes, via shared Kotlin/Swift code with thin wrappers per framework.

What serialization formats are used?

Flutter: StandardMessageCodec, JSONMessageCodec, BinaryCodec.

RN: JSON objects or JSI pointers.

What’s a bridge bottleneck and how do you mitigate it?

Excessive cross-bridge calls; batch data, use streams, or cache native state.

🧱 11 – 20 : Implementing Bridges

Walk me through creating a Flutter Platform Channel.

Define const MethodChannel('channelName') in Dart.

Invoke await channel.invokeMethod('method', args).

Implement MethodChannel handler in Android (Kotlin) and iOS (Swift).

Return result → Dart Future.

Walk me through creating a RN Native Module.

Extend ReactContextBaseJavaModule.

Annotate methods with @ReactMethod.

Register module in ReactPackage.

Access via NativeModules.MyModule in JS.

How to send events from native to Flutter?

Use EventChannel → Stream in Dart.

How to send events from native to React Native?

Use DeviceEventEmitter or RCTEventEmitter with sendEvent.

How to handle async results?

Flutter: Future resolves asynchronously.

RN: Promise callbacks (resolve, reject).

What’s the equivalent of React Native’s NativeModules in Flutter?

A Dart class wrapping a MethodChannel.

How do you bridge constants?

RN: Override getConstants(). Flutter: Expose via invokeMethod('getConstants').

Explain bidirectional communication.

Dart↔Native via MethodChannel; JS↔Native via JSI or Emitter.

When should you create multiple channels?

To isolate concerns (audio, auth, storage) and avoid blocking.

How do you debug bridge calls?

Flutter: MethodChannel.setMethodCallHandler logging. RN: Flipper, console.log, native breakpoints.

🚀 21 – 30 : Performance & Memory

What’s the main performance pitfall of bridges?

Large JSON payloads crossing the JS thread.

How do you reduce serialization overhead?

Send IDs or handles instead of objects; batch updates.

How to keep bridge calls off UI thread?

RN: @ReactMethod(isBlockingSynchronousMethod = false) (default async).

Flutter: execute native logic in background thread.

How to profile bridge performance?

RN: Flipper Perf Monitor; Flutter: DevTools Timeline Events.

Can bridges handle streaming data?

Yes; use EventChannel (Flutter) or EventEmitters (RN).

What’s the max payload size recommended?

< 1 MB per message; use files or native DB for bulk data.

How to share native buffers directly?

RN JSI or TurboModules can share memory; Flutter: Platform Channels require copying.

Explain “TurboModules” in React Native.

Next-gen bridge using JSI (C++) for direct calls without serialization.

Explain “JSI” (JavaScript Interface).

C++ layer allowing JS to access native objects synchronously → zero copy.

How to handle multiple isolates/JS contexts?

Manage one bridge per context; share through message channels.

📱 31 – 40 : Platform Integration

How do you call Android Intents from Flutter?

Via MethodChannel → startActivity() in Kotlin.

How do you access Android Intents in React Native?

Create native module calling Intent APIs → expose to JS.

How do you bridge permissions?

Implement platform-specific permission check methods and invoke them over bridge.

How do you integrate native SDKs (e.g., Stripe, Firebase)?

Wrap SDK calls inside native modules/channels; expose to Dart/JS.

What’s the recommended pattern for callback listeners?

Maintain single instance → push events via EventChannel / Emitter.

How do you pass binary data (images, audio)?

Store file locally → send path; avoid sending raw bytes over bridge.

How to handle platform exceptions?

Catch native errors → return structured error object to Dart/JS.

How to use platform views (e.g., native maps)?

Flutter: PlatformViewLink / UiKitView. RN: requireNativeComponent().

How to ensure thread-safety in native modules?

Synchronize shared resources and dispatch UI updates to main thread.

How to expose Swift/Kotlin coroutines to bridge?

Flutter: async method return Future; RN: resolve Promise after coroutine completion.

🧠 41 – 50 : Advanced & Best Practices

How do you test native bridges?

Unit test native side (Kotlin/Swift) + integration test via mocked channel calls.

How do you handle versioning of native modules?

Define API contracts; expose getVersion(); use semver naming.

How do you expose synchronous methods safely?

RN: JSI only; Flutter: avoid sync methods → block UI.

How to implement callbacks from Dart/JS to native?

Pass callback IDs → store closure references → invoke on native event.

How to share data between multiple bridges?

Central native singleton managing state; channels act as proxies.

What happens on hot reload?

Flutter: Dart side rebuilds, native state persists.
RN: Bridge reloads, native modules may re-initialize.

How do you handle app lifecycle events in bridged modules?

Register Lifecycle callbacks (Android) or AppDelegate observers (iOS).

How do you integrate 3rd-party SDKs without breaking Expo?

Use Expo config plugins or eject to bare workflow.

What’s the biggest trade-off between bridging and writing a native screen?

Bridging adds latency and maintainability cost; native screen is faster but duplicated code.

What are industry best practices for bridge design?

Keep APIs minimal and typed; use async patterns; avoid large payloads; document contracts.

✅ Senior Insights to Drop in Interviews

Prefer high-level community packages; write custom bridges only when needed.

Avoid chatty bridge patterns — batch calls and minimize round-trips.

Use JSI (TurboModules) for React Native and Platform Channels for Flutter 2 +.

Benchmark bridge overhead early if targeting real-time apps (streaming, AR, IoT).

Wrap native errors into typed objects for cross-stack consistency.
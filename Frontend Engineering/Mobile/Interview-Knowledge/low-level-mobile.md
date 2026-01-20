🧩 Top 50 Low-Level Mobile Interaction Questions & Answers
🔧 General Concepts (1 – 10)

What is low-level mobile programming?
Direct interaction with platform APIs (Bluetooth, camera, file I/O, threads) below the framework layer.

Why go low-level instead of using SDK widgets?
For performance, access to hardware, or features not yet exposed in high-level frameworks.

What’s the difference between native modules and FFI?
FFI calls C/C++ directly; native modules wrap platform APIs through language bridges.

When do you prefer FFI over an HTTP or JS bridge?
When data transfer overhead must be minimal—e.g., real-time audio or video.

How do you reduce overhead in cross-platform bridges?
Batch data, minimize context switches, serialize compactly (protobuf or binary blobs).

What’s the impact of crossing the JS/Dart–native boundary too often?
Increases frame latency; combine small calls into fewer, larger operations.

What are common low-level bottlenecks?
I/O blocking, GC pauses, unoptimized image decode, and excessive JNI/FFI calls.

Which tools help profile low-level performance?
Android Studio Profiler, Instruments, systrace, flutter devtools, Flipper.

Why handle threads manually at low level?
To keep UI thread responsive and leverage multiple cores for compute tasks.

How do you share memory safely between native and framework layers?
Use immutable buffers or copy-on-write patterns; never share mutable raw pointers.

🤖 Android-Specific (11 – 20)

How do you call C/C++ from Kotlin/Java?
Via JNI (Java Native Interface) and the Android NDK toolchain.

When is NDK necessary?
For performance-critical code, codecs, image processing, or proprietary C libs.

What is AIDL used for?
Android Interface Definition Language—IPC between processes or services.

How do you access sensors at low level?
Through SensorManager, or directly from NDK sensor APIs for faster sampling.

Why use WorkManager over raw threads?
Handles OS constraints, background limits, and survives reboots.

How do you manage native memory leaks on Android?
Use Address Sanitizer, LeakCanary, and ensure DeleteLocalRef in JNI.

Explain Binder in Android.
System IPC mechanism—used internally by services; too low-level for most apps but core to AIDL.

How do you reduce JNI call overhead?
Cache method IDs, reuse objects, and minimize crossing boundaries.

What’s the role of the Looper and Handler threads?
Message queue mechanism for asynchronous execution tied to thread context.

When to use the NDK Camera API vs CameraX?
Use NDK for low-latency preview or computer-vision pipelines.

🍎 iOS-Specific (21 – 30)

How is Objective-C bridging different from Swift bridging?
Swift offers safer type handling; both expose C interfaces to higher layers.

When would you write a native iOS plugin?
For frameworks unavailable in Flutter/React Native—ARKit, CoreBluetooth, or low-latency audio.

What is CoreFoundation used for?
Low-level C-based APIs for memory, sockets, run loops.

How do you handle threading in iOS natively?
Using GCD (Grand Central Dispatch) or NSOperationQueue.

What’s Metal and when use it?
Apple’s low-level GPU API—used for high-performance graphics or ML.

How do you detect memory leaks on iOS?
Instruments → Leaks / Allocations, or Xcode Memory Graph.

How does autoreleasepool affect low-level memory?
Collects temporary objects—wrap heavy loops in your own pool for control.

What’s the role of CoreBluetooth at low level?
Direct BLE peripheral/central control and packet management.

How to communicate with background threads in iOS safely?
Use dispatch queues and always update UI on main thread.

How to package C/C++ libraries for iOS?
Build static .a or dynamic .framework libs and link via Xcode build phases.

🐦 Flutter-Specific (31 – 40)

How does Flutter talk to native code?
Through MethodChannel, EventChannel, or BasicMessageChannel.

When is Dart FFI preferable?
When interacting with C libraries directly without going through platform channels.

How do you prevent blocking the UI isolate?
Use compute(), secondary isolates, or background platform threads.

What’s PlatformView used for?
Embedding native UI components inside Flutter widget tree.

How do you pass large binary data between Flutter and native?
Via shared memory or file references, not JSON.

How to debug native crashes from Flutter code?
Use flutter run --verbose, inspect adb logcat or Xcode logs.

What’s the benefit of using federated plugins?
Separate interface + per-platform implementations, enabling modular maintenance.

How do you register native plugins manually?
Call GeneratedPluginRegistrant.registerWith() or platform-specific registrants.

When do you use FFI over platform channels?
For pure C libraries needing speed (e.g., compression, crypto).

How do you handle background tasks in Flutter natively?
Use WorkManager (Android) or BackgroundFetch (iOS) plugins, bridged to native schedulers.

⚛️ React Native-Specific (41 – 50)

How does React Native bridge JS to native?
Via JSI (JavaScript Interface) and TurboModules (modern RN architecture).

What’s the difference between JSI and old Bridge?
JSI is synchronous and C++-based—faster, less serialization overhead.

When do you write a custom native module?
When no existing library covers a native feature or for performance-critical use.

How to handle multithreading in React Native native modules?
Use @ReactMethod(isBlockingSynchronousMethod = true) carefully; offload heavy work to background threads.

How do you expose native constants to JS?
Return a Map from getConstants() in the module.

What’s Fabric in React Native?
New rendering system integrated with JSI for concurrent UI and better performance.

How do you manage native dependencies for iOS in RN?
Through CocoaPods (Podfile)—keep versions locked.

How do you manage native dependencies for Android in RN?
Through Gradle (build.gradle) with explicit version catalog or constraints.

What tools debug low-level RN native issues?
Flipper, Android Studio Profiler, Xcode Instruments, and native logcat/syslog.

When would you use C++ in React Native?
For shared business logic or algorithms accessed from both Android & iOS via JSI.

🧭 Senior Takeaways

Bridging is communication; low-level work is execution near hardware.

Only go native when performance, security, or hardware access justify the cost.

Use profiling before optimizing.

Keep FFI and native modules minimal, well-documented, and testable.

Cross-platform ≠ abstract everything—some power lives at the metal.


🧩 Low-level mobile interaction vs Native bridging
Concept	Description |Typical Use Cases |	Example Stacks
Low-Level Mobile Interaction	Directly interfacing with platform-level APIs (Android NDK, iOS Core frameworks, Bluetooth, NFC, memory, threads, sensors). Done via native languages like Kotlin/Swift/Obj-C/C++. |	Hardware control, system performance tuning, encryption, camera drivers, audio processing, GPU calls.|	Writing JNI modules, iOS frameworks, or using Dart FFI in Flutter|.
Native Bridging	Creating a communication bridge between high-level (Dart/JS) and native code (Swift/Kotlin/Obj-C). It’s an abstraction that exposes low-level functionality to the app.|	Accessing native features not available in SDKs or third-party libs. |	React Native NativeModules, Flutter MethodChannel / FFI.|
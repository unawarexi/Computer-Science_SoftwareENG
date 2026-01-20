⚙️ TOP 50 — BUILD & DEPLOYMENT CONFIGURATIONS (React Native & Flutter)
🧱 ENVIRONMENT CONFIGURATIONS

How would you set up and explain the flow of environment-based builds (dev, staging, prod)?

Flutter: Use --dart-define=ENV=staging; create flavor directories in lib/env/.

React Native: Use .env + react-native-config or Expo build profiles (eas.json).

Flow: Switch API URLs, analytics keys, and signing configs dynamically.

Walk me through how you’d manage sensitive environment variables in CI/CD.

Never commit .env.

Store secrets in GitHub Actions Secrets, Bitrise, or EAS Secrets.

Inject at build time (e.g., --dart-define, or $ENVFILE).

How would you structure your app to separate environment-specific dependencies?

Use feature flags or dependency injection (e.g., Provider, Riverpod).

In RN, conditionally import configs via process.env.

What’s the purpose of using build flavors (Flutter) or build variants (RN Android)?

Define multiple product configurations (app IDs, icons, package names).

Useful for staging vs production.

Explain how you’d automate builds for each environment.

Define separate workflows in CI/CD (build_staging.yml, build_prod.yml).

Use branch-based condition triggers.

🔐 SIGNING, KEYSTORES & CERTIFICATES

How would you generate and configure an Android keystore?

keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release


Place in android/app/, reference in build.gradle.

Keep password in CI secret.

How do you set up signingConfigs in Gradle for multiple flavors?

signingConfigs {
    release {
        storeFile file(System.getenv("KEYSTORE_PATH"))
        storePassword System.getenv("KEYSTORE_PASS")
        keyAlias System.getenv("KEY_ALIAS")
        keyPassword System.getenv("KEY_PASS")
    }
}


How do iOS certificates and provisioning profiles differ from Android keystores?

Android: Developer-signed (static key).

iOS: Apple-issued certificate + provisioning profile ties device, app ID, and developer.

When would you need to regenerate a provisioning profile?

New device, new cert, or bundle identifier change.

How do you manage iOS signing for CI/CD?

Use Fastlane Match, Expo EAS, or Xcode automatic signing.

⚙️ BUILD CONFIGURATIONS

Explain how build.gradle structures build types and product flavors.

buildTypes = debug/release.

productFlavors = env-specific variants.

Combine both for matrix builds.

What’s the difference between Gradle and Cocoapods in mobile builds?

Gradle: Android dependency and build automation.

Cocoapods: iOS dependency management.

How would you enable ProGuard or R8 for code obfuscation?

Android: minifyEnabled true + proguard-rules.pro.

Flutter adds automatically for release.

How do you define build outputs in Flutter vs RN?

Flutter: flutter build apk/ipa --release.

RN: gradlew assembleRelease / xcodebuild.

Walk me through how you’d add versioning to your build process.

Update versionCode (Android) and CFBundleVersion (iOS) via scripts or CI variables.

🧩 CI/CD PIPELINES

How would you structure a CI/CD pipeline for React Native or Flutter?

Steps: Checkout → Install deps → Run tests → Build → Sign → Deploy.

Tools: GitHub Actions, Bitrise, Codemagic, EAS Build.

What CI/CD services are most compatible with RN and Flutter?

RN: EAS Build, Fastlane, Bitrise.

Flutter: Codemagic, GitHub Actions, CircleCI.

How would you automate version bumping in CI/CD?

Use scripts to increment versions based on Git tags or semantic versioning.

Walk me through handling OTA updates in React Native.

Use Expo OTA Updates or CodePush.

Upload JS bundle to update users without re-submitting to stores.

How would you automate Flutter build distribution to TestFlight or Play Store?

Fastlane lanes (deliver, supply) or Codemagic publish.

Integrate with GitHub Actions for branch triggers.

🌐 NETWORK & RUNTIME CONFIGS

How would you manage API base URLs across environments?

.env files or --dart-define.

Avoid hardcoding endpoints in code.

Why use app bundles (.aab) over APKs?

Smaller, optimized builds per device configuration.

Explain how Hermes and Dart AOT compilation improve performance.

Hermes: Precompiles JS to bytecode for RN.

Dart AOT: Compiles Dart to native machine code for faster startup.

What’s the role of a metro.config.js or pubspec.yaml during build?

Metro: JS bundler config for RN.

Pubspec: Flutter dependency and asset registry.

How do you manage dependency caching in CI/CD?

Cache node_modules or .pub-cache.

Use version hashes for invalidation.

🚀 DISTRIBUTION & DEPLOYMENT

How would you automate store submission?

Fastlane supply (Android) and deliver (iOS).

Automate screenshots, metadata, changelogs.

What’s your strategy for internal app testing builds?

Flutter: Firebase App Distribution or Codemagic testers.

RN: Expo EAS internal or TestFlight.

How would you set up staged rollouts for production apps?

Google Play staged rollout %; Apple phased release; or feature flags.

How do you handle OTA version mismatches in React Native?

Implement version validation before applying updates.

What’s the difference between debug, profile, and release modes in Flutter?

Debug: Hot reload, asserts.

Profile: Performance tracing.

Release: Optimized binary.

🛠️ BUILD OPTIMIZATION & TOOLS

How would you shrink Flutter app size?

Split APKs (--split-per-abi), remove debug symbols, use LTO.

How would you optimize RN bundle size?

Enable Hermes, use dynamic imports, clean unused dependencies.

What’s the purpose of a .bundle file in RN iOS?

Compiled JS and assets packaged for production.

How do you ensure deterministic builds?

Lockfile versioning (package-lock.json / pubspec.lock) and pinned toolchain.

Explain code signing verification at runtime.

Ensures binary wasn’t tampered with before execution.

🧰 MISCELLANEOUS CONFIGURATIONS

How do you manage multiple app icons and splash screens for flavors?

Flutter: flutter_launcher_icons & flutter_native_splash with per-flavor configs.

RN: Use react-native-set-splash-screen, asset directories per flavor.

How do you automate changelog generation?

Git commit parsing (Conventional Commits) + CI script.

How would you set up crash reporting for builds?

Flutter: firebase_crashlytics.

RN: @react-native-firebase/crashlytics or Sentry.

How do you integrate analytics per environment?

Env-based API keys for GA4, Mixpanel, or Segment.

How would you verify build integrity post-deployment?

Verify SHA256 hash or App Store-provided signature.

🧮 TEST & VALIDATION BUILDS

How would you configure automated UI tests in CI?

Flutter: integration_test package.

RN: Detox or Appium.

How do you ensure test builds mimic production environments?

Use staging configs, mock sensitive services.

How do you handle build failures due to dependency conflicts?

Lock versions, use Gradle’s dependency resolution strategy.

How do you implement rollback for a bad production build?

OTA (CodePush) rollback or previous release redeploy.

What’s your strategy for artifact retention in CI/CD?

Store .apk/.ipa as build artifacts for traceability.

🪶 ADVANCED DEPLOYMENT STRATEGIES

How would you set up blue-green or canary deployments for mobile?

Feature flagging + staged release rollout.

What are universal binaries, and when are they needed?

iOS: ARM64 + x86_64 (for simulators).

Required for full device/simulator compatibility.

How do you handle architecture-specific builds in Android?

ndk.abiFilters for armeabi-v7a, arm64-v8a.

What’s the difference between EAS Build and local builds?

EAS = cloud-based managed build + signing + upload.

Local = manual control, full environment access.

How do you maintain reproducible builds across developers?

Pin Flutter/Dart versions (fvm), Expo SDK, Node versions.

Use .nvmrc, .tool-versions, and lockfiles.


# Top 50 Senior Interview Questions & Answers: Flutter vs React Native Render Engines & OEM Rendering

## Fundamentals & Architecture (1-10)

1. **What rendering engine does Flutter use?**
	- Flutter uses Skia, a high-performance 2D graphics engine bundled with every app.

2. **How does React Native render UI components?**
	- React Native translates JavaScript/JSX into native OEM widgets (UIKit for iOS, Views for Android).

3. **Does Flutter use native OEM widgets?**
	- No, Flutter draws all UI components itself for consistency across platforms.

4. **What is the role of the bridge in React Native?**
	- The bridge serializes UI changes from JS and sends them to the native side for rendering.

5. **How does Flutter achieve pixel-perfect UI?**
	- By bypassing native toolkits and drawing directly to the platform’s canvas using Skia.

6. **What is the Widget Layer in Flutter?**
	- It’s the Dart code that describes the UI as a widget tree.

7. **How does React Native handle layout calculations?**
	- Layout is calculated in JS and then applied to native views via the bridge.

8. **What is the Render Object Layer in Flutter?**
	- It handles layout and painting, sending drawing commands to Skia.

9. **How does React Native achieve a native look and feel?**
	- By using the platform’s native controls/widgets for rendering.

10. **What is the main architectural difference between Flutter and React Native rendering?**
	- Flutter draws everything itself; React Native delegates rendering to the platform’s native UI toolkit.

## Rendering Pipeline & Performance (11-20)

11. **Describe Flutter’s rendering pipeline.**
	- Widget Layer → Element Layer → Render Object Layer → Skia Engine → Platform canvas.

12. **Describe React Native’s rendering pipeline.**
	- JS Thread → Bridge → Native Thread → OEM Renderer (UIKit/Android Views).

13. **How does Flutter maintain high frame rates (60/120fps)?**
	- By controlling the entire rendering pipeline and minimizing platform overhead.

14. **What can cause jank in React Native animations?**
	- Bridge latency, heavy JS computations, or slow native updates.

15. **How does Flutter handle screen redraws?**
	- It only redraws widgets that need updating, optimizing performance.

16. **How does React Native optimize performance for animations?**
	- By using native drivers and minimizing bridge communication.

17. **What is the impact of the bridge on React Native performance?**
	- It can become a bottleneck, especially for frequent or complex UI updates.

18. **How does Flutter handle GPU acceleration?**
	- Skia uses OpenGL, Metal, or Vulkan for hardware-accelerated rendering.

19. **How does React Native leverage the GPU?**
	- Native views are rendered by the platform’s GPU-accelerated renderer.

20. **Which framework offers more consistent performance across devices?**
	- Flutter, due to its custom rendering engine and control over the pipeline.

## OEM Specifics & Platform Integration (21-30)

21. **How does Flutter access platform-specific features?**
	- Through platform channels that bridge Dart and native code.

22. **How does React Native access OEM APIs?**
	- Via native modules written in Java/Kotlin (Android) or Obj-C/Swift (iOS).

23. **Can Flutter apps look exactly like native apps?**
	- Yes, but it requires custom theming and mimicking native behaviors.

24. **Can React Native apps look different on iOS and Android?**
	- Yes, since they use native widgets, the look and feel can vary by platform.

25. **How does Flutter handle accessibility?**
	- Developers must manually implement accessibility features; not all are automatic.

26. **How does React Native handle accessibility?**
	- Leverages the platform’s native accessibility APIs for better out-of-the-box support.

27. **How does Flutter handle device-specific rendering quirks?**
	- By drawing everything itself, it avoids most OEM quirks but must handle device pixel ratios.

28. **How does React Native handle device-specific quirks?**
	- Relies on the platform’s native rendering, inheriting both strengths and quirks.

29. **How does Flutter integrate with OEM navigation and gestures?**
	- Uses platform channels and plugins for deep integration.

30. **How does React Native integrate with OEM navigation and gestures?**
	- Uses native modules and third-party libraries for navigation and gesture handling.

## Advanced Topics & Edge Cases (31-40)

31. **How does Flutter support custom shaders or graphics?**
	- Through CustomPainter and FragmentShader APIs.

32. **How does React Native support custom graphics?**
	- Via native modules or libraries like react-native-svg and GLView.

33. **How does Flutter handle screen density and scaling?**
	- Uses logical pixels and device pixel ratio to scale UI appropriately.

34. **How does React Native handle screen density?**
	- Relies on the platform’s native scaling mechanisms.

35. **How does Flutter render on web and desktop?**
	- Uses Skia for desktop, and HTML/CSS or CanvasKit for web.

36. **How does React Native render on web and desktop?**
	- Uses React Native Web for web (maps to HTML/CSS), and Electron or other wrappers for desktop.

37. **How does Flutter handle hot reload?**
	- By updating the widget tree and re-rendering only changed widgets.

38. **How does React Native handle hot reload?**
	- By reloading JS bundles and updating native views as needed.

39. **How does Flutter support animations at the engine level?**
	- AnimationController and Ticker drive frame updates directly in the engine.

40. **How does React Native support animations at the engine level?**
	- Uses Animated API, native drivers, and sometimes relies on third-party libraries for smoothness.

## Pros, Cons & Best Practices (41-50)

41. **What are the main pros of Flutter’s rendering approach?**
	- Consistent UI, high performance, full control over every pixel.

42. **What are the main cons of Flutter’s rendering approach?**
	- Larger app size, more manual work for native look, accessibility, and integration.

43. **What are the main pros of React Native’s rendering approach?**
	- Native look and feel, smaller app size, easier platform integration.

44. **What are the main cons of React Native’s rendering approach?**
	- UI consistency varies, bridge can bottleneck, custom UI needs native code.

45. **When should you choose Flutter over React Native for rendering?**
	- When you need consistent UI, custom graphics, or want to target multiple platforms with one codebase.

46. **When should you choose React Native over Flutter for rendering?**
	- When you want native look and feel, smaller app size, or deep OEM integration.

47. **How do you debug rendering issues in Flutter?**
	- Use Flutter DevTools, Performance Overlay, and widget inspector.

48. **How do you debug rendering issues in React Native?**
	- Use Flipper, Chrome DevTools, and native platform debuggers.

49. **What is the future direction for Flutter’s rendering engine?**
	- Continued optimization, better web/desktop support, and improved accessibility.

50. **What is the future direction for React Native’s rendering engine?**
	- New architectures like Fabric, TurboModules, and improved bridge performance for smoother UI.

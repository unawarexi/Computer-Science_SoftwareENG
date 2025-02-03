import 'package:flutter/material.dart';
import 'package:flutter_course/screens/onboarding/onboarding_screen.dart';
import 'package:get/route_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/onboarding":
            return MaterialPageRoute(
                builder: (context) => const OnboardingScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const OnboardingScreen());
        }
      },
    );
  }
}

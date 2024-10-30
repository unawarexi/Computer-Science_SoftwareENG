import 'package:flutter/material.dart';
import 'package:flutter_course/flutter/layouts/first_screen.dart';
import 'package:flutter_course/flutter/widgets/onboarding.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.system,
        home: const Onboarding(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/onboarding":
              return MaterialPageRoute(
                  builder: (context) => const Onboarding());
            case "/home":
              return MaterialPageRoute(builder: (context) => FirstScreen());
            default:
              return MaterialPageRoute(
                  builder: (context) => const Onboarding());
          }
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dart_course/screens/auth_screens/auth_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("onbaording screen"),
      ),
      body: Center(
        child: Column(children: [
          const Text("click the button to view topics"),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text("click to view"))
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_course/flutter/widgets/onboarding.dart'; // Importing Onboarding screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Onboarding(), // Set the Onboarding screen as the home page
    );
  }
}

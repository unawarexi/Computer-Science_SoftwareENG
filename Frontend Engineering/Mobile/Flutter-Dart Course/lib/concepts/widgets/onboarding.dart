import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

//------------- using name routes to navigate to the next screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Let\'s get started by setting up your preferences.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            // Using the DynamicButton for the first action
            DynamicButton(
              onPressed: () => Navigator.pushNamed(context, "/Home"),
              label: 'See projects',
            ),
            const SizedBox(height: 20),
            // Using the DynamicButton for another action
            DynamicButton(
              onPressed: () => Navigator.pushNamed(context, "/concepts"),
              label: 'learn concepts',
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const DynamicButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

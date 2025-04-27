// animation.dart
import 'package:flutter/material.dart';

void animateToRouteScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Smooth fade-in transition
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

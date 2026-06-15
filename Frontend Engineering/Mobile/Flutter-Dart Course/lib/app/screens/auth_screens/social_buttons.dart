import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignInButton.mini(
          buttonType: ButtonType.google,
          onPressed: () {
            // Handle Google sign up
          },
        ),
        const SizedBox(width: 12),
        SignInButton.mini(
          buttonType: ButtonType.facebook,
          onPressed: () {
            // Handle Facebook sign up
          },
        ),
        const SizedBox(width: 12),
        SignInButton.mini(
          buttonType: ButtonType.apple,
          onPressed: () {
            // Handle Apple sign up
          },
        ),
      ],
    );
  }
}
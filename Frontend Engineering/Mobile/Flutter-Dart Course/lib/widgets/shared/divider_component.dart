import 'package:flutter/material.dart';

class DividerComponent extends StatelessWidget {
  const DividerComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.0, // Set the height of the line
      color: Colors.grey[300], // Set the background color to grey
    );
  }
}

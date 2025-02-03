import 'package:flutter/material.dart';
import 'package:flutter_course/layouts/authscreen_layout.dart';
import 'package:flutter_course/widgets/shared/divider_component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search bar with an icon to the left
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align the category text to the start (left)
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 30), // Space between category label and row
                    Row(
                      children: [
                        _buildCategoryItem("All"),
                        const SizedBox(width: 30),
                        _buildCategoryItem("Food"),
                        const SizedBox(width: 30),
                        _buildCategoryItem("Drink"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              //---------------- divider
              const DividerComponent(),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to style each category item
Widget _buildCategoryItem(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    decoration: BoxDecoration(
      color: Colors.grey[300], // Background color for category items
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey),
    ),
  );
}

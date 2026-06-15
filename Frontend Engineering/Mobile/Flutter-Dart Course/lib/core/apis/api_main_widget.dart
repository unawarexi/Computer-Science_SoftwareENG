// api_main_widget.dart (Main File)
import 'package:flutter/material.dart';
import 'package:flutter_dart_course/apis/api_header.dart';
import 'package:flutter_dart_course/apis/using_dio.dart';
import 'package:flutter_dart_course/apis/search_bar.dart' as api_search_bar;


class ApiMainWidget extends StatefulWidget {
  const ApiMainWidget({super.key});

  @override
  State<ApiMainWidget> createState() => _ApiMainWidgetState();
}

class _ApiMainWidgetState extends State<ApiMainWidget> {
  final String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  
  void onCategorySelected(String category) {
    // This will be implemented to filter meals based on category
    print('Selected category: $category');
    // Update state in child components as needed
  }

  void onSearch(String query) {
    // This will be implemented to filter meals based on search
    print('Search query: $query');
    // Update state in child components as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[700],
        title: const Text(
          'Food Delight',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://themealdb.com/images/icons/meal-icon6.png'),
              backgroundColor: Colors.white,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Welcome Header with Greeting
          const WelcomeHeader(),
          
          // Search Bar
         api_search_bar.SearchBar(
            controller: searchController,
            onSearch: onSearch,
          ),
          
          // // Categories Horizontal Slider
          // CategoriesSlider(
          //   onCategorySelected: onCategorySelected,
          // ),
          
          // Main Content - ApiUsingDio with modifications
          const Expanded(
            child: ApiUsingDio(),
          ),
        ],
      ),
    );
  }
}

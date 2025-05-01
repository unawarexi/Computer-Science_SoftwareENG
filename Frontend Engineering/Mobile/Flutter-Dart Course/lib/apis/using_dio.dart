import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ApiUsingDio extends StatefulWidget {
  const ApiUsingDio({super.key});

  @override
  State<ApiUsingDio> createState() => _ApiUsingDioState();
}

class _ApiUsingDioState extends State<ApiUsingDio> {
  final String categoriesApiUrl = 'https://themealdb.com/api/json/v1/1/categories.php';
  final String filterMealsBaseUrl = 'https://themealdb.com/api/json/v1/1/filter.php?c=';
  final Dio dio = Dio();
  
  List<dynamic> categories = [];
  List<dynamic> meals = [];
  String selectedCategory = 'All';
  bool isLoadingCategories = true;
  bool isLoadingMeals = true;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> getCategories() async {
    setState(() {
      isLoadingCategories = true;
    });
    
    try {
      final response = await dio.get(categoriesApiUrl);
      if (response.statusCode == 200) {
        setState(() {
          categories = response.data['categories'];
          isLoadingCategories = false;
          
          // Initialize with the first category (Beef)
          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['strCategory'];
            getMealsByCategory(selectedCategory);
          }
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> getMealsByCategory(String category) async {
    setState(() {
      isLoadingMeals = true;
    });
    
    try {
      final response = await dio.get('$filterMealsBaseUrl$category');
      if (response.statusCode == 200) {
        setState(() {
          meals = response.data['meals'] ?? [];
          isLoadingMeals = false;
        });
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Error loading meals: $e');
      setState(() {
        isLoadingMeals = false;
        meals = [];
      });
    }
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    getMealsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: isLoadingCategories
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            )
          : Column(
              children: [
                // Categories Horizontal Slider (Merged from carousel_slider.dart)
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryName = category['strCategory'];
                      final isSelected = categoryName == selectedCategory;
                      
                      return GestureDetector(
                        onTap: () {
                          onCategorySelected(categoryName);
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red[400] : Colors.amber[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ] : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  category['strCategoryThumb'],
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                categoryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.amber[900],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Meals Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$selectedCategory Meals',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.sort, color: Colors.amber[800]),
                        label: Text(
                          'Sort',
                          style: TextStyle(color: Colors.amber[800]),
                        ),
                      ),
                    ],
                  ),
                ),

                // Meals List
                Expanded(
                  child: isLoadingMeals
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        )
                      : meals.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant_menu,
                                    size: 60,
                                    color: Colors.amber[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No meals found for $selectedCategory',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: meals.length,
                              padding: const EdgeInsets.only(bottom: 16.0),
                              itemBuilder: (context, index) {
                                final meal = meals[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          meal['strMealThumb'],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      meal['strMeal'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.red[400],
                                                      size: 20,
                                                    ),
                                                    onPressed: () {},
                                                    constraints: const BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber[100],
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      selectedCategory,
                                                      style: TextStyle(
                                                        color: Colors.amber[900],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[100],
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.star, color: Colors.red[700], size: 12),
                                                        const SizedBox(width: 2),
                                                        Text(
                                                          '4.5',
                                                          style: TextStyle(
                                                            color: Colors.red[700],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time, color: Colors.grey[600], size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '25-30 min',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Icon(Icons.local_fire_department, color: Colors.amber[700], size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '320 cal',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
    );
  }
}
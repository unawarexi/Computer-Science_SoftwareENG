import 'package:flutter/material.dart';
import 'package:flutter_course/concepts/animation/animation.dart'; // Import animation logic
import 'package:flutter_course/maps/components/display_map.dart';
import 'package:flutter_course/maps/components/search_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import RouteScreen

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double initialChildSize = 0.4; // Initial middle height (40%)
  double thresholdForRouteScreen = 0.7; // Threshold to push RouteScreen
  bool routeScreenPushed = false; // Prevent multiple pushes of RouteScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Placeholder for Map
          const Center(
            child: DisplayMap(
              pickupLocation:
                  LatLng(40.712776, -74.005974), // Example locations
              dropoffLocation: LatLng(40.730610, -73.935242),
            ),
          ),

          // Bottom Sheet with Sliding Functionality
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  // Function to build the Bottom Sheet
  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      snap: true, // Snap to nearest position
      initialChildSize: initialChildSize, // Middle height (40%)
      minChildSize: 0.1, // Minimum height (only search bar)
      maxChildSize: 0.8, // Maximum height (80% of the screen)
      snapSizes: const [0.1, 0.4, 0.8], // Snap sizes at 10%, 40%, and 80%
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double currentHeight =
                constraints.maxHeight / MediaQuery.of(context).size.height;

            // Push the RouteScreen if the bottom sheet is above the threshold (70% height)
            if (currentHeight > thresholdForRouteScreen && !routeScreenPushed) {
              routeScreenPushed = true;
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  setState(() {
                    animateToRouteScreen(context, const RouteScreen());
                  });
                }
              });
            }

            return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6F8), // Very light blue, almost white
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Bar Widget
                  _buildSearchBar(),

                  const SizedBox(height: 10.0),

                  // Show Previous Locations only if the height is greater than 30% of the screen
                  if (currentHeight >= 0.3)
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          _buildPreviousLocationItem(
                              'Home', '123 Main St', Colors.blue),
                          _buildPreviousLocationItem(
                              'Work', '456 Office St', Colors.green),
                          _buildPreviousLocationItem(
                              'Gym', '789 Fitness St', Colors.red),
                          _buildPreviousLocationItem(
                              'Supermarket', '321 Market St', Colors.orange),
                        ],
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // Trigger the animated route transition
        animateToRouteScreen(context, const RouteScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.blue),
            SizedBox(width: 10.0),
            Text(
              'Where to?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building previous location items
  Widget _buildPreviousLocationItem(
      String title, String address, Color boxColor) {
    return ListTile(
      leading: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius:
              BorderRadius.circular(10.0), // Boxy with rounded corners
        ),
        child: const Icon(Icons.history, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0, // Bigger text size
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        address,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        // Handle location selection
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_course/maps/components/display_map.dart';
import 'package:flutter_course/payments/payment_screen.dart';
import 'package:flutter_course/concepts/state_management/get_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class DisplayPriceAndDistance extends StatefulWidget {
  const DisplayPriceAndDistance({super.key});

  @override
  State<DisplayPriceAndDistance> createState() =>
      _DisplayPriceAndDistanceState();
}

class _DisplayPriceAndDistanceState extends State<DisplayPriceAndDistance> {
  final RouteController routeController = Get.find<RouteController>();
  String selectedVehicle = 'car'; // Default selected vehicle
  double pricePerKm = 2.0; // Default price per km (can vary by vehicle type)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (routeController.pickupLocation.value == null ||
            routeController.dropoffLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng pickupLocation = routeController.pickupLocation.value!;
        LatLng dropoffLocation = routeController.dropoffLocation.value!;

        // Calculate distance and price dynamically
        double distance = _calculateDistance(pickupLocation, dropoffLocation);
        double price = _calculatePrice(distance);

        return Stack(
          children: [
            // Display the map
            Center(
              child: DisplayMap(
                pickupLocation: pickupLocation,
                dropoffLocation: dropoffLocation,
              ),
            ),
            // Bottom Sheet displaying price, distance, and options
            _buildPriceAndDistanceModal(distance, price),
          ],
        );
      }),
    );
  }

  // Bottom Sheet for Price and Distance
  Widget _buildPriceAndDistanceModal(double distance, double price) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormattedPriceAndDistance(distance, price),
            const SizedBox(height: 20),
            _buildVehicleSelection(),
            const SizedBox(height: 20),
            _buildSelectRideButton(),
          ],
        ),
      ),
    );
  }

  // Display formatted price and distance
  Widget _buildFormattedPriceAndDistance(double distance, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Price: \$${price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Distance: ${distance.toStringAsFixed(2)} km',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Vehicle selection options
  Widget _buildVehicleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVehicleOption('Car', 'car', Icons.directions_car, 2.0),
        _buildVehicleOption('Bike', 'bike', Icons.motorcycle, 1.0),
        _buildVehicleOption('Truck', 'truck', Icons.local_shipping, 3.0),
        _buildVehicleOption('Special', 'special', Icons.car_rental, 5.0),
      ],
    );
  }

  // Individual vehicle option widget
  Widget _buildVehicleOption(
      String label, String value, IconData icon, double pricePerKm) {
    bool isSelected = selectedVehicle == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVehicle = value;
          this.pricePerKm = pricePerKm; // Update price per km based on vehicle
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.black),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // "Select Ride" button
  Widget _buildSelectRideButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _navigateToPayment();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Select Ride',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Navigate to payment page
  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371.0; // Earth's radius in km
    double dLat = _toRadians(end.latitude - start.latitude);
    double dLon = _toRadians(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) *
            cos(_toRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  // Convert degrees to radians
  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Calculate price based on distance and vehicle type
  double _calculatePrice(double distance) {
    return distance * pricePerKm;
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_course/concepts/maps/components/display_map.dart';
// import 'package:flutter_course/concepts/payments/payment_screen.dart';
// import 'package:flutter_course/concepts/state_management/getX.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class DisplayPriceAndDistance extends StatefulWidget {
//   const DisplayPriceAndDistance({super.key});

//   @override
//   State<DisplayPriceAndDistance> createState() =>
//       _DisplayPriceAndDistanceState();
// }

// class _DisplayPriceAndDistanceState extends State<DisplayPriceAndDistance> {
//   final RouteController routeController = Get.find<RouteController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (routeController.pickupLocation.value == null ||
//             routeController.dropoffLocation.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         LatLng pickupLocation = routeController.pickupLocation.value!;
//         LatLng dropoffLocation = routeController.dropoffLocation.value!;

//         // Calculate distance and price based on pickup and dropoff location
//         double distance = _calculateDistance(pickupLocation, dropoffLocation);
//         double price = _calculatePrice(distance);

//         return Stack(
//           children: [
//             // Display the map with pickup and drop-off locations
//             Center(
//               child: DisplayMap(
//                 pickupLocation: pickupLocation,
//                 dropoffLocation: dropoffLocation,
//               ),
//             ),
//             // Display price and distance info
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: _buildPriceAndDistanceModal(price, distance),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   // Dummy distance calculation function (replace with real calculation)
//   double _calculateDistance(LatLng pickup, LatLng dropoff) {
//     // Here, you can use the Haversine formula or any package to calculate distance
//     return 10.0; // Mocked distance in km
//   }

//   // Dummy price calculation function (replace with real calculation)
//   double _calculatePrice(double distance) {
//     return distance * 2.0; // Mocked price per km
//   }

//   // Widget to build the bottom modal with price and distance
//   Widget _buildPriceAndDistanceModal(double price, double distance) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Price: \$${price.toStringAsFixed(2)}',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'Distance: ${distance.toStringAsFixed(2)} km',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to payment page
//               _navigateToPayment();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               'Select Ride',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Navigation to Payment Page
//   void _navigateToPayment() {
//     // Placeholder for actual navigation to the payment screen
//     Get.to(() => const PaymentScreen());
//   }
// }

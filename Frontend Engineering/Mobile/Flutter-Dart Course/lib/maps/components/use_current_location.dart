import 'package:flutter/material.dart';
import 'package:flutter_course/maps/maps.dart'; // Adjust this import for your actual Maps class
import 'package:location/location.dart';
import 'package:get/get.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteController extends loc.GetxController {
  var userLocation = loc.Rxn<LatLng>();
}

class UseCurrentLocation extends StatefulWidget {
  const UseCurrentLocation({super.key});

  @override
  State<UseCurrentLocation> createState() => _UseCurrentLocationState();
}

class _UseCurrentLocationState extends State<UseCurrentLocation> {
  final RouteController routeController = loc.Get.put(RouteController());

  // Function to check location service and show bottom sheet automatically
  Future<void> _checkLocationServices() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // If location service is off, show bottom sheet
      _showLocationBottomSheet();
      return;
    }

    // Check if location permission is granted
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // If permission is not granted, show a message or request permission
        loc.Get.snackbar('Permission Denied', 'Location access is required.');
        return;
      }
    }

    // Both services and permissions are granted, navigate to MapScreen
    _navigateToMapScreen();
  }

  @override
  void initState() {
    super.initState();
    _checkLocationServices(); // Automatically check location service on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Default to San Francisco
              zoom: 10.0,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.white.withOpacity(0.9),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Please Set Your Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show bottom sheet automatically
  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage('assets/setlocation.png'),
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Where are you?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We need your location to provide accurate service. You can set it automatically or later.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLocationPermissionModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Set Automatically'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _navigateToMapScreen();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Set Later'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show location permission modal
  void _showLocationPermissionModal() {
    loc.Get.defaultDialog(
      title: 'Allow Location Access',
      middleText:
          'We need your permission to access your location. This will help us set your starting point.',
      textCancel: 'Cancel',
      textConfirm: 'Allow',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Navigator.pop(context); // Dismiss dialog
        await _fetchCurrentLocation(); // Fetch and set the current location
        _navigateToMapScreen(); // Navigate to MapScreen after permission granted
      },
    );
  }

  // Function to fetch current location after permission is granted
  // Ensure current location is stored dynamically in the RouteController
  Future<void> _fetchCurrentLocation() async {
    Location location = Location();
    LocationData currentLocation = await location.getLocation();

    routeController.userLocation.value = LatLng(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    // Notify that location has been set
    loc.Get.snackbar('Location Set', 'Your current location has been set.');
  }

// Navigate to map screen and pass current location if available
  void _navigateToMapScreen() {
    if (routeController.userLocation.value != null) {
      loc.Get.off(() => const MapScreen(), arguments: {
        'currentLocation': routeController.userLocation.value
      }); // Pass current location to the next screen
    } else {
      loc.Get.off(() => const MapScreen());
    }
  }
}

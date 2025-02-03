import 'package:flutter/material.dart';
import 'package:flutter_course/maps/components/price_and_distance.dart';
import 'package:flutter_course/concepts/state_management/get_controller.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late GoogleMapsPlaces _places;
  List<Prediction> _predictions = [];
  final RouteController routeController = Get.put(RouteController());

  // Controllers for both search fields
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  // Track which field is active (pickup or dropoff)
  bool isPickupSelected = true;

//------------------------------ Get coordinates for the given address
  Future<LatLng> getCoordinates(String address) async {
    try {
      // Use GoogleMapsPlaces to perform geocoding
      final response = await _places.searchByText(address);
      if (response.isOkay && response.results.isNotEmpty) {
        final location = response.results.first.geometry!.location;
        return LatLng(location.lat, location.lng);
      } else {
        throw Exception(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Failed to find coordinates for the given address.');
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>>>>Error in getCoordinates: $e');
      throw Exception('Error fetching coordinates.');
    }
  }

//------------------------- confirmLocations -------------------------
  void confirmLocations() async {
    if (pickupController.text.isEmpty || dropoffController.text.isEmpty) {
      Get.snackbar('Error', 'Please select both pickup and dropoff locations.');

      return;
    }

    try {
      LatLng pickup = await getCoordinates(pickupController.text);
      LatLng dropoff = await getCoordinates(dropoffController.text);

      routeController.setPickupLocation(pickup);
      routeController.setDropoffLocation(dropoff);

      // Navigate to DisplayPriceAndDistance screen
      Get.to(() => const DisplayPriceAndDistance());
    } catch (e) {
      Get.snackbar('Error', 'Failed to confirm locations. Try again.');
      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Error in confirmations: $e');
    }
  }

  // AIzaSyBoWy2-vzkQzOw9FrCKUyfxWpa5_dsPi10
//------------------------------------------- Initialize GoogleMapsPlaces
  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(
        apiKey:
            'AIzaSyBoWy2-vzkQzOw9FrCKUyfxWpa5_dsPi10'); // Replace with your API key
  }

  //------------------------------------------- Fetch autocomplete predictions
  void autoCompleteSearch(String value) async {
    if (value.isNotEmpty) {
      final response = await _places.autocomplete(value);
      if (response.isOkay) {
        setState(() {
          _predictions = response.predictions;
        });
      } else {
        print("Error fetching suggestions: ${response.errorMessage}");
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  //----------------------------------------------- Handle location selection
  void onLocationSelected(Prediction prediction) {
    //Navigator.pop(context, prediction);
    if (isPickupSelected) {
      setState(() {
        pickupController.text = prediction.description!;
        isPickupSelected = false;
        _predictions = [];
      });
      FocusScope.of(context)
          .requestFocus(FocusNode()); // Remove focus from the first field
    } else {
      setState(() {
        dropoffController.text = prediction.description!;
        _predictions = [];
      });
      showConfirmBottomSheet();
    }
  }

//------------------------- Slide up the confirmation bottom sheet with pickup and drop-off locations
  void showConfirmBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors
          .transparent, // Make the background transparent for sleek design
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
                0.9), // White with slight opacity for a modern look
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.1), // Light shadow for elevation
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, -5), // Shadow towards the top
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Your Ride',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Sleek blue color for the title
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Circular Icon for Pickup Location
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        Colors.blue.withOpacity(0.1), // Light blue circle
                    child: const Icon(
                      Icons.my_location, // Icon for Pickup
                      color: Colors.blue, // Blue icon
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup Location:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Text(
                          pickupController.text.isNotEmpty
                              ? pickupController.text
                              : 'No location selected',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Circular Icon for Drop-off Location
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        Colors.blue.withOpacity(0.1), // Light blue circle
                    child: const Icon(
                      Icons.location_on, // Icon for Drop-off
                      color: Colors.blue, // Blue icon
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Drop-off Location:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Text(
                          dropoffController.text.isNotEmpty
                              ? dropoffController.text
                              : 'No location selected',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Confirm Button
              Center(
                child: SizedBox(
                  width: double.infinity, // Make the button full-width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      Future.delayed(Duration.zero, () {
                        confirmLocations();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade700, // Darker blue for the button
                      padding: const EdgeInsets.symmetric(
                          vertical:
                              16.0), // Add padding to make the button taller
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Fully rounded corners
                      ),
                      elevation: 5, // Elevation for a modern raised effect
                    ),
                    child: const Text(
                      'Confirm Your Ride',
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontSize: 18.0, // Increase font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//----------------------------------------------- Build the Route Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Your Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pickup Location Search Field
            _buildSearchField(
              'Pickup Location',
              pickupController,
              true, // Pickup field
            ),
            const SizedBox(height: 10.0),
            // Drop-off Location Search Field
            _buildSearchField(
              'Drop-off Destination',
              dropoffController,
              false, // Drop-off field
            ),
            const SizedBox(height: 10.0),
            // Display the search results
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      getIconForPlaceType(_predictions[index].types.first),
                      color: const Color(0xFFF41C3D),
                    ),
                    title: Text(_predictions[index].description ?? ''),
                    // title: Text(_predictions[index].description ?? ''),
                    onTap: () {
                      onLocationSelected(_predictions[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//----------------------------------------------- Build the Search Field

  Widget _buildSearchField(
      String placeholder, TextEditingController controller, bool isPickup) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
          ), // Left search icon
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder, // Display placeholder text
                border: InputBorder.none, // Remove underline
              ),
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              onChanged: (value) {
                if (isPickupSelected == isPickup) {
                  autoCompleteSearch(value); // Trigger autocomplete
                }
              },
            ),
          ),
          const Icon(Icons.map, color: Colors.blue), // Right map icon
        ],
      ),
    );
  }

// Get appropriate icon for the place type
  IconData getIconForPlaceType(String type) {
    switch (type) {
      case 'restaurant':
        return Icons.restaurant;
      case 'bar':
        return Icons.local_bar;
      case 'store':
      case 'shopping_mall':
        return Icons.store;
      case 'bank':
        return Icons.account_balance;
      case 'hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'gym':
        return Icons.fitness_center;
      case 'park':
        return Icons.park;
      case 'movie_theater':
        return Icons.local_movies;
      case 'library':
        return Icons.local_library;
      case 'airport':
        return Icons.flight;
      case 'gas_station':
        return Icons.local_gas_station;
      case 'pharmacy':
        return Icons.medication;
      case 'mechanic':
        return Icons.local_convenience_store;
      case 'church':
        return Icons.local_offer; // Or appropriate religious icon
      case 'police':
        return Icons.local_police;
      case 'estate':
        return Icons.house;
      case 'fire_station':
        return Icons.local_fire_department;
      default:
        return Icons.location_on;
    }
  }
}

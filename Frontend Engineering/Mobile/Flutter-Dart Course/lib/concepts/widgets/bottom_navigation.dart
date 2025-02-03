import 'package:flutter/material.dart';
import 'package:flutter_course/maps/components/use_current_location.dart';
import 'package:flutter_course/maps/maps.dart';

class RideHailingApp extends StatefulWidget {
  @override
  _RideHailingAppState createState() => _RideHailingAppState();
}

class _RideHailingAppState extends State<RideHailingApp> {
  int _currentIndex = 0; // Track the selected bottom nav bar index

  final List<Widget> _pages = [
    const UseCurrentLocation(), // Placeholder for the Home screen
    TripsScreen(), // Placeholder for the Trips screen
    MessagesScreen(), // Placeholder for the Messages screen
    ProfileScreen(), // Placeholder for the Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected screen

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update selected index
          });
        },
        type: BottomNavigationBarType.fixed, // Ensures labels are always shown
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        iconSize: 30.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Your Trips"));
  }
}

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Messages"));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile"));
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: RideHailingApp(),
//   ));
// }

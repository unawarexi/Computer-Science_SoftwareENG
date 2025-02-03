import 'package:flutter/material.dart';
import 'package:flutter_course/maps/maps.dart';
import 'package:flutter_course/concepts/widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concepts Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConceptsScreen(),
    );
  }
}

class ConceptsScreen extends StatelessWidget {
  const ConceptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of topics with associated screen classes
    final List<Map<String, dynamic>> topics = [
      {'title': 'Maps API', 'color': Colors.blue, 'screen': RideHailingApp()},
      {'title': 'APIs', 'color': Colors.green, 'screen': const ApiScreen()},
      {
        'title': 'State Management',
        'color': Colors.purple,
        'screen': const StateMgmtScreen()
      },
      {
        'title': 'Navigation',
        'color': Colors.orange,
        'screen': const NavigationScreen()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Concepts',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: topics.map((topic) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => topic['screen']),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: topic['color'],
                    padding: const EdgeInsets.all(20.0),
                  ),
                  child: Text(
                    topic['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Screen for APIs
class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APIs'),
      ),
      body: const Center(
        child: Text(
          'Learn about APIs here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Screen for State Management
class StateMgmtScreen extends StatelessWidget {
  const StateMgmtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management'),
      ),
      body: const Center(
        child: Text(
          'Learn about State Management here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Screen for Navigation
class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: const Center(
        child: Text(
          'Learn about Navigation here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

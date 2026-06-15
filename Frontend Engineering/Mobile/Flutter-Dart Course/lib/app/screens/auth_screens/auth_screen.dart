// auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_dart_course/screens/auth_screens/login.dart';
import 'package:flutter_dart_course/screens/auth_screens/signup.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E),  // Deep blue
              Color(0xFF3949AB),  // Indigo
              Color(0xFF42A5F5),  // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // App Logo
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "AC",
                    style: TextStyle(
                      color: Color(0xFF1A237E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // App Name
              Text(
                "Andrew Courses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Learn Anytime, Anywhere",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
             
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Color(0xFF1A237E),
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(text: "Login"),
                    Tab(text: "Sign Up"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    LoginScreen(),
                    SignupScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
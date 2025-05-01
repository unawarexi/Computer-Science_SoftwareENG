import 'package:flutter/material.dart';
import 'package:flutter_dart_course/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_dart_course/services/customApiservices/auth_services.dart';
import 'package:get/get.dart';
import 'package:flutter_dart_course/services/network_service.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize services
  final NetworkService networkService = Get.put(NetworkService());
  final RxBool isLoading = true.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    try {
      // Check login status
      isLoggedIn.value = await AuthService.isLoggedIn();
    } catch (e) {
      debugPrint('Error checking login status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        themeMode: ThemeMode.system,
        home: _buildHomeScreen(),
        builder: (context, child) {
          // Apply network status indicator overlay to all screens
          return NetworkStatusWrapper(child: child);
        },
        onGenerateRoute: (settings) {
          // User is already logged in, we can handle routes differently if needed
          if (isLoggedIn.value) {
            // Add your logged-in routes here
          }
          
          switch (settings.name) {
            case "/onboarding":
              return MaterialPageRoute(
                  builder: (context) => const OnboardingScreen());
            default:
              return MaterialPageRoute(
                  builder: (context) => const OnboardingScreen());
          }
        },
      );
    });
  }

  Widget _buildHomeScreen() {
    // Show loading indicator while checking initial state
    if (isLoading.value) {
      return const AppLoadingScreen();
    }

    // No internet connection
    if (!networkService.isConnected.value) {
      return const NoInternetScreen();
    }

    // Show onboarding or main app based on login status
    return const OnboardingScreen();
  }
}

// Network status overlay for all screens
class NetworkStatusWrapper extends StatelessWidget {
  final Widget? child;
  
  const NetworkStatusWrapper({super.key, this.child});
  
  @override
  Widget build(BuildContext context) {
    final NetworkService networkService = Get.find<NetworkService>();
    
    return Stack(
      children: [
        // The actual screen content
        if (child != null) child!,
        
        // Network status indicator
        Obx(() {
          // Only show status bar for slow or unstable connections
          if (networkService.networkStatus.value == NetworkStatus.slow ||
              networkService.networkStatus.value == NetworkStatus.unstable) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: _buildNetworkStatusBar(networkService.networkStatus.value),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        
        // Loading overlay when checking connection
        // Obx(() {
        //   if (networkService.isCheckingConnection.value) {
        //     return Positioned(
        //       bottom: 20,
        //       right: 20,
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //         decoration: BoxDecoration(
        //           color: Colors.black54,
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: const Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             SizedBox(
        //               width: 16,
        //               height: 16,
        //               child: CircularProgressIndicator(
        //                 strokeWidth: 2,
        //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //               ),
        //             ),
        //             SizedBox(width: 8),
        //             Text('Checking network...', 
        //               style: TextStyle(color: Colors.white, fontSize: 12),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   }
        //   return const SizedBox.shrink();
        // }),
      ],
    );
  }
  
  Widget _buildNetworkStatusBar(NetworkStatus status) {
    Color backgroundColor;
    String message;
    IconData icon;
    
    switch (status) {
      case NetworkStatus.slow:
        backgroundColor = Colors.orange;
        message = "Slow connection detected";
        icon = Icons.network_cell;
        break;
      case NetworkStatus.unstable:
        backgroundColor = Colors.amber;
        message = "Unstable connection detected";
        icon = Icons.network_check;
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 30, bottom: 8, left: 16, right: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<NetworkService>().checkConnection();
            },
            child: const Icon(Icons.refresh, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

// Loading screen shown when checking initial app state
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Loading application...',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

// No internet connection screen
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 100),
              const SizedBox(height: 20),
              const Text(
                "No Internet Connection",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please check your connection and retry.",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await Get.find<NetworkService>().checkConnection();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
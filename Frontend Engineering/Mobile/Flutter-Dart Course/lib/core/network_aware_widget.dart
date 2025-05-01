import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dart_course/services/network_service.dart';

/// A widget that shows different content based on network status.
/// Use this for individual screens that need special network handling.
class NetworkAwareWidget extends StatelessWidget {
  /// The main content to display when network is available
  final Widget child;
  
  /// Optional custom widget to show when network is unavailable
  /// If not provided, will use default NoNetworkWidget
  final Widget? noNetworkWidget;
  
  /// Optional custom widget to show when network is slow/unstable
  /// If not provided, will show the child with a banner
  final Widget? poorNetworkWidget;
  
  /// Whether to retry loading data when network is restored
  final bool retryOnNetworkRestore;
  
  /// Callback to execute when network is restored
  final VoidCallback? onNetworkRestored;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.noNetworkWidget,
    this.poorNetworkWidget,
    this.retryOnNetworkRestore = true,
    this.onNetworkRestored,
  });

  @override
  Widget build(BuildContext context) {
    final NetworkService networkService = Get.find<NetworkService>();
    
    return Obx(() {
      // Check network status
      final status = networkService.networkStatus.value;
      
      // Handle network restoration
      if (status == NetworkStatus.online && 
          retryOnNetworkRestore && 
          onNetworkRestored != null) {
        // Use a post-frame callback to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onNetworkRestored!();
        });
      }
      
      // Show appropriate widget based on network status
      if (!networkService.isConnected.value) {
        return noNetworkWidget ?? const DefaultNoNetworkWidget();
      }
      
      if (status == NetworkStatus.slow || status == NetworkStatus.unstable) {
        return poorNetworkWidget ?? _buildWithWarningBanner(context, status);
      }
      
      return child;
    });
  }
  
  Widget _buildWithWarningBanner(BuildContext context, NetworkStatus status) {
    String message = status == NetworkStatus.slow
        ? "Slow connection detected. Some features may be limited."
        : "Unstable connection detected. Data may not load correctly.";
        
    return Column(
      children: [
        Container(
          color: status == NetworkStatus.slow ? Colors.orange : Colors.amber,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// Default widget shown when there's no network connection
class DefaultNoNetworkWidget extends StatelessWidget {
  const DefaultNoNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "Network Connection Lost",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Please check your connection and try again",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.find<NetworkService>().checkConnection();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
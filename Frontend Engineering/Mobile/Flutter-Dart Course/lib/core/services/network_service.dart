import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum NetworkStatus {
  online,
  offline,
  slow,
  unstable,
}

class NetworkService extends GetxService {
  final Rx<NetworkStatus> networkStatus = NetworkStatus.online.obs;
  final RxBool isConnected = true.obs;
  final RxBool isCheckingConnection = false.obs;

  final int _slowThreshold = 2000; // milliseconds to consider slow

  int _failedChecks = 0;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late Timer _periodicChecker;

  // Custom hosts to check
  final List<String> _checkHosts = [
    'google.com',
    'cloudflare.com',
    'apple.com',
  ];

  late InternetConnection _connectionChecker;

  @override
  void onInit() {
    super.onInit();
    _setupCustomConnectionChecker();
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    // Periodic checking every 30 seconds
    _periodicChecker = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isConnected.value) {
        _checkConnectionQuality();
      }
    });
  }

  void _setupCustomConnectionChecker() {
    _connectionChecker = InternetConnection.createInstance(
      customCheckOptions: _checkHosts.map((host) {
        return InternetCheckOption(
          uri: Uri.parse('https://$host'),
          responseStatusFn: (response) => response.statusCode == 200,
        );
      }).toList(),
    );
  }

  Future<void> _initConnectivity() async {
    isCheckingConnection.value = true;
    try {
      List<ConnectivityResult> results = await Connectivity().checkConnectivity();
      await _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
      _setNetworkStatus(NetworkStatus.offline);
    } finally {
      isCheckingConnection.value = false;
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none) && results.length == 1) {
      _setNetworkStatus(NetworkStatus.offline);
    } else {
      bool hasInternet = await _connectionChecker.hasInternetAccess;
      if (!hasInternet) {
        _setNetworkStatus(NetworkStatus.offline);
      } else {
        if (networkStatus.value == NetworkStatus.offline) {
          _setNetworkStatus(NetworkStatus.online);
          _failedChecks = 0;
        }
        _checkConnectionQuality();
      }
    }
  }

  Future<void> _checkConnectionQuality() async {
    if (networkStatus.value == NetworkStatus.offline) return;

    isCheckingConnection.value = true;
    try {
      String host = _checkHosts[DateTime.now().second % _checkHosts.length];

      final connection = InternetConnection.createInstance(
        customCheckOptions: [
          InternetCheckOption(
            uri: Uri.parse('https://$host'),
            responseStatusFn: (response) => response.statusCode == 200,
          ),
        ],
      );

      Stopwatch stopwatch = Stopwatch()..start();
      bool hasInternet = await connection.hasInternetAccess;
      stopwatch.stop();

      if (!hasInternet) {
        _failedChecks++;
        if (_failedChecks >= 2) {
          _setNetworkStatus(NetworkStatus.unstable);
        }
        return;
      }

      _failedChecks = 0;

      if (stopwatch.elapsedMilliseconds > _slowThreshold) {
        _setNetworkStatus(NetworkStatus.slow);
      } else if (networkStatus.value != NetworkStatus.online) {
        _setNetworkStatus(NetworkStatus.online);
      }
    } catch (e) {
      debugPrint('Connection quality check failed: $e');
      _failedChecks++;
      if (_failedChecks >= 2) {
        _setNetworkStatus(NetworkStatus.unstable);
      }
    } finally {
      isCheckingConnection.value = false;
    }
  }

  void _setNetworkStatus(NetworkStatus status) {
    if (networkStatus.value == status) return;

    networkStatus.value = status;
    isConnected.value = status != NetworkStatus.offline;

    String message;
    Color backgroundColor;

    switch (status) {
      case NetworkStatus.online:
        message = "Internet Connected!";
        backgroundColor = Colors.green;
        break;
      case NetworkStatus.offline:
        message = "No Internet Connection!";
        backgroundColor = Colors.red;
        break;
      case NetworkStatus.slow:
        message = "Slow Internet Connection";
        backgroundColor = Colors.orange;
        break;
      case NetworkStatus.unstable:
        message = "Unstable Internet Connection";
        backgroundColor = Colors.amber;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // Manual trigger to check connection
  Future<void> checkConnection() async {
    return _initConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _periodicChecker.cancel();
    super.onClose();
  }
}

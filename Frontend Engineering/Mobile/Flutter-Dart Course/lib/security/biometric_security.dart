import "package:flutter/material.dart";
import "package:local_auth/local_auth.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";


class BiometricSecurity {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: "Please authenticate to access this feature",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint("Error during authentication: $e");
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      debugPrint("Error checking biometric availability: $e");
      return false;
    }
  }

  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      debugPrint("Error checking device support: $e");
      return false;
    }
  }
  Future<void> storeBiometricData(String key, String value) async {
    const storage = FlutterSecureStorage();
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      debugPrint("Error storing biometric data: $e");
    }
  }
  Future<String?> retrieveBiometricData(String key) async {
    const storage = FlutterSecureStorage();
    try {
      return await storage.read(key: key);
    } catch (e) {
      debugPrint("Error retrieving biometric data: $e");
      return null;
    }
  }
  Future<void> deleteBiometricData(String key) async {
    const storage = FlutterSecureStorage();
    try {
      await storage.delete(key: key);
    } catch (e) {
      debugPrint("Error deleting biometric data: $e");
    }
  }
  Future<void> deleteAllBiometricData() async {
    const storage = FlutterSecureStorage();
    try {
      await storage.deleteAll();
    } catch (e) {
      debugPrint("Error deleting all biometric data: $e");
    }
  }
}
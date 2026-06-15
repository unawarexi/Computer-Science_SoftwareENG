import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FaceIdAuthentication {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Key for storing face ID status
  static const String faceIdEnabledKey = 'face_id_enabled';
  
  // Check if device supports face ID
  Future<bool> isFaceIdSupported() async {
    try {
      if (!await _localAuth.isDeviceSupported()) {
        return false;
      }
      
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.face);
    } catch (e) {
      debugPrint('Error checking face ID support: $e');
      return false;
    }
  }
  
  // Enable face ID authentication
  Future<bool> enableFaceId() async {
    try {
      if (!await isFaceIdSupported()) {
        return false;
      }
      
      // First authenticate to confirm user identity
      final authenticated = await authenticate();
      if (!authenticated) {
        return false;
      }
      
      // Save the face ID enabled status
      await _secureStorage.write(key: faceIdEnabledKey, value: 'true');
      return true;
    } catch (e) {
      debugPrint('Error enabling face ID: $e');
      return false;
    }
  }
  
  // Disable face ID authentication
  Future<bool> disableFaceId() async {
    try {
      await _secureStorage.write(key: faceIdEnabledKey, value: 'false');
      return true;
    } catch (e) {
      debugPrint('Error disabling face ID: $e');
      return false;
    }
  }
  
  // Check if face ID is enabled
  Future<bool> isFaceIdEnabled() async {
    try {
      final value = await _secureStorage.read(key: faceIdEnabledKey);
      return value == 'true';
    } catch (e) {
      debugPrint('Error checking if face ID is enabled: $e');
      return false;
    }
  }
  
  // Authenticate using face ID
  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    try {
      if (!await isFaceIdSupported()) {
        return false;
      }
      
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint('Error during face ID authentication: $e');
      return false;
    }
  }
  
  // Associate user data with face ID authentication
  Future<void> associateUserWithFaceId(String userId) async {
    try {
      await _secureStorage.write(key: 'face_id_user_$userId', value: 'true');
    } catch (e) {
      debugPrint('Error associating user with face ID: $e');
    }
  }
  
  // Remove face ID association for a user
  Future<void> removeFaceIdAssociation(String userId) async {
    try {
      await _secureStorage.delete(key: 'face_id_user_$userId');
    } catch (e) {
      debugPrint('Error removing face ID association: $e');
    }
  }
}
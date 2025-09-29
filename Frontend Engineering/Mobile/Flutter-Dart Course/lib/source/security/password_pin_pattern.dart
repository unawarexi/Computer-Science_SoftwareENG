import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

enum LockType {
  pin,
  password,
  pattern
}

class SecurityAuthentication {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Storage keys
  static const String typeKey = 'security_type';
  static const String valueKey = 'security_value';
  static const String enabledKey = 'security_enabled';
  
  // Hash a security value for secure storage
  String _hashValue(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Set up a new security method
  Future<bool> setupSecurity(LockType type, String value) async {
    try {
      // Store the type of security (PIN, password, pattern)
      await _secureStorage.write(key: typeKey, value: type.toString());
      
      // Store the hashed security value
      final hashedValue = _hashValue(value);
      await _secureStorage.write(key: valueKey, value: hashedValue);
      
      // Enable the security
      await _secureStorage.write(key: enabledKey, value: 'true');
      return true;
    } catch (e) {
      debugPrint('Error setting up security: $e');
      return false;
    }
  }
  
  // Disable security
  Future<bool> disableSecurity() async {
    try {
      await _secureStorage.write(key: enabledKey, value: 'false');
      return true;
    } catch (e) {
      debugPrint('Error disabling security: $e');
      return false;
    }
  }
  
  // Check if security is enabled
  Future<bool> isSecurityEnabled() async {
    try {
      final value = await _secureStorage.read(key: enabledKey);
      return value == 'true';
    } catch (e) {
      debugPrint('Error checking if security is enabled: $e');
      return false;
    }
  }
  
  // Get the current security type
  Future<LockType?> getSecurityType() async {
    try {
      final typeStr = await _secureStorage.read(key: typeKey);
      if (typeStr == null) return null;
      
      if (typeStr == LockType.pin.toString()) {
        return LockType.pin;
      } else if (typeStr == LockType.password.toString()) {
        return LockType.password;
      } else if (typeStr == LockType.pattern.toString()) {
        return LockType.pattern;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting security type: $e');
      return null;
    }
  }
  
  // Verify security value
  Future<bool> verifySecurityValue(String value) async {
    try {
      final storedHash = await _secureStorage.read(key: valueKey);
      if (storedHash == null) return false;
      
      final inputHash = _hashValue(value);
      return storedHash == inputHash;
    } catch (e) {
      debugPrint('Error verifying security value: $e');
      return false;
    }
  }
  
  // Change security value
  Future<bool> changeSecurityValue(LockType type, String currentValue, String newValue) async {
    try {
      // First verify the current value
      if (!await verifySecurityValue(currentValue)) {
        return false;
      }
      
      // Update to the new value
      return await setupSecurity(type, newValue);
    } catch (e) {
      debugPrint('Error changing security value: $e');
      return false;
    }
  }
  
  // Helper method to get a readable name for security type
  String getSecurityTypeName(LockType type) {
    switch (type) {
      case LockType.pin:
        return 'PIN';
      case LockType.password:
        return 'Password';
      case LockType.pattern:
        return 'Pattern';
      default:
        return 'Unknown';
    }
  }
  
  // Clear all security data
  Future<void> clearAllSecurityData() async {
    try {
      await _secureStorage.delete(key: typeKey);
      await _secureStorage.delete(key: valueKey);
      await _secureStorage.delete(key: enabledKey);
    } catch (e) {
      debugPrint('Error clearing security data: $e');
    }
  }
}
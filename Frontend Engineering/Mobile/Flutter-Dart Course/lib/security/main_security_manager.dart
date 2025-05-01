import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'biometric_security.dart';
import 'face_id.dart';
import 'password_pin_pattern.dart';

enum SecurityMethod {
  none,
  biometric,
  faceId,
  pinPasswordPattern
}

class SecurityManager {
  final BiometricSecurity _biometricSecurity = BiometricSecurity();
  final FaceIdAuthentication _faceIdAuth = FaceIdAuthentication();
  final SecurityAuthentication _securityAuth = SecurityAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Keys for security methods
  static const String biometricEnabledKey = 'biometric_security_enabled';
  static const String faceIdEnabledKey = 'face_id_enabled';
  static const String pinPasswordPatternEnabledKey = 'security_enabled';
  static const String requiredForAppKey = 'security_required_for_app';
  static const String requiredForSensitiveActionsKey = 'security_required_for_sensitive';
  
  // Check if any security method is enabled
  Future<bool> isAnySecurityMethodEnabled() async {
    final biometricEnabled = await isBiometricEnabled();
    final faceIdEnabled = await isFaceIdEnabled();
    final pinPassPatternEnabled = await isPinPasswordPatternEnabled();
    
    return biometricEnabled || faceIdEnabled || pinPassPatternEnabled;
  }
  
  // Get all enabled security methods
  Future<List<SecurityMethod>> getEnabledSecurityMethods() async {
    final List<SecurityMethod> enabledMethods = [];
    
    if (await isBiometricEnabled()) {
      enabledMethods.add(SecurityMethod.biometric);
    }
    
    if (await isFaceIdEnabled()) {
      enabledMethods.add(SecurityMethod.faceId);
    }
    
    if (await isPinPasswordPatternEnabled()) {
      enabledMethods.add(SecurityMethod.pinPasswordPattern);
    }
    
    return enabledMethods;
  }
  
  // Biometric methods
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: biometricEnabledKey);
      return value == 'true' && await _biometricSecurity.isBiometricAvailable();
    } catch (e) {
      debugPrint('Error checking if biometric is enabled: $e');
      return false;
    }
  }
  
  Future<bool> enableBiometric() async {
    try {
      if (!await _biometricSecurity.isBiometricAvailable()) {
        return false;
      }
      
      // First authenticate to confirm user identity
      final authenticated = await _biometricSecurity.authenticate();
      if (!authenticated) {
        return false;
      }
      
      await _secureStorage.write(key: biometricEnabledKey, value: 'true');
      return true;
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      return false;
    }
  }
  
  Future<bool> disableBiometric() async {
    try {
      await _secureStorage.write(key: biometricEnabledKey, value: 'false');
      return true;
    } catch (e) {
      debugPrint('Error disabling biometric: $e');
      return false;
    }
  }
  
  Future<bool> authenticateWithBiometric({String reason = 'Authenticate to continue'}) async {
    if (!await isBiometricEnabled()) {
      return false;
    }
    
    return await _biometricSecurity.authenticate();
  }
  
  // Face ID methods
  Future<bool> isFaceIdEnabled() async {
    return await _faceIdAuth.isFaceIdEnabled();
  }
  
  Future<bool> enableFaceId() async {
    return await _faceIdAuth.enableFaceId();
  }
  
  Future<bool> disableFaceId() async {
    return await _faceIdAuth.disableFaceId();
  }
  
  Future<bool> authenticateWithFaceId({String reason = 'Authenticate to continue'}) async {
    if (!await isFaceIdEnabled()) {
      return false;
    }
    
    return await _faceIdAuth.authenticate(reason: reason);
  }
  
  // PIN/Password/Pattern methods
  Future<bool> isPinPasswordPatternEnabled() async {
    return await _securityAuth.isSecurityEnabled();
  }
  
  Future<bool> setupPinPasswordPattern(LockType type, String value) async {
    return await _securityAuth.setupSecurity(type, value);
  }
  
  Future<bool> disablePinPasswordPattern() async {
    return await _securityAuth.disableSecurity();
  }
  
  Future<bool> verifyPinPasswordPattern(String value) async {
    if (!await isPinPasswordPatternEnabled()) {
      return false;
    }
    
    return await _securityAuth.verifySecurityValue(value);
  }
  
  Future<LockType?> getPinPasswordPatternType() async {
    return await _securityAuth.getSecurityType();
  }
  
  // Security requirements configuration
  Future<void> setRequiredForAppLaunch(bool required) async {
    await _secureStorage.write(key: requiredForAppKey, value: required ? 'true' : 'false');
  }
  
  Future<bool> isRequiredForAppLaunch() async {
    final value = await _secureStorage.read(key: requiredForAppKey);
    return value == 'true';
  }
  
  Future<void> setRequiredForSensitiveActions(bool required) async {
    await _secureStorage.write(key: requiredForSensitiveActionsKey, value: required ? 'true' : 'false');
  }
  
  Future<bool> isRequiredForSensitiveActions() async {
    final value = await _secureStorage.read(key: requiredForSensitiveActionsKey);
    return value == 'true';
  }
  
  // Authentication with any available method
  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    final enabledMethods = await getEnabledSecurityMethods();
    
    if (enabledMethods.isEmpty) {
      return true; // No security methods enabled, so authentication passes
    }
    
    // Try biometric first if enabled
    if (enabledMethods.contains(SecurityMethod.biometric)) {
      final success = await authenticateWithBiometric(reason: reason);
      if (success) return true;
    }
    
    // Try face ID next if enabled
    if (enabledMethods.contains(SecurityMethod.faceId)) {
      final success = await authenticateWithFaceId(reason: reason);
      if (success) return true;
    }
    
    // PIN/Password/Pattern requires UI interaction, so we can't complete it here
    // Just check if it's the only option
    if (enabledMethods.contains(SecurityMethod.pinPasswordPattern) && 
        enabledMethods.length == 1) {
      return false; // Will need to show PIN/password/pattern UI
    }
    
    return false;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_dart_course/screens/security_screens/security_verifications.dart';
import 'package:flutter_dart_course/security/main_security_manager.dart';
import 'package:flutter_dart_course/security/password_pin_pattern.dart';
import 'package:flutter_dart_course/services/customApiservices/auth_services.dart';

// This class demonstrates how to implement security features in your app
class SecurityImplementation {
  final SecurityManager _securityManager = SecurityManager();
  
  // Example: Check if security is required when app starts
  Future<bool> checkAppLaunchSecurity(BuildContext context) async {
    // Check if security is required for app launch
    final securityRequired = await _securityManager.isRequiredForAppLaunch();
    
    if (!securityRequired) {
      return true; // No security required, proceed with app launch
    }
    
    // Check if any security method is enabled
    final anyMethodEnabled = await _securityManager.isAnySecurityMethodEnabled();
    
    if (!anyMethodEnabled) {
      // No security method is enabled, so we can't enforce security
      // In this case, we should update the setting
      await _securityManager.setRequiredForAppLaunch(false);
      return true;
    }
    
    // Show security verification screen
    bool authenticated = false;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecurityVerificationScreen(
          title: 'App Lock',
          message: 'Authenticate to access the app',
          onSuccess: () {
            authenticated = true;
            Navigator.pop(context);
          },
          onCancel: () {
            // If user cancels, close the app
            Navigator.pop(context);
          },
        ),
      ),
    );
    
    return authenticated;
  }
  
  // Example: Check security before accessing sensitive feature
  Future<bool> checkSensitiveActionSecurity(BuildContext context, {required String actionName}) async {
    // Check if security is required for sensitive actions
    final securityRequired = await _securityManager.isRequiredForSensitiveActions();
    
    if (!securityRequired) {
      return true; // No security required, proceed with sensitive action
    }
    
    // Check if any security method is enabled
    final anyMethodEnabled = await _securityManager.isAnySecurityMethodEnabled();
    
    if (!anyMethodEnabled) {
      // No security method is enabled, so we can't enforce security
      // In this case, we should update the setting
      await _securityManager.setRequiredForSensitiveActions(false);
      return true;
    }
    
    // Show security verification screen
    bool authenticated = false;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecurityVerificationScreen(
          title: 'Authentication Required',
          message: 'Authenticate to $actionName',
          onSuccess: () {
            authenticated = true;
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
    
    return authenticated;
  }
  
  // Example: Show security registration prompt when a security method is toggled on
  Future<void> showSecurityRegistrationPrompt(BuildContext context, SecurityMethod method) async {
    // This is where you'd show UI to set up the selected security method
    switch (method) {
      case SecurityMethod.biometric:
        await _showBiometricRegistrationPrompt(context);
        break;
      case SecurityMethod.faceId:
        await _showFaceIdRegistrationPrompt(context);
        break;
      case SecurityMethod.pinPasswordPattern:
        await _showPinPasswordPatternRegistrationPrompt(context);
        break;
      default:
        break;
    }
  }
  
  Future<void> _showBiometricRegistrationPrompt(BuildContext context) async {
    // Check if biometric is available on the device
    final available = await _securityManager._biometricSecurity.isBiometricAvailable();
    
    if (!available) {
      _showErrorDialog(
        context,
        'Biometric Not Available',
        'Your device does not support biometric authentication.'
      );
      return;
    }
    
    // Show a bottom sheet explaining the feature
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.fingerprint,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Set Up Biometric Authentication',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Use your fingerprint or other biometric method to quickly and securely access your account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await _securityManager.enableBiometric();
                  if (success) {
                    _showSuccessDialog(
                      context,
                      'Biometric Enabled',
                      'You can now use biometric authentication to secure your app.'
                    );
                  } else {
                    _showErrorDialog(
                      context,
                      'Setup Failed',
                      'Could not enable biometric authentication. Please try again.'
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Set Up Now'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Maybe Later'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _showFaceIdRegistrationPrompt(BuildContext context) async {
    // Similar implementation to biometric but for Face ID
    final available = await _securityManager._faceIdAuth.isFaceIdSupported();
    
    if (!available) {
      _showErrorDialog(
        context,
        'Face ID Not Available',
        'Your device does not support Face ID authentication.'
      );
      return;
    }
    
    // Show a bottom sheet explaining the feature
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.face,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Set Up Face ID',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Use your face to quickly and securely access your account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await _securityManager.enableFaceId();
                  if (success) {
                    _showSuccessDialog(
                      context,
                      'Face ID Enabled',
                      'You can now use Face ID to secure your app.'
                    );
                  } else {
                    _showErrorDialog(
                      context,
                      'Setup Failed',
                      'Could not enable Face ID. Please try again.'
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Set Up Now'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Maybe Later'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _showPinPasswordPatternRegistrationPrompt(BuildContext context) async {
    // Show a bottom sheet with options for PIN, password, or pattern
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose a Lock Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select a method to secure your app.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.pin_outlined),
                title: const Text('PIN'),
                subtitle: const Text('Use a numeric PIN code'),
                onTap: () {
                  Navigator.pop(context);
                  _showPinSetupDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.password_outlined),
                title: const Text('Password'),
                subtitle: const Text('Use an alphanumeric password'),
                onTap: () {
                  Navigator.pop(context);
                  _showPasswordSetupDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pattern_outlined),
                title: const Text('Pattern'),
                subtitle: const Text('Use a pattern lock'),
                onTap: () {
                  Navigator.pop(context);
                  _showPatternSetupDialog(context);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showPinSetupDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set up PIN'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter a 4-6 digit PIN',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a PIN';
              }
              if (value.length < 4 || value.length > 6) {
                return 'PIN must be 4-6 digits';
              }
              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'PIN must contain only digits';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await _securityManager.setupPinPasswordPattern(
                  LockType.pin, 
                  controller.text
                );
                
                if (success) {
                  Navigator.pop(context);
                  _showSuccessDialog(
                    context,
                    'PIN Setup Complete',
                    'You can now use your PIN to secure your app.'
                  );
                } else {
                  _showErrorDialog(
                    context,
                    'Setup Failed',
                    'Could not set up PIN. Please try again.'
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _showPasswordSetupDialog(BuildContext context) {
    // Similar implementation to PIN but for password
    // Implement password-specific validation
    // ...
  }
  
  void _showPatternSetupDialog(BuildContext context) {
    // In a real app, use a pattern lock UI widget
    // For this example, just show a placeholder
    // ...
  }
  
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Example: Use in app startup
  static void secureAppStartup(BuildContext context) async {
    final securityImpl = SecurityImplementation();
    final AuthService authService = AuthService();
    
    // First check if user is logged in
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (!isLoggedIn) {
      // User is not logged in, redirect to login screen
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    
    // User is logged in, check security
    final securityPassed = await securityImpl.checkAppLaunchSecurity(context);
    
    if (securityPassed) {
      // Security check passed, proceed to main app
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Security check failed, close the app or redirect to login
      // This typically happens when the user cancels authentication
      // For mobile apps, you might want to exit the app here
    }
  }
  
  // Example: Use before a sensitive action like payment
  static Future<void> performSensitiveAction(BuildContext context, {required String actionName, required Function action}) async {
    final securityImpl = SecurityImplementation();
    
    // Check security before proceeding
    final securityPassed = await securityImpl.checkSensitiveActionSecurity(context, actionName: actionName);
    
    if (securityPassed) {
      // Security check passed, proceed with the sensitive action
      await action();
    } else {
      // Security check failed or was cancelled by the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication required to $actionName')),
      );
    }
  }
  
  // Example: Use to enable a security method in settings
  static Future<void> enableSecurityMethod(BuildContext context, SecurityMethod method) async {
    final securityImpl = SecurityImplementation();
    await securityImpl.showSecurityRegistrationPrompt(context, method);
  }
  
  // Example: Use to disable a security method in settings
  static Future<bool> disableSecurityMethod(BuildContext context, SecurityMethod method) async {
    final securityImpl = SecurityImplementation();
    final SecurityManager manager = SecurityManager();
    bool success = false;
    
    // First authenticate to ensure it's the actual user
    bool authenticated = await securityImpl.checkSensitiveActionSecurity(
      context, 
      actionName: 'disable security feature'
    );
    
    if (!authenticated) {
      return false;
    }
    
    // Now disable the requested security method
    switch (method) {
      case SecurityMethod.biometric:
        success = await manager.disableBiometric();
        break;
      case SecurityMethod.faceId:
        success = await manager.disableFaceId();
        break;
      case SecurityMethod.pinPasswordPattern:
        success = await manager.disablePinPasswordPattern();
        break;
      default:
        break;
    }
    
    if (success) {
      // Check if any security method is still enabled
      final anyMethodEnabled = await manager.isAnySecurityMethodEnabled();
      
      // If no security method is enabled, update security requirements
      if (!anyMethodEnabled) {
        await manager.setRequiredForAppLaunch(false);
        await manager.setRequiredForSensitiveActions(false);
      }
      
      securityImpl._showSuccessDialog(
        context,
        'Security Disabled',
        'The selected security method has been disabled.'
      );
    } else {
      securityImpl._showErrorDialog(
        context,
        'Failed to Disable',
        'Could not disable the selected security method. Please try again.'
      );
    }
    
    return success;
  }
  
  // Example: Change security settings
  static Future<void> updateSecurityRequirements(BuildContext context, {bool? requireForApp, bool? requireForSensitiveActions}) async {
    final securityImpl = SecurityImplementation();
    final SecurityManager manager = SecurityManager();
    
    // First check if any security method is enabled
    final anyMethodEnabled = await manager.isAnySecurityMethodEnabled();
    
    if (!anyMethodEnabled) {
      securityImpl._showErrorDialog(
        context,
        'Security Not Configured',
        'Please enable at least one security method before updating security requirements.'
      );
      return;
    }
    
    // First authenticate to ensure it's the actual user
    bool authenticated = await securityImpl.checkSensitiveActionSecurity(
      context, 
      actionName: 'update security settings'
    );
    
    if (!authenticated) {
      return;
    }
    
    // Update the security requirements
    if (requireForApp != null) {
      await manager.setRequiredForAppLaunch(requireForApp);
    }
    
    if (requireForSensitiveActions != null) {
      await manager.setRequiredForSensitiveActions(requireForSensitiveActions);
    }
    
    securityImpl._showSuccessDialog(
      context,
      'Settings Updated',
      'Your security settings have been updated successfully.'
    );
  }
  
  // Helper method to check which security method to use first
  Future<SecurityMethod?> getPreferredSecurityMethod() async {
    final SecurityManager manager = SecurityManager();
    final enabledMethods = await manager.getEnabledSecurityMethods();
    
    if (enabledMethods.isEmpty) {
      return null;
    }
    
    // Prioritize biometric and Face ID over PIN/password/pattern
    if (enabledMethods.contains(SecurityMethod.biometric)) {
      return SecurityMethod.biometric;
    }
    
    if (enabledMethods.contains(SecurityMethod.faceId)) {
      return SecurityMethod.faceId;
    }
    
    if (enabledMethods.contains(SecurityMethod.pinPasswordPattern)) {
      return SecurityMethod.pinPasswordPattern;
    }
    
    return null;
  }
  
  // Example: Check current security status
  static Future<Map<String, bool>> getSecurityStatus() async {
    final SecurityManager manager = SecurityManager();
    
    return {
      'biometric': await manager.isBiometricEnabled(),
      'faceId': await manager.isFaceIdEnabled(),
      'pinPasswordPattern': await manager.isPinPasswordPatternEnabled(),
      'requiredForApp': await manager.isRequiredForAppLaunch(),
      'requiredForSensitiveActions': await manager.isRequiredForSensitiveActions(),
    };
  }
}
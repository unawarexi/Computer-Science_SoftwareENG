import 'package:flutter/material.dart';
import 'package:flutter_dart_course/security/main_security_manager.dart';
import 'package:flutter_dart_course/security/password_pin_pattern.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SecurityManager _securityManager = SecurityManager();

  // Security settings
  bool _biometricEnabled = false;
  bool _faceIdEnabled = false;
  bool _pinPasswordPatternEnabled = false;
  bool _securityRequiredForApp = false;
  bool _securityRequiredForSensitive = false;
  LockType? _currentLockType;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async {
    final biometricEnabled = await _securityManager.isBiometricEnabled();
    final faceIdEnabled = await _securityManager.isFaceIdEnabled();
    final pinPasswordPatternEnabled = await _securityManager.isPinPasswordPatternEnabled();
    final securityRequiredForApp = await _securityManager.isRequiredForAppLaunch();
    final securityRequiredForSensitive = await _securityManager.isRequiredForSensitiveActions();
    final currentLockType = await _securityManager.getPinPasswordPatternType();

    if (mounted) {
      setState(() {
        _biometricEnabled = biometricEnabled;
        _faceIdEnabled = faceIdEnabled;
        _pinPasswordPatternEnabled = pinPasswordPatternEnabled;
        _securityRequiredForApp = securityRequiredForApp;
        _securityRequiredForSensitive = securityRequiredForSensitive;
        _currentLockType = currentLockType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('General'),
          _buildSettingsGroup([
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('Language'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to language settings
              },
            ),
          ]),
          _buildSectionHeader('Security'),
          _buildSettingsGroup([
            SwitchListTile(
              secondary: const Icon(Icons.lock_outline),
              title: const Text('Require Authentication'),
              subtitle: const Text('Authenticate when opening the app'),
              value: _securityRequiredForApp,
              onChanged: (value) async {
                // If turning on, make sure at least one security method is enabled
                if (value && !await _securityManager.isAnySecurityMethodEnabled()) {
                  _showSecurityMethodPrompt();
                  return;
                }

                await _securityManager.setRequiredForAppLaunch(value);
                setState(() {
                  _securityRequiredForApp = value;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.security_outlined),
              title: const Text('Protect Sensitive Actions'),
              subtitle: const Text('Authenticate for payments, etc.'),
              value: _securityRequiredForSensitive,
              onChanged: (value) async {
                // If turning on, make sure at least one security method is enabled
                if (value && !await _securityManager.isAnySecurityMethodEnabled()) {
                  _showSecurityMethodPrompt();
                  return;
                }

                await _securityManager.setRequiredForSensitiveActions(value);
                setState(() {
                  _securityRequiredForSensitive = value;
                });
              },
            ),
          ]),
          _buildSectionHeader('Authentication Methods'),
          _buildSettingsGroup([
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Biometric Authentication'),
              subtitle: const Text('Use fingerprint or other biometrics'),
              value: _biometricEnabled,
              onChanged: (value) async {
                if (value) {
                  // Turning on biometric
                  final success = await _securityManager.enableBiometric();
                  if (success) {
                    setState(() {
                      _biometricEnabled = true;
                    });
                  } else {
                    _showErrorDialog(
                      'Biometric Setup Failed',
                      'Could not enable biometric authentication. Please make sure your device supports biometrics and try again.'
                    );
                  }
                } else {
                  // Turning off biometric
                  await _securityManager.disableBiometric();
                  setState(() {
                    _biometricEnabled = false;
                  });
                  _checkSecurityMethodsStatus();
                }
                // Always reload lock type in case of changes
                final currentLockType = await _securityManager.getPinPasswordPatternType();
                setState(() {
                  _currentLockType = currentLockType;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.face_outlined),
              title: const Text('Face ID'),
              subtitle: const Text('Use facial recognition'),
              value: _faceIdEnabled,
              onChanged: (value) async {
                if (value) {
                  // Turning on Face ID
                  final success = await _securityManager.enableFaceId();
                  if (success) {
                    setState(() {
                      _faceIdEnabled = true;
                    });
                  } else {
                    _showErrorDialog(
                      'Face ID Setup Failed',
                      'Could not enable Face ID. Please make sure your device supports facial recognition and try again.'
                    );
                  }
                } else {
                  // Turning off Face ID
                  await _securityManager.disableFaceId();
                  setState(() {
                    _faceIdEnabled = false;
                  });
                  _checkSecurityMethodsStatus();
                }
                // Always reload lock type in case of changes
                final currentLockType = await _securityManager.getPinPasswordPatternType();
                setState(() {
                  _currentLockType = currentLockType;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.pin_outlined),
              title: const Text('PIN / Password / Pattern'),
              subtitle: Text(_currentLockType != null ? 
                  'Currently using: ${_getLockTypeName(_currentLockType!)}' : 
                  'Set up a PIN, password, or pattern'),
              value: _pinPasswordPatternEnabled,
              onChanged: (value) async {
                if (value) {
                  // Show dialog to select PIN, password, or pattern
                  _showPinPasswordPatternDialog();
                } else {
                  // Turning off PIN/Password/Pattern
                  await _securityManager.disablePinPasswordPattern();
                  setState(() {
                    _pinPasswordPatternEnabled = false;
                    _currentLockType = null;
                  });
                  _checkSecurityMethodsStatus();
                }
              },
            ),
          ]),
          _buildSectionHeader('Account'),
          _buildSettingsGroup([
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to profile settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                _showLogoutConfirmation();
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  void _showSecurityMethodPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Method Required'),
        content: const Text(
          'You need to enable at least one security method (Biometric, Face ID, or PIN/Password/Pattern) to use this feature.'
        ),
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

  void _showErrorDialog(String title, String message) {
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

  void _showPinPasswordPatternDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Lock Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pin_outlined),
              title: const Text('PIN'),
              onTap: () {
                Navigator.pop(context);
                _showPinSetupDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.password_outlined),
              title: const Text('Password'),
              onTap: () {
                Navigator.pop(context);
                _showPasswordSetupDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text('Pattern'),
              onTap: () {
                Navigator.pop(context);
                _showPatternSetupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPinSetupDialog() {
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
                  setState(() {
                    _pinPasswordPatternEnabled = true;
                    _currentLockType = LockType.pin;
                  });
                } else {
                  _showErrorDialog(
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
    ).then((_) async {
      // Always reload lock type after dialog closes
      final currentLockType = await _securityManager.getPinPasswordPatternType();
      setState(() {
        _currentLockType = currentLockType;
      });
    });
  }

  void _showPasswordSetupDialog() {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set up Password'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter a password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
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
                  LockType.password,
                  controller.text
                );

                if (success) {
                  Navigator.pop(context);
                  setState(() {
                    _pinPasswordPatternEnabled = true;
                    _currentLockType = LockType.password;
                  });
                } else {
                  _showErrorDialog(
                    'Setup Failed',
                    'Could not set up password. Please try again.'
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) async {
      // Always reload lock type after dialog closes
      final currentLockType = await _securityManager.getPinPasswordPatternType();
      setState(() {
        _currentLockType = currentLockType;
      });
    });
  }

  void _showPatternSetupDialog() {
    // For pattern lock, ideally you'd use a dedicated pattern lock widget
    // For this example, we'll use a simplified approach with a text placeholder
    // In a real app, you'd implement a pattern drawing/recognition UI

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set up Pattern'),
        content: const Text(
          'To implement a pattern lock, you would use a specialized pattern lock widget. ' +
          'For this example, we\'ll simulate it with a simple text-based pattern.'
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
              // In a real app, you would get the pattern from the pattern widget
              // Here we'll use a placeholder pattern
              final patternValue = '1425369';

              final success = await _securityManager.setupPinPasswordPattern(
                LockType.pattern,
                patternValue
              );

              if (success) {
                Navigator.pop(context);
                setState(() {
                  _pinPasswordPatternEnabled = true;
                  _currentLockType = LockType.pattern;
                });
              } else {
                _showErrorDialog(
                  'Setup Failed',
                  'Could not set up pattern. Please try again.'
                );
              }
            },
            child: const Text('Simulate Setup'),
          ),
        ],
      ),
    ).then((_) async {
      // Always reload lock type after dialog closes
      final currentLockType = await _securityManager.getPinPasswordPatternType();
      setState(() {
        _currentLockType = currentLockType;
      });
    });
  }

  void _checkSecurityMethodsStatus() async {
    // Check if any security method is still enabled
    final anyMethodEnabled = await _securityManager.isAnySecurityMethodEnabled();

    if (!anyMethodEnabled) {
      // If no security methods are enabled, disable security requirements
      if (_securityRequiredForApp || _securityRequiredForSensitive) {
        await _securityManager.setRequiredForAppLaunch(false);
        await _securityManager.setRequiredForSensitiveActions(false);

        setState(() {
          _securityRequiredForApp = false;
          _securityRequiredForSensitive = false;
        });

        _showErrorDialog(
          'Security Disabled',
          'All security requirements have been disabled because no authentication methods are active.'
        );
      }
    }
  }

  String _getLockTypeName(LockType type) {
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform logout
              Navigator.pop(context);
              // Add your logout logic here
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
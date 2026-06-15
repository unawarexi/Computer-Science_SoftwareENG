import 'package:flutter/material.dart';
import 'package:flutter_dart_course/source/security/main_security_manager.dart';
import 'package:flutter_dart_course/source/security/password_pin_pattern.dart';

class SecurityVerificationScreen extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const SecurityVerificationScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<SecurityVerificationScreen> createState() => _SecurityVerificationScreenState();
}

class _SecurityVerificationScreenState extends State<SecurityVerificationScreen> {
  final SecurityManager _securityManager = SecurityManager();
  bool _isLoading = true;
  bool _biometricAvailable = false;
  bool _faceIdAvailable = false;
  bool _pinPasswordPatternAvailable = false;
  LockType? _currentLockType;
  
  @override
  void initState() {
    super.initState();
    _checkAvailableMethods();
  }
  
  Future<void> _checkAvailableMethods() async {
    final biometricEnabled = await _securityManager.isBiometricEnabled();
    final faceIdEnabled = await _securityManager.isFaceIdEnabled();
    final pinPasswordPatternEnabled = await _securityManager.isPinPasswordPatternEnabled();
    final currentLockType = await _securityManager.getPinPasswordPatternType();
    
    setState(() {
      _biometricAvailable = biometricEnabled;
      _faceIdAvailable = faceIdEnabled;
      _pinPasswordPatternAvailable = pinPasswordPatternEnabled;
      _currentLockType = currentLockType;
      _isLoading = false;
    });
    
    // Try biometric or face ID automatically if available
    if (_biometricAvailable) {
      _authenticateWithBiometric();
    } else if (_faceIdAvailable) {
      _authenticateWithFaceId();
    }
  }
  
  Future<void> _authenticateWithBiometric() async {
    final success = await _securityManager.authenticateWithBiometric(
      reason: widget.message
    );
    
    if (success) {
      widget.onSuccess();
    }
  }
  
  Future<void> _authenticateWithFaceId() async {
    final success = await _securityManager.authenticateWithFaceId(
      reason: widget.message
    );
    
    if (success) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Authentication options
                  if (_biometricAvailable)
                    _buildAuthOption(
                      icon: Icons.fingerprint,
                      title: 'Use Biometric',
                      onTap: _authenticateWithBiometric,
                    ),
                    
                  if (_faceIdAvailable)
                    _buildAuthOption(
                      icon: Icons.face,
                      title: 'Use Face ID',
                      onTap: _authenticateWithFaceId,
                    ),
                    
                  if (_pinPasswordPatternAvailable)
                    _buildAuthOption(
                      icon: _getLockTypeIcon(_currentLockType),
                      title: 'Use ${_getLockTypeName(_currentLockType)}',
                      onTap: _showPinPasswordPatternVerification,
                    ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildAuthOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
        onPressed: onTap,
      ),
    );
  }
  
  void _showPinPasswordPatternVerification() {
    if (_currentLockType == LockType.pin) {
      _showPinVerificationDialog();
    } else if (_currentLockType == LockType.password) {
      _showPasswordVerificationDialog();
    } else if (_currentLockType == LockType.pattern) {
      _showPatternVerificationDialog();
    }
  }
  
  void _showPinVerificationDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your PIN',
          ),
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await _securityManager.verifyPinPasswordPattern(controller.text);
              if (success) {
                Navigator.pop(context);
                widget.onSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect PIN. Please try again.')),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
  
  void _showPasswordVerificationDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your password',
          ),
        ),
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await _securityManager.verifyPinPasswordPattern(controller.text);
              if (success) {
                Navigator.pop(context);
                widget.onSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect password. Please try again.')),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
  
  void _showPatternVerificationDialog() {
    // For a real app, you would implement a pattern input UI
    // Here we're using a simplified text input for demonstration
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Pattern'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'In a real app, you would show a pattern input UI here.\nFor this demo, please input your pattern code:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your pattern code',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await _securityManager.verifyPinPasswordPattern(controller.text);
              if (success) {
                Navigator.pop(context);
                widget.onSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect pattern. Please try again.')),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
  
  IconData _getLockTypeIcon(LockType? type) {
    switch (type) {
      case LockType.pin:
        return Icons.pin_outlined;
      case LockType.password:
        return Icons.password_outlined;
      case LockType.pattern:
        return Icons.pattern_outlined;
      default:
        return Icons.lock_outline;
    }
  }
  
  String _getLockTypeName(LockType? type) {
    switch (type) {
      case LockType.pin:
        return 'PIN';
      case LockType.password:
        return 'Password';
      case LockType.pattern:
        return 'Pattern';
      default:
        return 'Security Code';
    }
  }
}
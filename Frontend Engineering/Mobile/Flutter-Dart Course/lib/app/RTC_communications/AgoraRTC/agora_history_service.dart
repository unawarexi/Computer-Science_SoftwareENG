import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

// Import the CallHistory class from agora_functionality.dart
// but only the needed parts to avoid circular imports
import 'agora_functionality.dart';

class HistoryService {
  // Singleton instance
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  // Storage keys
  static const String _callHistoryKey = 'call_history';
  
  // Encryption key - in a real app, store this securely!
  final _encryptionKey = encrypt.Key.fromLength(32);
  final _iv = encrypt.IV.fromLength(16);

  // Get the local storage path for files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the call history file
  Future<File> get _callHistoryFile async {
    final path = await _localPath;
    return File('$path/call_history.json');
  }

  // Encrypt data
  String _encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
    final encrypted = encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  // Decrypt data
  String _decryptData(String encryptedData) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
      final decrypted = encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedData),
        iv: _iv,
      );
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return '[]'; // Return empty list on error
    }
  }

  // Save call history using file-based storage with encryption
  Future<void> saveCallHistory(CallHistory callHistory) async {
    try {
      // Get existing history
      final existingHistory = await getCallHistory();
      
      // Add new call to history
      existingHistory.add(callHistory);
      
      // Convert to JSON and save
      final jsonList = existingHistory.map((call) => call.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      // Encrypt and save to file
      final encryptedData = _encryptData(jsonString);
      final file = await _callHistoryFile;
      await file.writeAsString(encryptedData);
      
      // Also save a reference in SharedPreferences for quick access
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_callHistoryKey, encryptedData);
    } catch (e) {
      print('Error saving call history: $e');
    }
  }

  // Get call history with both backup checks
  Future<List<CallHistory>> getCallHistory() async {
    try {
      // Try reading from file first
      final file = await _callHistoryFile;
      if (await file.exists()) {
        final encryptedData = await file.readAsString();
        final decryptedData = _decryptData(encryptedData);
        final jsonList = jsonDecode(decryptedData) as List;
        return jsonList.map((item) => CallHistory.fromJson(item)).toList();
      }
      
      // If file doesn't exist, try SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final encryptedData = prefs.getString(_callHistoryKey);
      if (encryptedData != null) {
        final decryptedData = _decryptData(encryptedData);
        final jsonList = jsonDecode(decryptedData) as List;
        return jsonList.map((item) => CallHistory.fromJson(item)).toList();
      }
      
      // If nothing found, return empty list
      return [];
    } catch (e) {
      print('Error retrieving call history: $e');
      return [];
    }
  }

  // Delete a specific call from history
  Future<void> deleteCallHistory(String callId) async {
    try {
      // Get existing history
      final existingHistory = await getCallHistory();
      
      // Remove the specified call
      final filteredHistory = existingHistory.where((call) => call.id != callId).toList();
      
      // Save back to storage
      final jsonList = filteredHistory.map((call) => call.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      // Encrypt and save
      final encryptedData = _encryptData(jsonString);
      final file = await _callHistoryFile;
      await file.writeAsString(encryptedData);
      
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_callHistoryKey, encryptedData);
    } catch (e) {
      print('Error deleting call history: $e');
    }
  }

  // Clear all call history
  Future<void> clearCallHistory() async {
    try {
      // Save empty list
      final jsonString = jsonEncode([]);
      final encryptedData = _encryptData(jsonString);
      
      // Save to file
      final file = await _callHistoryFile;
      await file.writeAsString(encryptedData);
      
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_callHistoryKey, encryptedData);
    } catch (e) {
      print('Error clearing call history: $e');
    }
  }

  // Get call statistics
  Future<CallStatistics> getCallStatistics() async {
    final history = await getCallHistory();
    
    int totalCalls = history.length;
    int totalDuration = 0;
    int videoCalls = 0;
    int audioCalls = 0;
    int outgoingCalls = 0;
    int incomingCalls = 0;
    int missedCalls = 0;
    int rejectedCalls = 0;
    
    for (final call in history) {
      totalDuration += call.duration;
      
      if (call.type == CallType.video) {
        videoCalls++;
      } else {
        audioCalls++;
      }
      
      if (call.isOutgoing) {
        outgoingCalls++;
      } else {
        incomingCalls++;
      }
      
      if (call.status == CallStatus.missed) {
        missedCalls++;
      } else if (call.status == CallStatus.rejected) {
        rejectedCalls++;
      }
    }
    
    return CallStatistics(
      totalCalls: totalCalls,
      totalDuration: totalDuration,
      videoCalls: videoCalls,
      audioCalls: audioCalls,
      outgoingCalls: outgoingCalls,
      incomingCalls: incomingCalls,
      missedCalls: missedCalls,
      rejectedCalls: rejectedCalls,
    );
  }
  
  // Search call history
  Future<List<CallHistory>> searchCallHistory(String query) async {
    final history = await getCallHistory();
    
    if (query.isEmpty) {
      return history;
    }
    
    query = query.toLowerCase();
    return history.where((call) => 
      call.remoteUserId.toLowerCase().contains(query) ||
      call.startTime.toString().contains(query)
    ).toList();
  }
  
  // Filter call history by type
  Future<List<CallHistory>> filterCallHistory({
    CallType? type,
    CallStatus? status,
    bool? isOutgoing,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final history = await getCallHistory();
    
    return history.where((call) {
      bool matchesFilters = true;
      
      if (type != null && call.type != type) {
        matchesFilters = false;
      }
      
      if (status != null && call.status != status) {
        matchesFilters = false;
      }
      
      if (isOutgoing != null && call.isOutgoing != isOutgoing) {
        matchesFilters = false;
      }
      
      if (startDate != null && call.startTime.isBefore(startDate)) {
        matchesFilters = false;
      }
      
      if (endDate != null && call.startTime.isAfter(endDate)) {
        matchesFilters = false;
      }
      
      return matchesFilters;
    }).toList();
  }
  
  // Export call history as JSON string
  Future<String> exportCallHistory() async {
    final history = await getCallHistory();
    final jsonList = history.map((call) => call.toJson()).toList();
    return jsonEncode(jsonList);
  }
  
  // Import call history from JSON string
  Future<bool> importCallHistory(String jsonString) async {
    try {
      final jsonList = jsonDecode(jsonString) as List;
      final history = jsonList.map((item) => CallHistory.fromJson(item)).toList();
      
      // Convert to JSON and save
      final newJsonString = jsonEncode(jsonList);
      final encryptedData = _encryptData(newJsonString);
      
      // Save to file
      final file = await _callHistoryFile;
      await file.writeAsString(encryptedData);
      
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_callHistoryKey, encryptedData);
      
      return true;
    } catch (e) {
      print('Error importing call history: $e');
      return false;
    }
  }
  
  // Backup call history to custom location
  Future<bool> backupCallHistory(String customPath) async {
    try {
      final history = await getCallHistory();
      final jsonList = history.map((call) => call.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      // Create backup file
      final backupFile = File(customPath);
      await backupFile.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print('Error backing up call history: $e');
      return false;
    }
  }
  
  // Restore call history from custom location
  Future<bool> restoreCallHistory(String customPath) async {
    try {
      final backupFile = File(customPath);
      if (await backupFile.exists()) {
        final jsonString = await backupFile.readAsString();
        return await importCallHistory(jsonString);
      }
      return false;
    } catch (e) {
      print('Error restoring call history: $e');
      return false;
    }
  }
}

// Call statistics model
class CallStatistics {
  final int totalCalls;
  final int totalDuration; // in seconds
  final int videoCalls;
  final int audioCalls;
  final int outgoingCalls;
  final int incomingCalls;
  final int missedCalls;
  final int rejectedCalls;

  CallStatistics({
    required this.totalCalls,
    required this.totalDuration,
    required this.videoCalls,
    required this.audioCalls,
    required this.outgoingCalls,
    required this.incomingCalls,
    required this.missedCalls,
    required this.rejectedCalls,
  });
  
  // Format total duration to readable string (HH:MM:SS)
  String get formattedTotalDuration {
    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;
    final seconds = totalDuration % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Average call duration in seconds
  double get averageCallDuration {
    if (totalCalls == 0) return 0;
    return totalDuration / totalCalls;
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalCalls': totalCalls,
      'totalDuration': totalDuration,
      'videoCalls': videoCalls,
      'audioCalls': audioCalls,
      'outgoingCalls': outgoingCalls,
      'incomingCalls': incomingCalls,
      'missedCalls': missedCalls,
      'rejectedCalls': rejectedCalls,
    };
  }
}
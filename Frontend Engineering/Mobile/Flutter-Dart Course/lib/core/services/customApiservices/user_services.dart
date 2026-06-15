// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_services.dart'; // Import to use the same token key

const String BASE_URL = 'http://192.168.61.155:3000/api/v1/users';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;
  bool isSelected;
  bool isRead;
  String? lastMessage;
  DateTime? lastMessageTime;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
    this.isSelected = false,
    this.isRead = false,
    this.lastMessage,
    this.lastMessageTime,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      // lastMessage and lastMessageTime are not from backend, so not set here
    );
  }
}

class UserService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Updated method to properly set auth token - using AuthService constants
  static Future<void> setAuthToken() async {
    try {
      final token = await AuthService.getToken(); // Use the AuthService method directly
      
      print('Token being used for API request: $token'); // Debug print
      
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        // If token is null or empty, throw an exception
        throw Exception('Authentication token not found. Please login first.');
      }
    } catch (e) {
      print('Error setting auth token: $e'); // Debug print
      throw Exception('Error setting authentication token: $e');
    }
  }

  // Get all users with improved debugging
  static Future<List<User>> getAllUsers() async {
    try {
      // Make sure to set auth token before making the request
      await setAuthToken();
      
      print('Making request to $BASE_URL/'); // Debug print
      
      final response = await _dio.get('/');
      
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response data structure: ${response.data.runtimeType}'); // Debug print
      
      if (response.statusCode == 200) {
        // Add safer handling of response data structure
        if (response.data == null) {
          throw Exception('Server returned null response');
        }
        
        if (response.data['data'] == null) {
          throw Exception('Response data missing expected format');
        }
        
        if (response.data['data']['users'] == null) {
          throw Exception('Response data missing users array');
        }
        
        final List<dynamic> data = response.data['data']['users'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException in getAllUsers: ${e.type}, ${e.message}'); // Debug print
      print('Response data: ${e.response?.data}'); // Debug print
      print('Response status: ${e.response?.statusCode}'); // Debug print
      
      if (e.response?.statusCode == 403) {
        throw Exception('Access denied: You don\'t have permission to view users. Please check your login credentials.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Generic error in getAllUsers: $e'); // Debug print
      throw Exception('Error getting users: $e');
    }
  }

  // Get user by ID
  static Future<User> getUserById(String id) async {
    try {
      await setAuthToken();
      final response = await _dio.get('/$id');

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']['user']);
      } else {
        throw Exception('Failed to load user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  // Get current user profile
  static Future<User> getCurrentUser() async {
    try {
      await setAuthToken();
      final response = await _dio.get('/me');

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']['user']);
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  // Delete user by ID
  static Future<void> deleteUser(String id) async {
    try {
      await setAuthToken();
      final response = await _dio.delete('/$id');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Delete multiple users
  static Future<void> deleteMultipleUsers(List<String> ids) async {
    try {
      for (final id in ids) {
        await deleteUser(id);
      }
    } catch (e) {
      throw Exception('Error deleting multiple users: $e');
    }
  }
}
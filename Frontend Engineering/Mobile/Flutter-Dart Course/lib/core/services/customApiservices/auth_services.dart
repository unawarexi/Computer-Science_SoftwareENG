// ignore_for_file: constant_identifier_names, duplicate_ignore

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const BASE_URL = 'http://localhost:3000/api/v1/auth';

// http://192.168.61.155:3000/api/v1/auth

class AuthService {
  final Dio _dio = Dio();
  
  // Token storage keys
  static const String TOKEN_KEY = 'auth_token';
  static const String USER_ID_KEY = 'user_id';
  static const String USER_EMAIL_KEY = 'user_email';
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(TOKEN_KEY);
    return token != null && token.isNotEmpty;
  }
  
  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(TOKEN_KEY);
    print('Retrieved token: ${token != null ? token.substring(0, min(10, token.length)) + "..." : "null"}');
    return token;
  }
  
  // Store user session data
  static Future<void> saveUserSession(String token, String userId, String email) async {
    print('Saving user session - Token: ${token.substring(0, min(10, token.length))}... UserID: $userId, Email: $email');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
    await prefs.setString(USER_ID_KEY, userId);
    await prefs.setString(USER_EMAIL_KEY, email);
    
    // Verify saved data
    final savedToken = prefs.getString(TOKEN_KEY);
    print('Verification - Saved token: ${savedToken != null ? savedToken.substring(0, min(10, savedToken.length)) + "..." : "null"}');
  }
  
  // Clear user session data (logout)
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove(USER_ID_KEY);
    await prefs.remove(USER_EMAIL_KEY);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      print('Attempting login for $email to $BASE_URL/login');
      final response = await _dio.post(
        '$BASE_URL/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response structure: ${response.data.runtimeType}');
      print('Login response contains token: ${response.data.containsKey('token')}');
      
      // Save user session if login successful
      if (response.data['token'] != null) {
        print('Token received successfully');
        
        // Extract user data safely
        final userId = response.data['user'] != null && response.data['user']['_id'] != null
            ? response.data['user']['_id']
            : '';
            
        final userEmail = response.data['user'] != null && response.data['user']['email'] != null
            ? response.data['user']['email']
            : email;
        
        await saveUserSession(
          response.data['token'],
          userId,
          userEmail
        );
        
        // Double-check token was saved correctly
        final savedToken = await getToken();
        if (savedToken == null || savedToken.isEmpty) {
          print('WARNING: Token not saved correctly after login');
        }
      } else {
        print('WARNING: No token in login response');
      }
      
      return response.data;
    } on DioException catch (e) {
      print('DioException in loginUser: ${e.type}, ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status: ${e.response?.statusCode}');
      
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      }
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      print('Generic error in loginUser: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> signupUser(String firstname, String lastname, String email, String password) async {
    try {
      final response = await _dio.post(
        '$BASE_URL/signup',
        data: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        },
      );
      return response.data;
     
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Signup failed');
      }
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }
}

// Helper function for string manipulation
int min(int a, int b) {
  return a < b ? a : b;
}
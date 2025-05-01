import 'package:dio/dio.dart';
import 'auth_services.dart';

const String CHAT_BASE_URL = 'http://192.168.61.155:3000/api/v1/chats';

class RTCService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: CHAT_BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> setAuthToken() async {
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      throw Exception('Authentication token not found. Please login first.');
    }
  }

  // Get all chats for the logged-in user
  static Future<List<dynamic>> getUserChats() async {
    await setAuthToken();
    final response = await _dio.get('/');
    if (response.statusCode == 200) {
      return response.data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load chats');
    }
  }

  // Get a single chat by ID
  static Future<Map<String, dynamic>> getChatById(String chatId) async {
    await setAuthToken();
    final response = await _dio.get('/$chatId');
    if (response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load chat');
    }
  }

  // Create a new chat (one-on-one or group)
  static Future<Map<String, dynamic>> createChat({
    required List<String> participantIds,
    bool isGroupChat = false,
    String? groupName,
  }) async {
    await setAuthToken();
    final response = await _dio.post(
      '/',
      data: {
        'participantIds': participantIds,
        'isGroupChat': isGroupChat,
        if (groupName != null) 'groupName': groupName,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create chat');
    }
  }

  // Send a message in a chat
  static Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    String? text,
    String? media,
    String? mediaType,
  }) async {
    await setAuthToken();
    final response = await _dio.post(
      '/$chatId/messages',
      data: {
        if (text != null) 'text': text,
        if (media != null) 'media': media,
        if (mediaType != null) 'mediaType': mediaType,
      },
    );
    if (response.statusCode == 201) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to send message');
    }
  }

  // Mark messages as read in a chat
  static Future<void> markMessagesAsRead(String chatId) async {
    await setAuthToken();
    final response = await _dio.post('/$chatId/read');
    if (response.statusCode != 200) {
      throw Exception('Failed to mark messages as read');
    }
  }

  // Add participant to group chat
  static Future<void> addParticipant(String chatId, String participantId) async {
    await setAuthToken();
    final response = await _dio.post(
      '/$chatId/add-participant',
      data: {'participantId': participantId},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add participant');
    }
  }

  // Remove participant from group chat
  static Future<void> removeParticipant(String chatId, String participantId) async {
    await setAuthToken();
    final response = await _dio.post(
      '/$chatId/remove-participant',
      data: {'participantId': participantId},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove participant');
    }
  }

  // Update group name
  static Future<void> updateGroupName(String chatId, String groupName) async {
    await setAuthToken();
    final response = await _dio.patch(
      '/$chatId/group-name',
      data: {'groupName': groupName},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update group name');
    }
  }

  // Delete a chat
  static Future<void> deleteChat(String chatId) async {
    await setAuthToken();
    final response = await _dio.delete('/$chatId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete chat');
    }
  }
}

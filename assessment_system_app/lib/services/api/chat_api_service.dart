import '../../constants/api_constants.dart';
import 'http_client.dart';

class ChatApiService {
  final HttpClient _httpClient = HttpClient();

  Future<Map<String, dynamic>> sendAIMessage(String message) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.chatAi,
        data: {'message': message},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _httpClient.get(ApiConstants.chatConversations);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await _httpClient.get(ApiConstants.chatUsers);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> markMessagesAsRead(String userId) async {
    try {
      final response = await _httpClient.put('${ApiConstants.chatMarkRead}/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getChatHistory(String userId) async {
    try {
      final response = await _httpClient.get('${ApiConstants.chatHistory}/$userId');
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.chatSend,
        data: data,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAlumniDirectory() async {
    try {
      final response = await _httpClient.get('/users/alumni-directory');
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error.response?.data != null) {
      if (error.response.data is Map<String, dynamic> &&
          error.response.data.containsKey('message')) {
        return error.response.data['message'];
      }
      return error.response.data.toString();
    }
    return 'An unexpected error occurred';
  }
}
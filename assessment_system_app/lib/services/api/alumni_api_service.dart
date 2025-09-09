import '../../constants/api_constants.dart';
import 'http_client.dart';

class AlumniApiService {
  final HttpClient _httpClient = HttpClient();

  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await _httpClient.get('${ApiConstants.alumniProfile}/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> submitEventRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.alumniEventsRequest,
        data: requestData,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getApprovedEvents() async {
    try {
      final response = await _httpClient.get(ApiConstants.alumniEventsApproved);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Management-to-Alumni Event Requests (Alumni side)
  Future<List<dynamic>> getPendingManagementRequests() async {
    try {
      final response = await _httpClient.get(ApiConstants.alumniPendingRequests);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> acceptManagementEventRequest(
    String requestId,
    String responseMessage,
  ) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.alumniAcceptManagementRequest}/$requestId',
        data: {'response': responseMessage},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> rejectManagementEventRequest(
    String requestId,
    String reason,
  ) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.alumniRejectManagementRequest}/$requestId',
        data: {'reason': reason},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAlumniStats() async {
    try {
      final response = await _httpClient.get(ApiConstants.alumniStats);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Alumni Profile Management
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _httpClient.get(ApiConstants.alumniMyProfile);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _httpClient.put(
        ApiConstants.alumniMyProfile,
        data: profileData,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCompleteProfile(String userId) async {
    try {
      final response = await _httpClient.get('${ApiConstants.alumniCompleteProfile}/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendConnectionRequest(
    String recipientId, {
    String? message,
  }) async {
    try {
      final response = await _httpClient.post(
        '/connections/send-request',
        data: {
          'recipientId': recipientId,
          'message': message ?? 'I would like to connect with you.',
        },
      );
      return response.data;
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
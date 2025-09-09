import '../../constants/api_constants.dart';
import 'http_client.dart';

class EventsApiService {
  final HttpClient _httpClient = HttpClient();

  Future<List<dynamic>> getApprovedEvents() async {
    try {
      final response = await _httpClient.get(ApiConstants.eventsApproved);
      return response.data as List<dynamic>;
    } catch (e) {
      // If authenticated API fails, try debug endpoint as fallback
      try {
        final fallbackResponse = await _httpClient.get(ApiConstants.debugEvents);
        if (fallbackResponse.data is Map<String, dynamic> &&
            fallbackResponse.data.containsKey('events')) {
          return fallbackResponse.data['events'] as List<dynamic>;
        }
        return [];
      } catch (fallbackError) {
        print('Fallback events API also failed: $fallbackError');
        throw _handleError(e);
      }
    }
  }

  Future<Map<String, dynamic>> updateAttendance(
    String eventId,
    bool attending,
  ) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.eventsAttendance.replaceAll('/attendance', '')}/$eventId/attendance',
        data: {'attending': attending},
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
import '../../constants/api_constants.dart';
import 'http_client.dart';

class ManagementApiService {
  final HttpClient _httpClient = HttpClient();

  // Dashboard and Stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementStats);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getStudentHeatmap(String studentId) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.managementStats.replaceAll('/stats', '')}/student/$studentId/heatmap',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Alumni Management
  Future<List<dynamic>> getAlumniApplications() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementAlumni);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> approveAlumni(String alumniId, bool approved) async {
    try {
      final response = await _httpClient.put(
        '${ApiConstants.managementAlumni}/$alumniId/status',
        data: {'approved': approved},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> searchStudents(String email) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.managementStudentsSearch}?email=$email',
      );
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getApprovedAlumni() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementAlumniAvailable);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Alumni Event Request Management
  Future<List<dynamic>> getAllAlumniEventRequests() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementAlumniEventRequests);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> approveAlumniEventRequest(String requestId) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.managementAlumniEventRequests}/$requestId/approve',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> rejectAlumniEventRequest(
    String requestId, {
    String? reason,
  }) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.managementAlumniEventRequests}/$requestId/reject',
        data: reason != null ? {'reason': reason} : null,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Management-to-Alumni Event Requests
  Future<Map<String, dynamic>> requestEventFromAlumni(
    String alumniId,
    Map<String, dynamic> requestData,
  ) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.managementRequestAlumniEvent}/$alumniId',
        data: requestData,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAllManagementEventRequests() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementEventRequests);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Student ATS Analysis Management
  Future<Map<String, dynamic>> getStudentATSData(String studentId) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.managementStats.replaceAll('/stats', '')}/student/$studentId/ats-data',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAllStudentsATS() async {
    try {
      final response = await _httpClient.get(ApiConstants.managementStudentsAts);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getStudentResume(
    String studentId,
    String resumeId,
  ) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.managementStats.replaceAll('/stats', '')}/student/$studentId/resume/$resumeId',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> downloadStudentResume(
    String studentId,
    String resumeId,
  ) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.managementStats.replaceAll('/stats', '')}/student/$studentId/resume/$resumeId/download',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // AI-Powered Student Analysis
  Future<List<dynamic>> analyzeStudentsBySkills(String query) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.managementAiStudentAnalysis,
        data: {'query': query},
      );
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> searchStudentProfiles(Map<String, dynamic> criteria) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.managementSearchStudentProfiles,
        data: criteria,
      );
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
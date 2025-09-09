import '../../constants/api_constants.dart';
import 'http_client.dart';

class AssessmentApiService {
  final HttpClient _httpClient = HttpClient();

  Future<Map<String, dynamic>> generateAIAssessment({
    required String domain,
    required String difficulty,
    required int numberOfQuestions,
  }) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.generateAiAssessment,
        data: {
          'domain': domain,
          'difficulty': difficulty,
          'numberOfQuestions': numberOfQuestions,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getStudentAssessments() async {
    try {
      final response = await _httpClient.get(ApiConstants.studentAssessments);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> submitAssessment(
    String assessmentId,
    Map<String, dynamic> submission,
  ) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.assessments}/$assessmentId/submit',
        data: submission,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAssessmentResults(String assessmentId) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.assessments}/$assessmentId/results',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createAssessment(Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.assessments,
        data: data,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getProfessorAssessments() async {
    try {
      final response = await _httpClient.get(ApiConstants.professorAssessments);
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> searchStudents(String query) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.searchStudents}?query=$query',
      );
      return response.data as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateAssessment(
    String assessmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _httpClient.put(
        '${ApiConstants.assessments}/$assessmentId',
        data: data,
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
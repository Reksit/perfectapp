import '../../models/auth/user.dart';
import '../../models/auth/login_request.dart';
import '../../constants/api_constants.dart';
import 'http_client.dart';

class AuthApiService {
  final HttpClient _httpClient = HttpClient();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.signin,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.signup,
        data: request.toJson(),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOTP(OTPVerificationRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.verifyOtp,
        data: request.toJson(),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resendOTP(String email) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.resendOtp}?email=$email',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
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
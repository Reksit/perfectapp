import '../../constants/api_constants.dart';
import '../../models/auth/login_request.dart';
import 'http_client.dart';

class AuthApiService {
  final HttpClient _httpClient = HttpClient();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      await _httpClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> verifyOTP(OTPVerificationRequest request) async {
    try {
      await _httpClient.post(
        ApiConstants.verifyOtp,
        data: request.toJson(),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      await _httpClient.post(
        '${ApiConstants.resendOtp}?email=$email',
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _httpClient.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
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
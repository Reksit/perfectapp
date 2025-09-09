import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/auth/user.dart';
import '../../models/auth/login_request.dart';
import '../../services/api/auth_api_service.dart';
import '../../services/storage/secure_storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _loading = true;
  bool _isValidating = false;

  final AuthApiService _authApiService = AuthApiService();
  final SecureStorageService _storage = SecureStorageService();

  User? get user => _user;
  String? get token => _token;
  bool get loading => _loading || _isValidating;
  bool get isAuthenticated => _user != null && _token != null;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _validateStoredAuth();
  }

  Future<void> _validateStoredAuth() async {
    try {
      final storedToken = await _storage.getToken();
      final storedUser = await _storage.getUserData();

      if (storedToken != null && storedUser != null) {
        // Parse and validate token structure
        final tokenParts = storedToken.split('.');
        if (tokenParts.length == 3) {
          try {
            final payload = json.decode(
              utf8.decode(base64Url.decode(base64Url.normalize(tokenParts[1]))),
            );
            final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

            // Check if token is expired (with 1 minute buffer)
            if (payload['exp'] != null && payload['exp'] > (currentTime + 60)) {
              _token = storedToken;
              _user = User.fromJson(json.decode(storedUser));
              debugPrint('Valid token found, user authenticated');
            } else {
              // Token is expired or about to expire
              debugPrint('Token expired, clearing storage');
              await _clearAuthData();
            }
          } catch (e) {
            // Error parsing token, clear storage
            debugPrint('Error parsing token, clearing storage: $e');
            await _clearAuthData();
          }
        } else {
          // Invalid token format
          debugPrint('Invalid token format, clearing storage');
          await _clearAuthData();
        }
      } else {
        debugPrint('No stored token or user found');
      }
    } catch (e) {
      debugPrint('Error validating stored auth: $e');
      await _clearAuthData();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isValidating = true;
      notifyListeners();

      final request = LoginRequest(email: email, password: password);
      final response = await _authApiService.login(request);

      final userData = User(
        id: response.id,
        email: response.email,
        name: response.name,
        role: response.role,
        department: response.department,
        className: response.className,
        phoneNumber: response.phoneNumber,
        verified: response.verified,
      );

      _user = userData;
      _token = response.accessToken;

      await _storage.saveToken(response.accessToken);
      await _storage.saveUserData(json.encode(userData.toJson()));

      debugPrint('Login successful, user data: ${userData.toJson()}');

      Fluttertoast.showToast(
        msg: 'Login successful!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      debugPrint('Login error: $error');
      throw Exception(error.toString());
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      _isValidating = true;
      notifyListeners();

      await _authApiService.register(request);

      Fluttertoast.showToast(
        msg: 'Registration successful! Please verify your email.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      debugPrint('Registration error: $error');
      throw Exception(error.toString());
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      _isValidating = true;
      notifyListeners();

      final request = OTPVerificationRequest(email: email, otp: otp);
      await _authApiService.verifyOTP(request);

      Fluttertoast.showToast(
        msg: 'Email verified successfully! You can now login.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      debugPrint('OTP verification error: $error');
      throw Exception(error.toString());
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      await _authApiService.resendOTP(email);

      Fluttertoast.showToast(
        msg: 'OTP sent to your email.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      debugPrint('Resend OTP error: $error');
      throw Exception(error.toString());
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      Fluttertoast.showToast(
        msg: 'Password changed successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      debugPrint('Change password error: $error');
      throw Exception(error.toString());
    }
  }

  Future<void> logout() async {
    debugPrint('Logging out user');
    await _clearAuthData();
    notifyListeners();

    Fluttertoast.showToast(
      msg: 'Logged out successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  Future<void> _clearAuthData() async {
    _user = null;
    _token = null;
    await _storage.clearAll();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    _storage.saveUserData(json.encode(updatedUser.toJson()));
    notifyListeners();
  }
}
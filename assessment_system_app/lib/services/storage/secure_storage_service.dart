import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Token management
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _completedAssessmentsKey = 'completed_assessments';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // User data management
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: _userKey);
  }

  // Completed assessments
  Future<void> saveCompletedAssessments(String assessments) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_completedAssessmentsKey, assessments);
  }

  Future<String?> getCompletedAssessments() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_completedAssessmentsKey);
  }

  Future<void> deleteCompletedAssessments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedAssessmentsKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    
    // Clear app-specific preferences
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('app_') || key.startsWith('assessment_')) {
        await prefs.remove(key);
      }
    }
    await prefs.remove(_completedAssessmentsKey);
  }

  // Generic secure storage methods
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Login
  Future<User> login(String email, String password) async {
    final response = await _api.post(
      ApiConfig.login,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    String? token;
    Map<String, dynamic> userData = {};

    if (response is Map<String, dynamic>) {
      token = response['token']?.toString() ??
          response['access_token']?.toString() ??
          (response['data'] is Map ? response['data']['token']?.toString() : null);

      if (response['user'] is Map<String, dynamic>) {
        userData = response['user'];
      } else if (response['data'] is Map<String, dynamic>) {
        if (response['data']['user'] is Map<String, dynamic>) {
          userData = response['data']['user'];
        } else {
          userData = response['data'];
        }
      }
    }

    if (token == null || token.isEmpty) {
      throw ApiException('Authentication token missing from server response.');
    }

    final user = User.fromJson(userData, token: token);
    await saveUserSession(user, token);
    return user;
  }

  // Register
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? address,
  }) async {
    final response = await _api.post(
      ApiConfig.register,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null && phone.isNotEmpty) 'phone': phone.trim(),
        if (address != null && address.isNotEmpty) 'address': address.trim(),
      },
    );

    String? token;
    Map<String, dynamic> userData = {};

    if (response is Map<String, dynamic>) {
      token = response['token']?.toString() ??
          response['access_token']?.toString() ??
          (response['data'] is Map ? response['data']['token']?.toString() : null);

      if (response['user'] is Map<String, dynamic>) {
        userData = response['user'];
      } else if (response['data'] is Map<String, dynamic>) {
        if (response['data']['user'] is Map<String, dynamic>) {
          userData = response['data']['user'];
        } else {
          userData = response['data'];
        }
      }
    }

    // Even if registration requires explicit login afterwards, or returns auto-login token:
    final user = User.fromJson(userData, token: token);
    if (token != null && token.isNotEmpty) {
      await saveUserSession(user, token);
    }
    return user;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } catch (_) {
      // Clear locally even if network fails
    } finally {
      await clearUserSession();
    }
  }

  // Get Profile
  Future<User> getProfile() async {
    final response = await _api.get(ApiConfig.profile);
    Map<String, dynamic> userData = {};

    if (response is Map<String, dynamic>) {
      if (response['user'] is Map<String, dynamic>) {
        userData = response['user'];
      } else if (response['data'] is Map<String, dynamic>) {
        userData = response['data']['user'] is Map<String, dynamic>
            ? response['data']['user']
            : response['data'];
      } else {
        userData = response;
      }
    }

    final token = await _api.getAuthToken();
    final user = User.fromJson(userData, token: token);
    await _saveUserData(user);
    return user;
  }

  // Update Profile
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    final response = await _api.put(
      ApiConfig.updateProfile,
      body: {
        if (name != null) 'name': name.trim(),
        if (phone != null) 'phone': phone.trim(),
        if (address != null) 'address': address.trim(),
      },
    );

    Map<String, dynamic> userData = {};
    if (response is Map<String, dynamic>) {
      if (response['user'] is Map<String, dynamic>) {
        userData = response['user'];
      } else if (response['data'] is Map<String, dynamic>) {
        userData = response['data']['user'] is Map<String, dynamic>
            ? response['data']['user']
            : response['data'];
      } else {
        userData = response;
      }
    }

    final token = await _api.getAuthToken();
    final user = User.fromJson(userData, token: token);
    await _saveUserData(user);
    return user;
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    await _api.post(
      ApiConfig.changePassword,
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );
  }

  // Session Management Helpers
  Future<void> saveUserSession(User user, String token) async {
    _api.setAuthToken(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAuthToken, token);
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setString(AppConstants.keyUserData, jsonEncode(user.toJson()));
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserData, jsonEncode(user.toJson()));
  }

  Future<User?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.keyUserData);
    final token = prefs.getString(AppConstants.keyAuthToken);

    if (userJson != null && token != null) {
      _api.setAuthToken(token);
      try {
        final decoded = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(decoded, token: token);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyAuthToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> clearUserSession() async {
    await _api.clearAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
    await prefs.remove(AppConstants.keyUserData);
    await prefs.setBool(AppConstants.keyIsLoggedIn, false);
  }
}

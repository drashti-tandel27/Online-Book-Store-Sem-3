import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Auto-login check on app launch
  Future<bool> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cachedUser = await _authService.getCachedUser();
      if (cachedUser != null) {
        _user = cachedUser;
        // Verify profile silently in background
        _refreshProfileSilently();
      }
    } catch (_) {
      _user = null;
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }

    return isAuthenticated;
  }

  Future<void> _refreshProfileSilently() async {
    try {
      final freshUser = await _authService.getProfile();
      _user = freshUser;
      notifyListeners();
    } catch (_) {}
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.firstError;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        address: address,
      );

      // If token was returned, user is auto-logged in
      if (newUser.token != null && newUser.token!.isNotEmpty) {
        _user = newUser;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.firstError;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update Profile
  Future<bool> updateProfile({String? name, String? phone, String? address}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.updateProfile(name: name, phone: phone, address: address);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.firstError;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change Password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.firstError;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

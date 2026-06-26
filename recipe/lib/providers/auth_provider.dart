import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Manages authentication state — login, register, logout, auto-login.
class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// Try to auto-login using saved token (called on app start)
  Future<bool> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.tryAutoLogin();
      if (result['success'] == true) {
        _user = result['user'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {
      // Auto-login failed silently
    }

    _isLoading = false;
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  /// Register a new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result['success'] == true) {
        _user = result['user'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login an existing user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _user = result['user'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout and clear all auth state
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

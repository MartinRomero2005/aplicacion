import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;
  final AuthService _authService = AuthService();

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && !_user!.isGuest;
  bool get isGuest => _user?.isGuest ?? false;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final decoded = jsonDecode(userJson);
        _user = User(
          email: decoded['email'],
          token: decoded['token'],
          isGuest: decoded['isGuest'] ?? false,
        );
        notifyListeners();
      } catch (e) {
        // Error al decodificar, limpiar
        prefs.remove('user');
      }
    }
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode({
      'email': user.email,
      'token': user.token,
      'isGuest': user.isGuest,
    }));
  }

  Future<bool> register(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.register(email, password);

    if (result['success']) {
      _user = User(
        email: email,
        token: result['data']['token'],
      );
      await _saveUserToPrefs(_user!);
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result['success']) {
      _user = result['data'];
      await _saveUserToPrefs(_user!);
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  void loginAsGuest() {
    _user = User.guest();
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _error = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

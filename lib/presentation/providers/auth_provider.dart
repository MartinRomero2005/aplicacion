import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  String? _error;
  bool _isLoading = false;
  bool _isGuest = false;

  // =========================
  // GETTERS
  // =========================

  Map<String, dynamic>? get user => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  bool get isGuest => _isGuest;

  bool get loading => _isLoading;

  String? get error => _error;

  // =========================
  // REGISTER
  // =========================

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);

      // 🔥 Aceptamos 200 o 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si backend devuelve usuario
        if (data["user"] != null) {
          _currentUser = data["user"];
        } else {
          // Si backend NO devuelve usuario, lo creamos manualmente
          _currentUser = {"name": name, "email": email};
        }

        _isGuest = false;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data["message"] ?? "Registration failed";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      _error = "Connection error";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _isGuest = false;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _currentUser = data["user"];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data["message"] ?? "Login failed";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      _error = "Connection error";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =========================
  // LOGIN COMO INVITADO
  // =========================

  void loginAsGuest() {
    _currentUser = null;
    _isGuest = true;
    notifyListeners();
  }

  // =========================
  // LOGOUT
  // =========================

  void logout() {
    _currentUser = null;
    _isGuest = false;
    notifyListeners();
  }
}

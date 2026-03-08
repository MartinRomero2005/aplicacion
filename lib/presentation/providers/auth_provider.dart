import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentUser;
  bool _isGuest = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isGuest => _isGuest;
  bool get isAuthenticated => _currentUser != null || _isGuest;

  final String baseUrl = "http://192.168.1.4:3000/api/auth";

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _currentUser = data["user"];
        _isGuest = false;
        notifyListeners();
        return true;
      } else {
        _error = data["message"] ?? "Error en el registro";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "Error de conexión con el servidor";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _currentUser = data["user"];
        _isGuest = false;
        notifyListeners();
        return true;
      } else {
        _error = data["message"] ?? "Credenciales incorrectas";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "No se pudo conectar al servidor";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmail(String email) async {
    _setLoading(true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-email"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _error = data["message"] ?? "Correo no encontrado";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "Error de conexión";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    _setLoading(true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": newPassword}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _error = data["message"] ?? "No se pudo cambiar la contraseña";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "Error de conexión";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void loginAsGuest() {
    _isGuest = true;
    _currentUser = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isGuest = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _error = null;
    notifyListeners();
  }
}

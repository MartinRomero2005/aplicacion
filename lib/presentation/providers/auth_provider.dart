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

  // Detecta si es debug (emulador) o release (APK)
  final String baseUrl = const bool.fromEnvironment('dart.vm.product')
      ? "http://192.168.1.4:3000/api/auth"
      : "http://10.0.2.2:3000/api/auth";

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);

    try {
      print("REGISTER → $baseUrl/register");

      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

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
      print("REGISTER ERROR: $e");
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
      print("LOGIN → $baseUrl/login");
      print("EMAIL: $email");

      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

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
      print("LOGIN ERROR: $e");
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
      print("VERIFY EMAIL → $baseUrl/verify-email");
      print("EMAIL: $email");

      final response = await http.post(
        Uri.parse("$baseUrl/verify-email"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        _error = "Correo no encontrado";
        notifyListeners();
        return false;
      } else {
        _error = data["message"] ?? "Error del servidor";
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("VERIFY ERROR: $e");
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
      print("RESET PASSWORD → $baseUrl/reset-password");

      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": newPassword}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _error = data["message"] ?? "No se pudo cambiar la contraseña";
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("RESET ERROR: $e");
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

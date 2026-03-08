import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.4:3000/api/auth';

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'error': jsonDecode(response.body)['error'] ?? 'Error en registro',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': User(email: email, token: data['token']),
        };
      } else {
        return {
          'success': false,
          'error': jsonDecode(response.body)['error'] ?? 'Error en login',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: ${e.toString()}'};
    }
  }
}

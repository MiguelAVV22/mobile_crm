import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/user_session.dart';
import 'session_manager.dart';

class AuthService {
  /// Inicia sesión contra la base de datos a través de Spring Boot
  static Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final session = UserSession.fromJson(data);
        await SessionManager.saveSession(session);
        return session;
      } else if (response.statusCode == 401) {
        throw 'Correo o contraseña incorrectos. Verifica tus credenciales.';
      } else {
        throw 'Error de servidor (${response.statusCode}). Intenta de nuevo.';
      }
    } catch (e) {
      if (e is String) rethrow;
      throw 'No se pudo conectar con el servidor en ${ApiConstants.baseUrl}. Asegúrate de que el backend esté activo.';
    }
  }

  /// Registra una nueva cuenta de cliente directamente en la base de datos
  static Future<UserSession> registrarCliente({
    required String nombreCompleto,
    required String email,
    required String password,
    String? telefono,
    String? tenantSlug,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registroClienteUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombreCompleto': nombreCompleto.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'telefono': telefono?.trim(),
          'tenantSlug': tenantSlug,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final session = UserSession.fromJson(data);
        await SessionManager.saveSession(session);
        return session;
      } else if (response.statusCode == 409) {
        throw 'El correo electrónico ya se encuentra registrado. Inicia sesión.';
      } else {
        throw 'Error al crear usuario (${response.statusCode}). Revisa los datos ingresados.';
      }
    } catch (e) {
      if (e is String) rethrow;
      throw 'Error de conexión con el servidor. Verifica tu red o backend local.';
    }
  }

  static Future<void> logout() async {
    await SessionManager.clearSession();
  }
}


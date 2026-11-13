import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Retorna la URL base según la plataforma de ejecución
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/v1';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // 10.0.2.2 mapea a localhost de la máquina anfitriona en el emulador Android
        return 'http://10.0.2.2:8080/api/v1';
      case TargetPlatform.iOS:
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      default:
        return 'http://localhost:8080/api/v1';
    }
  }

  // Endpoints de autenticación
  static String get loginUrl => '$baseUrl/auth/login';
  static String get registroClienteUrl => '$baseUrl/auth/registro-cliente';
}


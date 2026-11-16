import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Permite inyectar la URL de producción al compilar o ejecutar mediante:
  /// flutter run --dart-define=BACKEND_URL=https://tu-servidor.com/api/v1
  /// flutter build apk --dart-define=BACKEND_URL=https://tu-servidor.com/api/v1
  static const String _envBaseUrl = String.fromEnvironment('BACKEND_URL');

  /// Retorna la URL base según el entorno y la plataforma de ejecución
  static String get baseUrl {
    // 1. Si se especificó una URL personalizada (en producción o por parámetro)
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    // 2. Si es ejecución Web (Chrome)
    if (kIsWeb) {
      return 'http://localhost:8080/api/v1';
    }

    // 3. Si es emulador o dispositivo móvil
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // 10.0.2.2 mapea a localhost de la máquina anfitriona en el emulador Android de Android Studio
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


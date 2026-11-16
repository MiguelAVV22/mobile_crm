import 'package:flutter/foundation.dart';

class ApiConstants {
  /// URL del backend desplegado en la nube (AWS EC2 / Producción)
  static const String remoteUrl = 'http://3.236.30.202:8080/api/v1';

  /// Cambia a 'true' si deseas probar en localhost en lugar del servidor desplegado
  static const bool useLocalhost = false;

  /// Permite inyectar la URL al compilar o ejecutar mediante:
  /// flutter run --dart-define=BACKEND_URL=http://3.236.30.202:8080/api/v1
  /// flutter build apk --dart-define=BACKEND_URL=http://3.236.30.202:8080/api/v1
  static const String _envBaseUrl = String.fromEnvironment('BACKEND_URL');

  /// Retorna la URL base según el entorno y la configuración activa
  static String get baseUrl {
    // 1. Si se especificó una URL personalizada por consola (--dart-define)
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    // 2. Si se especificó desarrollo local
    if (useLocalhost) {
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

    // 3. Por defecto apunta al servidor remoto desplegado en AWS
    return remoteUrl;
  }

  // Endpoints de autenticación
  static String get loginUrl => '$baseUrl/auth/login';
  static String get registroClienteUrl => '$baseUrl/auth/registro-cliente';
}


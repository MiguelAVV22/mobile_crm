import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class TiendaService {
  /// Obtiene los productos del catálogo de una tienda pública por su subdominio/slug
  static Future<List<Map<String, dynamic>>> getCatalogo(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/tienda/$slug/catalogo'),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return list.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }
}

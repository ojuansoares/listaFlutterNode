import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'platform_info.dart';

class ApiService {
  // Use conditional helper to pick proper host for web / android emulator / desktop
  static String get baseUrl => getBaseUrl();

  /// Busca notícias do servidor.
  /// Timeout aumentado para 30s e tratamento explícito de TimeoutException.
  static Future<List<Article>> fetchNoticias() async {
    final uri = Uri.parse('$baseUrl/noticias');
    try {
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Falha ao carregar notícias: ${response.statusCode}');
      }

      final dynamic body = json.decode(response.body);

      List<dynamic> noticiasJson;
      if (body is List) {
        noticiasJson = body;
      } else if (body is Map && body['success'] == true && body['data'] is List) {
        noticiasJson = body['data'];
      } else {
        throw Exception('Resposta da API em formato inesperado');
      }

      return noticiasJson.map((j) => Article.fromJson(j)).toList();
    } on TimeoutException {
      throw Exception('Erro de conexão: Timeout ao acessar $uri');
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarefa.dart';
import 'platform_info.dart';

class TarefaService {
  // base host chosen per platform; append /tarefas when building URIs
  String get _host => getBaseUrl();
  String get _baseUrl => '$_host/tarefas';
  static const Duration _timeout = Duration(seconds: 30);

  Future<List<Tarefa>> getTarefas() async {
    try {
  final response = await http.get(Uri.parse(_baseUrl)).timeout(_timeout);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Tarefa> tarefas = body.map((item) => Tarefa.fromJson(item)).toList();
        return tarefas;
      } else {
        throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Tarefa> createTarefa(String titulo, String descricao) async {
    try {
      final response = await http
          .post(Uri.parse(_baseUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'titulo': titulo,
        'descricao': descricao,
      })).timeout(_timeout);

      if (response.statusCode == 201) {
        return Tarefa.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao criar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Tarefa> updateTarefa(Tarefa tarefa) async {
    try {
      final response = await http
          .put(Uri.parse('$_baseUrl/${tarefa.id}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(tarefa.toJson()))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Tarefa.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao atualizar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<void> deleteTarefa(String id) async {
    try {
  final response = await http.delete(Uri.parse('$_baseUrl/$id')).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar tarefa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}

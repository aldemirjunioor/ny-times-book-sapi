// lib/services/nyt_books_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/book.dart';

class NytBooksService {
  // ATENÇÃO: Esta chave é do Firebase e não funcionará com a API do NYT.
  // Substitua pela sua chave de API real do New York Times.
  final String _apiKey = '9Z8gCCQUfrYA7NUceSh89peDjYzABkML';
  final String _baseUrl = 'https://api.nytimes.com/svc/books/v3';

  Future<List<Book>> getBestSellers() async {
    final url =
        '$_baseUrl/lists/current/hardcover-fiction.json?api-key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificação para garantir que os campos existem antes de acessá-los
        if (data.containsKey('results') &&
            data['results'] is Map &&
            data['results'].containsKey('books')) {
          final List<dynamic> booksJson = data['results']['books'];
          return booksJson.map((json) => Book.fromJson(json)).toList();
        } else {
          throw Exception(
              'A resposta da API não contém a lista de livros esperada.');
        }
      } else {
        // Trata erros de resposta da API com mais detalhes
        throw Exception(
            'Falha ao carregar os best-sellers. Código de status: ${response.statusCode}, Corpo: ${response.body}');
      }
    } catch (e) {
      // Trata outros erros (ex: rede, parsing)
      throw Exception('Falha ao carregar os best-sellers: $e');
    }
  }
}

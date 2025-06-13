import 'package:flutter/material.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/services/nyt_books_service.dart';

class BooksController {
  final NytBooksService _booksService = NytBooksService();

  final ValueNotifier<List<Book>> books = ValueNotifier<List<Book>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');

  Future<void> fetchBestSellers() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedBooks = await _booksService.getBestSellers();
      books.value = fetchedBooks;
    } catch (e) {
      if (e.toString().contains('401')) {
        errorMessage.value = 'Chave de API inválida. Verifique o arquivo lib/services/nyt_books_service.dart.';
      } else {
        errorMessage.value = 'Erro ao carregar os livros: ${e.toString()}';
      }
      books.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}

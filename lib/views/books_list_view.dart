import 'package:flutter/material.dart';
import 'package:myapp/controllers/books_controller.dart';
import 'package:myapp/controllers/favorites_controller.dart';
import 'package:shimmer/shimmer.dart';

class BooksListView extends StatefulWidget {
  final BooksController booksController;
  final FavoritesController favoritesController;

  const BooksListView({
    super.key,
    required this.booksController,
    required this.favoritesController,
  });

  @override
  _BooksListViewState createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  @override
  void initState() {
    super.initState();
    if (widget.booksController.books.value.isEmpty) {
      widget.booksController.fetchBestSellers();
    }
  }
  
  // Widget para o efeito shimmer
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10, // Número de placeholders
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 50.0, height: 75.0, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(width: double.infinity, height: 16.0, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 150.0, height: 14.0, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.booksController.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return _buildShimmerEffect();
        }

        return ValueListenableBuilder<String>(
          valueListenable: widget.booksController.errorMessage,
          builder: (context, errorMessage, _) {
            if (errorMessage.isNotEmpty) {
              return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(errorMessage, textAlign: TextAlign.center)));
            }
            
            return ValueListenableBuilder<Set<String>>(
              valueListenable: widget.favoritesController.favoriteBookIsbns,
              builder: (context, favoriteIsbns, _) {
                final books = widget.booksController.books.value;

                if (books.isEmpty) {
                  return const Center(child: Text('Nenhum livro encontrado.'));
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isFavorite = favoriteIsbns.contains(book.isbn);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: book.bookImage.isNotEmpty
                              ? Image.network(book.bookImage, width: 50, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40))
                              : const Icon(Icons.book, size: 40),
                        ),
                        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(book.author),
                        trailing: IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                          color: isFavorite ? Theme.of(context).colorScheme.secondary : Colors.grey,
                          onPressed: () => widget.favoritesController.toggleFavorite(book),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

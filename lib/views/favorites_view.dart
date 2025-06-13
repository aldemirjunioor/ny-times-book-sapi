import 'package:flutter/material.dart';
import 'package:myapp/controllers/favorites_controller.dart';
import 'package:myapp/models/book.dart';

class FavoritesView extends StatelessWidget {
  final FavoritesController favoritesController;

  const FavoritesView({super.key, required this.favoritesController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: favoritesController.getFavoritesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar favoritos: ${snapshot.error}'));
        }

        final favoriteBooks = snapshot.data ?? [];

        if (favoriteBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Sua lista de favoritos está vazia.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: favoriteBooks.length,
          itemBuilder: (context, index) {
            final book = favoriteBooks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: book.bookImage.isNotEmpty
                      ? Image.network(book.bookImage, width: 50, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 40))
                      : const Icon(Icons.book, size: 40),
                ),
                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(book.author),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  onPressed: () => favoritesController.toggleFavorite(book),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Book {
  final String title;
  final String author;
  final String description;
  final String publisher;
  final String bookImage;
  final String isbn; // Usado como ID único

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.publisher,
    required this.bookImage,
    required this.isbn,
  });

  // Converte de JSON (API do NYT) para o objeto Book
  factory Book.fromJson(Map<String, dynamic> json) {
    // A API do NYT fornece vários ISBNs; pegamos o primeiro da lista.
    final isbn = (json['isbns'] as List<dynamic>?)?.first['isbn13'] ??
                 json['primary_isbn13'] ??
                 DateTime.now().millisecondsSinceEpoch.toString(); // Fallback para um ID único

    return Book(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'No Author',
      description: json['description'] ?? 'No Description',
      publisher: json['publisher'] ?? 'No Publisher',
      bookImage: json['book_image'] ?? '',
      isbn: isbn,
    );
  }

  // Converte de um Map (documento do Firestore) para o objeto Book
  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      title: map['title'] ?? 'No Title',
      author: map['author'] ?? 'No Author',
      description: map['description'] ?? 'No Description',
      publisher: map['publisher'] ?? 'No Publisher',
      bookImage: map['bookImage'] ?? '',
      isbn: id, // O ID do documento é o nosso ISBN
    );
  }

  // Converte o objeto Book para um Map (para salvar no Firestore)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'publisher': publisher,
      'bookImage': bookImage,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/book.dart';

class FavoritesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referência para a coleção de favoritos do usuário logado
  CollectionReference? _favoritesCollection;

  final ValueNotifier<Set<String>> _favoriteBookIsbns = ValueNotifier<Set<String>>({});
  ValueNotifier<Set<String>> get favoriteBookIsbns => _favoriteBookIsbns;

  FavoritesController() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _favoritesCollection = _firestore.collection('users').doc(user.uid).collection('favorites');
        _listenToFavorites();
      } else {
        _favoritesCollection = null;
        _favoriteBookIsbns.value = {};
      }
    });
  }

  // Escuta as mudanças na coleção de favoritos em tempo real
  void _listenToFavorites() {
    _favoritesCollection?.snapshots().listen((snapshot) {
      final isbns = snapshot.docs.map((doc) => doc.id).toSet();
      _favoriteBookIsbns.value = isbns;
    });
  }

  // Retorna um Stream da lista de livros favoritos
  Stream<List<Book>> getFavoritesStream() {
    return _favoritesCollection?.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    }) ?? Stream.value([]);
  }

  // Adiciona ou remove um livro dos favoritos
  Future<void> toggleFavorite(Book book) async {
    if (_favoritesCollection == null) return;

    final isCurrentlyFavorite = _favoriteBookIsbns.value.contains(book.isbn);

    if (isCurrentlyFavorite) {
      // Remove dos favoritos
      await _favoritesCollection!.doc(book.isbn).delete();
    } else {
      // Adiciona aos favoritos
      await _favoritesCollection!.doc(book.isbn).set(book.toJson());
    }
  }
}

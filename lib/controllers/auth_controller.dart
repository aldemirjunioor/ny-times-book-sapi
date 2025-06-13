import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para monitorar o estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Cadastro (Sign Up)
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(context, e.message);
    } catch (e) {
      _showErrorSnackbar(context, 'Ocorreu um erro inesperado.');
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(context, e.message);
    } catch (e) {
      _showErrorSnackbar(context, 'Ocorreu um erro inesperado.');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper para mostrar erros
  void _showErrorSnackbar(BuildContext context, String? message) {
    if (message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/controllers/auth_controller.dart';
import 'package:myapp/controllers/books_controller.dart';
import 'package:myapp/controllers/favorites_controller.dart';
import 'package:myapp/views/auth_screen.dart';
import 'package:myapp/views/home_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializa todos os controllers
    final authController = AuthController();
    final booksController = BooksController();
    final favoritesController = FavoritesController();

    return MaterialApp(
      title: 'Flutter Auth & NYT Books',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        
        // CORREÇÃO: ColorScheme.fromSeed só deve ter os parâmetros válidos.
        // As outras cores são geradas a partir da `seedColor`.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
          secondary: const Color.fromARGB(255, 209, 15, 15), // A cor de acento pode ser sobrescrita
        ),
        
        // CORREÇÃO: A cor de fundo geral do app é definida aqui.
        scaffoldBackgroundColor: Colors.grey.shade50,
        
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade800,
          elevation: 1,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white, // Define a cor do card explicitamente
          surfaceTintColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1E3A8A),
          unselectedItemColor: Colors.grey.shade500,
          elevation: 2,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: authController.authStateChanges,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (userSnapshot.hasData) {
            return HomeView(
              authController: authController,
              booksController: booksController,
              favoritesController: favoritesController,
            );
          }
          return AuthScreen(authController: authController);
        },
      ),
    );
  }
}

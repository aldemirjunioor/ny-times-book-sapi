import 'package:flutter/material.dart';
import 'package:myapp/controllers/auth_controller.dart';
import 'package:myapp/controllers/books_controller.dart';
import 'package:myapp/controllers/favorites_controller.dart';
import 'package:myapp/views/books_list_view.dart';
import 'package:myapp/views/favorites_view.dart';

class HomeView extends StatefulWidget {
  final AuthController authController;
  final BooksController booksController;
  final FavoritesController favoritesController;

  const HomeView({
    super.key,
    required this.authController,
    required this.booksController,
    required this.favoritesController,
  });

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      BooksListView(
        booksController: widget.booksController,
        favoritesController: widget.favoritesController,
      ),
      FavoritesView(
        favoritesController: widget.favoritesController,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Best-Sellers' : 'Meus Favoritos',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => widget.authController.signOut(),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

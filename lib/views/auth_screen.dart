import 'package:flutter/material.dart';
import 'package:myapp/controllers/auth_controller.dart';
import 'package:myapp/views/login_view.dart';
import 'package:myapp/views/register_view.dart';

class AuthScreen extends StatefulWidget {
  final AuthController authController;
  const AuthScreen({super.key, required this.authController});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLoginView = true;

  void toggleViews() {
    setState(() {
      _showLoginView = !_showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: _showLoginView
            ? LoginView(
                authController: widget.authController,
                showRegisterView: toggleViews,
              )
            : RegisterView(
                authController: widget.authController,
                showLoginView: toggleViews,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  final AuthController authController;
  final VoidCallback showLoginView;

  const RegisterView({
    super.key,
    required this.authController,
    required this.showLoginView,
  });

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid != true) {
      return;
    }
    _formKey.currentState!.save();
    widget.authController.signUp(
      email: _userEmail,
      password: _userPassword,
      username: _userName,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  key: const ValueKey('username'),
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return 'Por favor, insira um nome com pelo menos 4 caracteres.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nome de usuário',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  onSaved: (value) {
                    _userName = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Endereço de e-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value == null || value.length < 7) {
                      return 'A senha deve ter pelo menos 7 caracteres.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
obscureText: true,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _trySubmit,
                    child: const Text('Cadastrar'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: widget.showLoginView,
                  child: const Text('Já tenho uma conta'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preference/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
          authProvider.login();
        }, child: const Text("Log In")),
      ),
    );
  }
}

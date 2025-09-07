
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:shared_preference/providers/auth_provider.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder : (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      }
    );
  }
}

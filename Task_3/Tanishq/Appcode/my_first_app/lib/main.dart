import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dice_roller.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If user is logged in, go to DiceRollerPage
          if (snapshot.hasData) {
            return DiceRollerPage(
              isDarkMode: isDarkMode,
              toggleTheme: toggleTheme,
            );
          }

          // Otherwise, show login page
          return LoginPage(
            isDarkMode: isDarkMode,
            toggleTheme: toggleTheme,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preference/providers/auth_provider.dart';
import 'package:shared_preference/providers/theme_provider.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
          title: "Flutter Session & Theme",
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
           themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
           debugShowCheckedModeBanner: false,
           home: const SplashScreen(),
          );
    },
        ),
    );
  }

}

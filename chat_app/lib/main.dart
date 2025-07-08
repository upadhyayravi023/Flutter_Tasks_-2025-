import 'package:chat_app/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'home_page.dart';

void main() {
  
  Gemini.init(apiKey: GEMINI_API_KEY);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pinkAccent,
      ),
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}



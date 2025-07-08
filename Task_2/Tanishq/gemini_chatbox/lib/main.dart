import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['Gemini_Key'] ?? '');
  runApp(const GeminiApp());
  print('API KEY: ${dotenv.env['Gemini_Key']}');
}

class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

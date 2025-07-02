import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('FATAL: Error loading .env file: $e');
    return;
  }

  final String? apiKeyFromEnv = dotenv.env['GEMINI_API_KEY'];

  if (apiKeyFromEnv == null || apiKeyFromEnv.isEmpty) {
    print('FATAL: GEMINI_API_KEY is not set or is empty in your .env file.');
    return;
  }

  Gemini.init(
    apiKey: apiKeyFromEnv,
  );

  runApp(const MyApp());
}

// You'd need to define ErrorApp and MyApp as in the previous example
// or your own app structure.

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}


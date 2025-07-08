import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: 'assets/geminipfp.jpg',
  );

  late String apiKey;

  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env['Gemini_Key'] ?? '';
  }

  @override
  Widget build(context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset('assets/geminilogo.png', width: 120),
      ),
      body: Stack(children: [Background(), _buildUI()]),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
        trailing: [
          IconButton(icon: Icon(Icons.attach_file), onPressed: _pickImage),
        ],
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    ChatMessage loadingMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Thinking...",
    );

    setState(() {
      messages = [loadingMessage, ...messages];
    });

    final endpoint =
        "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": chatMessage.text},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final String reply =
          (json["candidates"]?[0]["content"]["parts"]?[0]["text"] ??
                  "Sorry, no response.")
              .toString();

      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: reply,
        );
      });
    } else {
      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text:
              "Error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}",
        );
      });
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      ChatMessage imageMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        medias: [
          ChatMedia(
            url: pickedFile.path,
            fileName: pickedFile.name,
            type: MediaType.image,
          ),
        ],
      );

      setState(() {
        messages = [imageMessage, ...messages];
      });

      _sendImageForDescription(base64Image, mimeType: "image/png");
    }
  }

  void _sendImageForDescription(
    String base64Image, {
    required String mimeType,
  }) async {
    ChatMessage loadingMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Looking at the image...",
    );

    setState(() {
      messages = [loadingMessage, ...messages];
    });

    final endpoint =
        "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-pro:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": "Please describe this image in detail."},
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image},
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final String reply =
          (json["candidates"]?[0]["content"]["parts"]?[0]["text"] ??
                  "Sorry, no response.")
              .toString();

      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: reply,
        );
      });
    } else {
      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text:
              "Error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}",
        );
      });
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: 'GEMINI_API_KEY', // Replace with your actual API key
  );

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
    profileImage:
    "https://thefetus.net/site/cache/public/images/2024-w/2024-winner-image-for-gholamreza-azizi/fieldList/file_path/105072__740__740__down__95.png",
  );

  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
    "https://registry.npmmirror.com/@lobehub/icons-static-png/1.50.0/files/dark/gemini-color.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My AI Chatbot"),
        backgroundColor: const Color(0xFF00BFFF),
        titleTextStyle: GoogleFonts.lato(
          color: Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA9A9A9),
              Color(0xFFD3D3D3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        ),
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.blueAccent,
        showOtherUsersAvatar: true,
        showCurrentUserAvatar: true,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    final typingMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Typing...",
    );
    setState(() {
      messages = [typingMessage, ...messages];
    });

    try {
      final promptParts = <Part>[];

      if (chatMessage.text != null && chatMessage.text!.isNotEmpty) {
        promptParts.add(TextPart(chatMessage.text!));
      }

      if (chatMessage.medias?.isNotEmpty ?? false) {
        final Uint8List imageBytes = File(chatMessage.medias!.first.url).readAsBytesSync();
        promptParts.add(DataPart('image/jpeg', imageBytes));
      }

      final content = Content.multi(promptParts);
      final response = await model.generateContent([content]);

      setState(() {
        messages.removeWhere((m) => m.text == "Typing..." && m.user.id == geminiUser.id);
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response.text ?? "No response received.",
          ),
          ...messages,
        ];
      });
    } catch (e) {
      setState(() {
        messages.removeWhere((m) => m.text == "Typing..." && m.user.id == geminiUser.id);
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: "An error occurred: ${e.toString()}",
          ),
          ...messages,
        ];
      });
    }
  }

  void _sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe the image.",
        medias: [ChatMedia(url: file.path, fileName: "", type: MediaType.image)],
      );
      _sendMessage(chatMessage);
    }
  }
}

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Gemini gemini = Gemini.instance;
  
  ChatUser currentUser = ChatUser(
      id: "0",
      firstName: "You",
      profileImage: "https://tse3.mm.bing.net/th/id/OIP.lkVN1WDlcV2jQCq-9LT7-wHaIJ?rs=1&pid=ImgDetMain&o=7&rm=3"
  );
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage: "https://tse2.mm.bing.net/th/id/OIP.AsXti9JBcuEGIODbisEAYwHaEK?rs=1&pid=ImgDetMain&o=7&rm=3"
  );

  List<ChatMessage> messages = [];

  ChatMessage? _currentBotGeneratingMessage;

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages,
      typingUsers: _currentBotGeneratingMessage != null ? [geminiUser] : [],
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.add(chatMessage);
    });

    _currentBotGeneratingMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: '',
    );
    setState(() {
      messages.add(_currentBotGeneratingMessage!);
    });

    try {
      String question = chatMessage.text;
      gemini.promptStream(parts: [Part.text(question)]).listen((event) {
                String chunkText = "";

          if (event?.content != null && event?.content!.parts != null) {

            chunkText = event!.content!.parts!.fold("", (previous,current) {
              if (current is TextPart) {
                return "$previous ${current.text}";
              }
              return previous;
            });

          }

          if (chunkText.isNotEmpty && _currentBotGeneratingMessage != null) {
            setState(() {
              _currentBotGeneratingMessage!.text += chunkText;
            });
          }

        },
        onDone: () {
                setState(() {
                  _currentBotGeneratingMessage = null;
                });
        }
      );

    } catch (e) {
      print('error ${e}');
    }

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("My AI ChatBot", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,

      ),
      body: _buildUI(),
    );




  }
}
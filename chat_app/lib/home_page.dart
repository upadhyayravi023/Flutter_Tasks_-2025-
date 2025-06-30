import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("My AI ChatBot"),
      ),
      body: _buildUI(),
    );

    Widget _buildUI() {
      return DashChat(
          currentUser: currentUser, onSend: _sendMessage, messages: messages);
    }

    void _sendMessage(ChatMessage chatMessage) {
      setState(() {
        messages = [chatMessage, ...messages];
      });
    }
  }
}
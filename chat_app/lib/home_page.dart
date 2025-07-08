import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

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
      profileImage: "https://icon-library.com/images/female-user-icon/female-user-icon-8.jpg"
  );
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage: "https://tse2.mm.bing.net/th/id/OIP.AsXti9JBcuEGIODbisEAYwHaEK?rs=1&pid=ImgDetMain&o=7&rm=3"
  );

  List<ChatMessage> messages = [];

  ChatMessage? _currentBotGeneratingMessage;

  final ScrollController _scrollController = ScrollController();

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages.reversed.toList(),
      typingUsers: _currentBotGeneratingMessage != null ? [geminiUser] : [],
      messageListOptions: MessageListOptions(
        scrollController: _scrollController,
        showDateSeparator: true,
      ),
      messageOptions: MessageOptions(
        showOtherUsersAvatar: true,
        showOtherUsersName: true,
        showCurrentUserAvatar: true,
        currentUserContainerColor: Colors.blue,
        containerColor: Colors.grey,
        currentUserTextColor: Colors.black,
        borderRadius: 20,
        showTime: true,
        messagePadding: const EdgeInsets.all(20),


      ),
      inputOptions: InputOptions(
        inputToolbarPadding: const EdgeInsets.all(12),
        inputDecoration: InputDecoration(
          hintText: "Ask something...",
          filled: true,
        ),
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: Icon(Icons.image, color: Colors.blue, size: 40,))
        ]
      ),

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
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync()
        ];

      }

      List<Part> parts = [Part.text(question)];

      if (images != null) {
        parts.add(Part.uint8List(images.first));
      }

      gemini.promptStream(parts: parts).listen((event) {
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
        },
      );

    } catch (e) {
      print('error ${e}');
    }

  }

  void _sendMediaMessage () async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture?",
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image )
          ]
      );
      _sendMessage(chatMessage);
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
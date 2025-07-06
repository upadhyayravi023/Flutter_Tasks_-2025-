import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await dotenv.load(fileName: ".env");
  }catch(e){
    print("FATAL: Error loading .env file: $e");
    return;
  }

  final String apiKey = dotenv.env['API_KEY']!;
  Gemini.init(apiKey: apiKey);

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:Colors.blue)
      ),
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}
class homePage extends StatefulWidget {

  @override
  State<homePage> createState() => _homePageState();
}
class _homePageState extends State<homePage>{
  List<Content> chatHistory =[];
  final Gemini gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(id: "1", firstName: "You" ,profileImage:"assets/images/user.avif" );
  ChatUser bot = ChatUser(id: "2", firstName: "Gemini", profileImage: "assets/images/gemini.avif" );
  List<ChatMessage> messages= [];
  bool isGeminiTyping = false;
  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(" My ChatBot", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
      ),
      body: appUI(),
    );
  }
  Widget appUI(){
    return DashChat(
      inputOptions: InputOptions(trailing: [IconButton(
          onPressed: sendImage,
          icon: Icon(Icons.image_outlined, color: Colors.lightBlue[900],)
        )]),
        currentUser: currentUser,
        onSend: sendMessage,
        messages: messages,
      typingUsers: isGeminiTyping?[bot]:[],
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.blue[300],
        currentUserTextColor: Colors.black,
        containerColor: Colors.black26,
        textColor: Colors.black,
        borderRadius: 23,
        showCurrentUserAvatar: true,
        showTime: true,
       currentUserTimeTextColor: Colors.black54,
       timeTextColor: Colors.black54,
       showOtherUsersAvatar: true,
        messagePadding: EdgeInsets.only(left: 10, top:15, right: 10,bottom: 8)


      ),
    );
  }

  void sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      isGeminiTyping = true;
    });
    try {

      if(chatMessage.medias?.isNotEmpty ?? false){
        final imageFile = File(chatMessage.medias!.first.url);
        final Uint8List imageBytes = imageFile.readAsBytesSync();
        chatHistory.add(Content(role: 'user' , parts:[Part.uint8List(imageBytes)] ));
        gemini.streamChat( chatHistory).listen((event){
          handleEvent(event);
        },
        onDone: (){
          setState(() {
            isGeminiTyping = false;
          });
        },
          onError: (error){
          setState(() {
              isGeminiTyping = false;
            });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
          print(error);
        });
      }
      else {
        String question = chatMessage.text;
        chatHistory.add(Content(role: 'user',parts:[Part.text(question)] ));
        gemini.streamChat(chatHistory).listen((event){
          handleEvent(event);
        },
            onDone: (){
              setState(() {
                isGeminiTyping = false;
              });
            },
          onError: (error){
          setState(() {
            isGeminiTyping = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
          print(error);
          }

        );

      }
    } catch (e) {
      setState(() {
        isGeminiTyping = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
      print(e);
    }
  }

   void sendImage() async{
      ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if(image!=null){
        ChatMessage chatMessage = ChatMessage(user: currentUser, createdAt:DateTime.now(), medias: [ChatMedia(url: image.path, fileName: image.name, type:MediaType.image )], text: "Describe this image");
       sendMessage(chatMessage);
      }
   }

   void handleEvent(event){
     ChatMessage? lastMessage = messages.firstOrNull;
     String response = event?.content?.parts
         ?.whereType<TextPart>()
         .map((part) => part.text.trim() + " ")
         .join(" ") ?? "";
     if (lastMessage != null && lastMessage.user == bot) {
       lastMessage = messages.removeAt(0);
       lastMessage.text += response;
       setState(() {
         messages = [lastMessage!, ...messages];
       });
     }
     else {
       ChatMessage newMessage = ChatMessage(
           user: bot, createdAt: DateTime.now(), text: response);
       setState(() {
         messages = [newMessage, ...messages];
       });
     }
     chatHistory.add(Content(role: 'model',parts: [Part.text(response)]));

   }

}
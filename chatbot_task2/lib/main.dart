import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  // final String apiKey = dotenv.env['API_KEY']!;
  // Gemini.init(apiKey: apiKey);

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
  ChatUser currentUser = ChatUser(id: "1", firstName: "You" );
  ChatUser bot = ChatUser(id: "2", firstName: "Gemini", profileImage: "assets/images/gemini.png" );
  List<ChatMessage> messages= [];
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("ChatBot", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
      ),
      body: appUI(),
    );
  }
  Widget appUI(){
    return DashChat(
        currentUser: currentUser,
        onSend: sendMessage,
        messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.blue[300],
        currentUserTextColor: Colors.black,
        containerColor: Colors.white24,
        textColor: Colors.black,
      ),
    );
  }

  void sendMessage(ChatMessage chatMessage){
    setState(() {
      messages=[chatMessage, ...messages];
    });


  }
}
import 'package:flutter/material.dart';
import 'package:notes_app/view/loginScreen.dart';

import '../res/buttons.dart';
import '../utils/routes/routesName.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFB6B9F4),
      body:
         Stack(
           children: [
                Opacity(
                  opacity: 0.15,
                    child: Image.asset('assets/images/splash.jpg',width: double.infinity,height: double.infinity,),

                ),

             Center(child: Text("Notes App",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 70,color: Colors.black),)),

             Padding(
               padding: const EdgeInsets.only(bottom: 56,),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Button(text: "Sign Up",
                      onPressed:(){
                        Navigator.pushNamed(context, RoutesName.signup);
                      }),
                      SizedBox(width: 120,),
                      Button(text: "Login",
                          onPressed:(){
                        Navigator.pushNamed(context, RoutesName.login);
                      }),
                    ],
                  )
                ],
                       ),
             ),
           ],
         ),

    );
  }
}
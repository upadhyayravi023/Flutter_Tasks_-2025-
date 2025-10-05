import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/routes/routesName.dart';

import '../../view/homeScreen.dart';
import '../../view/loginScreen.dart';
import '../../view/notes.dart';
import '../../view/signupScreen.dart';
import '../../view/entryScreen.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.home:
        return MaterialPageRoute(builder:(BuildContext context)=> HomeScreen());

      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) =>  LoginScreen());
      case RoutesName.signup:
        return MaterialPageRoute(builder: (BuildContext context)=> SignupScreen());
        case RoutesName.notes:
        return MaterialPageRoute(builder: (BuildContext context)=> Notes());
        case RoutesName.entry:
        return MaterialPageRoute(builder: (BuildContext context)=> EntryScreen());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text("No Route found!!")
            )
          );
        });
    };
  }
}
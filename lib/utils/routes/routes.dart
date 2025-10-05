import 'package:flutter/material.dart';
import 'package:rudraksha_task_3/utils/routes/routes_name.dart';
import '../../view/home_view.dart';
import '../../view/login_view.dart';
import '../../view/signup_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const HomeView());
        case RoutesName.signup:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpView());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginView());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
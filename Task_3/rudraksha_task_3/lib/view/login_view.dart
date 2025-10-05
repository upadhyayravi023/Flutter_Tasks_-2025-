import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import 'home_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: InkWell(
            onTap: (){
              Utils.toastMessage('No Internet Connection');
            },
            child: Text('Login'),
          )
        )
    );
  }
}
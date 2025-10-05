import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preference/providers/auth_provider.dart' ;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 150,),
            Text("Hey, Welcome back!", style:
              TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),),
            Text("Good to see you again!", style:
            TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: TextEditingController(),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  filled: true,
                  hintText: "Email",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none
                  )
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: TextEditingController(),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    hintText: "Password",
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none
                    )
                ),

              ),
            ),

            SizedBox(height: 40,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
              authProvider.login();
              },

              child: const Text("Log In"),

            ),
          ],
        ),
      ),
    );
  }
}

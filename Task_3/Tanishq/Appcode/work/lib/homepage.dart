import 'package:flutter/material.dart';
import 'package:work/signuppage.dart';
import 'calculator.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login or Sign-up', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
          SizedBox(height: 150,),
          TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            filled: true,
            fillColor: Colors.grey.shade200, // background color
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 1.5),
            ),
          ),
        ),
          SizedBox(
            height: 8,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.password),
              filled: true,
              fillColor: Colors.grey.shade200, // background color
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Signuppage()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF069A06),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3, // gives a slight shadow
            ),
            child: Text(
              'Sign-up',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Calculator()));
          }, child: Text('Test')),
        ],
      ),
    );
  }
}

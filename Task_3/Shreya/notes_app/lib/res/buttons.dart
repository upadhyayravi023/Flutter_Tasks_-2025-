import 'package:flutter/material.dart';

import 'colors.dart';

class Button extends StatelessWidget{
  final String text;
  final bool loading;
  final VoidCallback onPressed;
  const Button({Key? key,
    required this.text,
    this.loading = false,
    required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: ElevatedButton(
            onPressed:onPressed,
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll( AppColors.mainColor),
                padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))
            ), child: loading? const CircularProgressIndicator(color: Colors.black,):Text(text,style: TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.w800,)),
      ),
    );
  }
}
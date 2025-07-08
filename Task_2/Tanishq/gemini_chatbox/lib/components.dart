import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});
  @override
  Widget build(context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color.fromARGB(255, 174, 199, 230)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

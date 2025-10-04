import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class DiceRollerPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const DiceRollerPage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage> {
  var activeDiceImage = 'assets/dice-2.png';

  void rollDice() {
    var diceRoll = Random().nextInt(6) + 1;
    setState(() {
      activeDiceImage = 'assets/dice-$diceRoll.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // current theme
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(activeDiceImage, width: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  widget.isDarkMode ? Colors.orange : Colors.red,
                ),
                onPressed: rollDice,
                child: const Text('Roll Dice', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

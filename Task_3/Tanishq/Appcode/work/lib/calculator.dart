import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: CalculatorScreen()),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isDarkMode = false;
  String input = '';
  String output = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '';
      } else if (value == '=') {
        output = _evaluateExpression(input);
      } else {
        input += value;
      }
    });
  }

  String _evaluateExpression(String expr) {
    try {
      List<String> tokens = [];
      String number = '';
      for (int i = 0; i < expr.length; i++) {
        String ch = expr[i];
        if ('0123456789.'.contains(ch)) {
          number += ch;
        } else {
          if (number.isNotEmpty) {
            tokens.add(number);
            number = '';
          }
          tokens.add(ch);
        }
      }
      if (number.isNotEmpty) tokens.add(number);

      List<String> stack = [];
      for (int i = 0; i < tokens.length; i++) {
        String token = tokens[i];
        if (token == '*' || token == '/') {
          double a = double.parse(stack.removeLast());
          double b = double.parse(tokens[++i]);
          stack.add(token == '*' ? (a * b).toString() : (a / b).toString());
        } else {
          stack.add(token);
        }
      }

      double result = double.parse(stack[0]);
      for (int i = 1; i < stack.length; i += 2) {
        String op = stack[i];
        double num = double.parse(stack[i + 1]);
        if (op == '+') result += num;
        if (op == '-') result -= num;
      }

      if (result == result.roundToDouble()) return result.toInt().toString();
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String text, {Color? bgColor, Color? textColor}) {
    Color defaultBg = isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
    Color defaultText = isDarkMode ? Colors.white : Colors.black;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? defaultBg,
            foregroundColor: textColor ?? defaultText,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(22),
            elevation: 4,
          ),
          child: Text(text, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fully dark mode colors
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color inputColor = isDarkMode ? Colors.white70 : Colors.black54;
    Color outputColor = isDarkMode ? Colors.white : Colors.black;

    // Wrap with AnnotatedRegion to enforce dark system overlays
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.yellow[700] : Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        elevation: 4,
                      ),
                      child: Icon(
                        isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Profile()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        elevation: 4,
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(input, style: TextStyle(fontSize: 36, color: inputColor)),
                    const SizedBox(height: 15),
                    Text(output, style: TextStyle(fontSize: 28, color: outputColor)),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    children: [
                      buildButton('7'),
                      buildButton('8'),
                      buildButton('9'),
                      buildButton('/', bgColor: Colors.orange, textColor: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton('4'),
                      buildButton('5'),
                      buildButton('6'),
                      buildButton('*', bgColor: Colors.orange, textColor: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton('1'),
                      buildButton('2'),
                      buildButton('3'),
                      buildButton('-', bgColor: Colors.orange, textColor: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton('C', bgColor: Colors.redAccent, textColor: Colors.white),
                      buildButton('0'),
                      buildButton('=', bgColor: Colors.green, textColor: Colors.white),
                      buildButton('+', bgColor: Colors.orange, textColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

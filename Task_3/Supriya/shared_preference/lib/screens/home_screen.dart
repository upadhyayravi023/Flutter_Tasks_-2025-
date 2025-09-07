import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preference/providers/theme_provider.dart';
import 'package:shared_preference/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: () {
            context.read<AuthProvider>().logout();
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome!", style: TextStyle(fontSize: 24),),
            const SizedBox(height: 20,),
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
            return SwitchListTile(value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            }
            );
            },
            )
          ],
        ),
      ),
    );
  }
}

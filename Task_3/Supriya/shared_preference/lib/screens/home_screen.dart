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
      body: Column(

        children: [
          SizedBox(height: 150,),
          Text("This is the HomePage...",
            style: TextStyle(
                fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("There is a toggle button in the bottom. Alternate between dark and light mode.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 350,),
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
    );
  }
}

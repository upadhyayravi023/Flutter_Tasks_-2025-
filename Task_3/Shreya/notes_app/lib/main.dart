import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/view/entryScreen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/res/colors.dart';
import 'package:notes_app/utils/routes/routes.dart';
import 'package:notes_app/utils/routes/routesName.dart';
import 'package:notes_app/view/homeScreen.dart';
import 'package:notes_app/view/loginScreen.dart';
import 'package:notes_app/view/notes.dart';
import 'package:notes_app/utils/theme.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(create: (_) => ThemeChanger(),
      child: Builder(builder: (BuildContext context){
        final themeChanger = Provider.of<ThemeChanger>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
         themeMode: themeChanger.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(backgroundColor: Colors.white,foregroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.white,
            cardColor: AppColors.grey,
            hintColor:Colors.black,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(backgroundColor: AppColors.darkColor,foregroundColor: Colors.white),
            scaffoldBackgroundColor: AppColors.darkColor,
            cardColor: AppColors.darktext,
            hintColor:Colors.white,
          ),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder:(context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if(snapshot.hasData){
                  return EntryScreen();
                }
                else{
                return HomeScreen();
                }
              }
          ),
          onGenerateRoute: Routes.generateRoute,

        );

      })
    );

  }
}




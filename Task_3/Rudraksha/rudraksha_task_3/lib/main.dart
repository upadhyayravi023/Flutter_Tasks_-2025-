import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rudraksha_task_3/repository/auth_repository.dart';
import 'package:rudraksha_task_3/utils/routes/routes.dart';
import 'package:rudraksha_task_3/utils/routes/routes_name.dart';
import 'package:rudraksha_task_3/view/app_themes_view.dart';
import 'package:rudraksha_task_3/view_model/auth_view_model.dart';
import 'package:rudraksha_task_3/view_model/reminder_view_model.dart';
import 'package:rudraksha_task_3/view_model/theme_view_model.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository: AuthRepository())),
        ChangeNotifierProvider(create: (_) => ReminderViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],

      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Reminder App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeViewModel.themeMode,
            initialRoute: RoutesName.login,
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

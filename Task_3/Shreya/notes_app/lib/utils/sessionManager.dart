import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  static const String _isLoggedInKey ='isLoggedIn';

  static Future<void> setLoggedIn (bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  }

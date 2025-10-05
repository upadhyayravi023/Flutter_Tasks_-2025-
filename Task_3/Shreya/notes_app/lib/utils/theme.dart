import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeChanger with ChangeNotifier{
  static const String _themeModeKey='themeMode';
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeChanger(){
    _loadTheme();
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode==ThemeMode.dark? 'dark':'light');
  }
  Future<void> _loadTheme() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedTheme = prefs.getString(_themeModeKey);
    if(savedTheme == 'dark'){
      _themeMode=ThemeMode.dark;
    }else{
      _themeMode=ThemeMode.light;
    }
    notifyListeners();
  }

}
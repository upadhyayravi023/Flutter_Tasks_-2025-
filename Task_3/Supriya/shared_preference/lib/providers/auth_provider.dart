import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const IS_LOGGED_IN = "IS_LOGGED_IN";
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    await prefs.setBool(IS_LOGGED_IN, true);
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    await prefs.setBool(IS_LOGGED_IN, false);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(IS_LOGGED_IN) ?? false;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import '../repository/theme_repository.dart';

class ThemeViewModel extends ChangeNotifier {
  final ThemeRepository _repository = ThemeRepository();
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeViewModel() {
    _themeMode = ThemeMode.system;
    loadTheme();
  }

  void loadTheme() async {
    _themeMode = await _repository.loadThemeMode();
    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;
    _repository.saveThemeMode(themeMode);
    notifyListeners();
  }
}
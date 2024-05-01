import 'package:flutter/material.dart';
import 'package:quickchat/themes/darkmode.dart';
import 'package:quickchat/themes/lightmode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = isDarkMode? lightMode : darkMode;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/themes/dark_mode.dart';
import 'package:twitter/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier{
  //initially set it as dark mode
  ThemeData _themeData = darkMode;

  //get the current theme
  ThemeData get themeData => _themeData;

  //is it dark mode currently
  bool get isDarkMode => _themeData == darkMode;

  // toggle theme method
  void toggleTheme() {
    if (_themeData == darkMode) {
      _themeData = lightMode;
    } else {
      _themeData = darkMode;
    }
    notifyListeners();
  }
}
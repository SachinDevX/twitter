import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/themes/dark_mode.dart';
import 'package:twitter/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier{
  //initially set it as light mode
  ThemeData _themeData = lightMode;

  //get the current theme
  ThemeData get themeData => _themeData;

  //is it dark mode currently
  bool get isDarkMode => _themeData == darkMode;

  // toggle theme method
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
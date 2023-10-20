import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/themes/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = AppThemes.light();

  ThemeData get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDark') ?? false;

    _currentTheme = isDark ? AppThemes.dark() : AppThemes.light();
    notifyListeners();
  }

  void toggleTheme() async {
    _currentTheme = _currentTheme == AppThemes.light()
        ? AppThemes.dark()
        : AppThemes.light();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _currentTheme == AppThemes.dark());

    notifyListeners();
  }
}

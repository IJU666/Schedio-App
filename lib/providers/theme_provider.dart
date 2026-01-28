import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeBoxName = 'themeBox';
  static const String _themeModeKey = 'themeMode';
  
  ThemeMode _themeMode = ThemeMode.dark;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeController() {
    _loadThemeMode();
  }


  Future<void> _loadThemeMode() async {
    final box = await Hive.openBox(_themeBoxName);
    final savedMode = box.get(_themeModeKey, defaultValue: 'dark');
    _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }


  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_themeModeKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_themeModeKey, mode == ThemeMode.dark ? 'dark' : 'light');
    
    notifyListeners();
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1E2936),
      scaffoldBackgroundColor: const Color(0xFF1E2936),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7AB8FF),
        secondary: Color(0xFFFFB84D),
        surface: Color(0xFF2A3947),
        error: Color(0xFFFF6B6B),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E2936),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardColor: const Color(0xFF2A3947),
      dividerColor: Colors.grey,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7AB8FF),
        secondary: Color(0xFFFFB84D),
        surface: Colors.white,
        error: Color(0xFFFF6B6B),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1E2936),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E2936)),
        titleTextStyle: TextStyle(
          color: Color(0xFF1E2936),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardColor: Colors.white,
      dividerColor: Colors.grey[300],
    );
  }
}
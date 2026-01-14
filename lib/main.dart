import 'package:flutter/material.dart';
import 'splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'SF Pro',
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        fontFamily: 'SF Pro',
      ),

      home: const SplashScreen(),
    );
  }
}


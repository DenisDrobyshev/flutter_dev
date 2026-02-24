import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const GeodesyCalcApp());
}

class GeodesyCalcApp extends StatefulWidget {
  const GeodesyCalcApp({super.key});

  static _GeodesyCalcAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_GeodesyCalcAppState>();
  }

  @override
  State<GeodesyCalcApp> createState() => _GeodesyCalcAppState();
}

class _GeodesyCalcAppState extends State<GeodesyCalcApp> {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geodesy Calculator',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 0, 40, 150),
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 107, 153, 221),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}

// Tema Provider - Karanlık/Açık Tema Yönetimi
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Karanlık Tema
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF6B00),
    scaffoldBackgroundColor: const Color(0xFF0A0A15),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1A1A2E),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFFF6B00),
      secondary: const Color(0xFF00BFFF),
      surface: const Color(0xFF1A1A2E),
      background: const Color(0xFF0A0A15),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Açık Tema
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF6B00),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A1A2E),
      elevation: 1,
    ),
    cardColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFFF6B00),
      secondary: const Color(0xFF0066CC),
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1A1A2E)),
      bodyMedium: TextStyle(color: Color(0xFF666666)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
    ),
  );
}

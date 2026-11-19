import 'package:flutter/material.dart';

abstract class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF00796B);
  static const Color _primaryLight = Color(0xFF40B8A5);

  static ThemeData get lightTheme {
    final cs = const ColorScheme.light(
      brightness: Brightness.light, primary: _primary, onPrimary: Colors.white,
      secondary: _primaryLight, surface: Color(0xFFFFFEF8),
      background: Color(0xFFF5F2EB), error: Color(0xFFBA1A1A),
    );
    return ThemeData(useMaterial3: true, brightness: Brightness.light, colorScheme: cs, fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFF5F2EB),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0, backgroundColor: Color(0xFFFFFEF8), foregroundColor: Colors.black87),
      cardTheme: CardThemeData(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFFFFFEF8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD7CFC3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD7CFC3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: _primary, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: _primary))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: const Color(0xFFFFFEF8), labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected),
    );
  }

  static ThemeData get darkTheme {
    final cs = const ColorScheme.dark(
      brightness: Brightness.dark, primary: _primaryLight, onPrimary: Colors.black,
      secondary: _primary, surface: Color(0xFF1C1B1F), background: Color(0xFF141218), error: Color(0xFFFFB4AB),
    );
    return ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: cs, fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF141218),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0, backgroundColor: Color(0xFF1C1B1F), foregroundColor: Colors.white),
      cardTheme: CardThemeData(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), color: const Color(0xFF2D2B30)),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFF2D2B30),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF49454F))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF49454F))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryLight, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: _primaryLight, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: const Color(0xFF1C1B1F), labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected),
    );
  }
}
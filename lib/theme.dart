import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF191919),
      onPrimary: Color(0xFFefefef),
      secondary: Color(0xFFaaaaaa),
      onSecondary: Color(0xFF191919),
      tertiary: Color(0xFF81C944),
      onTertiary: Color(0xFFefefef),
      error: Color(0xFFA65C5C),
      onError: Color(0xFFefefef),
      background: Color(0xFF191919),
      onBackground: Color(0xFFefefef),
      surface: Color(0xFFefefef),
      onSurface: Color(0xFF191919),
    ),
    textTheme: textTheme,
  );

  static TextTheme textTheme = TextTheme(
    headlineLarge: GoogleFonts.gothicA1(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.courierPrime(
      fontSize: 24,
      letterSpacing: -1.5,
    ),
    titleMedium: GoogleFonts.courierPrime(
      fontSize: 18,
      letterSpacing: -1.5,
    ),
    titleSmall: GoogleFonts.courierPrime(
      fontSize: 14,
      letterSpacing: -1.5,
    ),
    bodyLarge: GoogleFonts.gothicA1(
      fontSize: 24,
    ),
    bodyMedium: GoogleFonts.gothicA1(
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.gothicA1(
      fontSize: 14,
    ),
  );
}

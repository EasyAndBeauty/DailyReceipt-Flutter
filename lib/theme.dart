import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.black,
      onPrimary: AppColors.white,
      secondary: AppColors.grey,
      onSecondary: AppColors.black,
      tertiary: AppColors.green,
      onTertiary: AppColors.white,
      error: AppColors.red,
      onError: AppColors.white,
      surface: AppColors.black,
      onSurface: AppColors.white,
    ),
    dialogBackgroundColor: AppColors.blackSemiTransparent,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.black
  );

  static TextTheme textTheme = TextTheme(
    headlineLarge: GoogleFonts.courierPrime(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -1,
    ),
    titleLarge: GoogleFonts.courierPrime(
      fontSize: 24,
      letterSpacing: -1.5,
    ),
    titleMedium: GoogleFonts.courierPrime(
      fontSize: 18,
      letterSpacing: -1,
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

class AppColors {
  static const black = Color(0xFF191919);
  static const white = Color(0xFFefefef);
  static const grey = Color(0xFFaaaaaa);
  static const green = Color(0xFF81C944);
  static const red = Color(0xFFA65C5C);
  static const blackSemiTransparent = Color(0x99000000);
}

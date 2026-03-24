import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark theme
  static const darkBg = Color(0xFF0D1B2A);
  static const darkSurface = Color(0xFF1A2740);
  static const darkCard = Color(0xFF1E2D42);
  static const darkCardAlt = Color(0xFF162033);

  // Light theme (golden yellow)
  static const lightBg = Color(0xFFFFC107);
  static const lightBgDeep = Color(0xFFFFB300);
  static const lightSurface = Color(0xFFFFD54F);
  static const lightCard = Color(0xFFFFE082);
  static const lightCardAlt = Color(0xFFFFF8E1);

  // Accent colors
  static const purple = Color(0xFF7C4DFF);
  static const purpleLight = Color(0xFF9C6EFF);
  static const amber = Color(0xFFFFC107);
  static const amberDark = Color(0xFFFFB300);
  static const white = Colors.white;
  static const black = Colors.black;

  // Supermarket brand colors
  static const colesRed = Color(0xFFE31837);
  static const woolworthsGreen = Color(0xFF009B4D);
  static const aldiBlue = Color(0xFF0047AB);
  static const aldiOrange = Color(0xFFFF6B00);
  static const igaRed = Color(0xFFE31837);
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.purple,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        surface: AppColors.darkSurface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: Colors.white54,
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.black,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        surface: AppColors.lightSurface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}

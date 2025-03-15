// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.cairo().fontFamily,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2E7D32),
        secondary: Color(0xFF66BB6A),
        tertiary: Color(0xFF43A047),
        surface: Colors.white,
        background: Color(0xFFF8F9FA),
        error: Color(0xFFD32F2F),
        onPrimary: Colors.white,
        onSecondary: Colors.black87,
        onSurface: Color(0xFF1C1B1F),
        onBackground: Color(0xFF1C1B1F),
        primaryContainer: Color(0xFFB9F6CA),
        onPrimaryContainer: Color(0xFF002107),
        secondaryContainer: Color(0xFFDCEDC8),
        onSecondaryContainer: Color(0xFF1B1B1B),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
      ),
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        titleLarge: GoogleFonts.cairo(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.cairo(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.9), // تغيير لون الخلفية إلى أسود
        contentTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600, // خط أكثر سمكاً
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6, // زيادة الظل
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.cairo().fontFamily,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF81C784),
        secondary: const Color(0xFF66BB6A),
        tertiary: const Color(0xFF4CAF50),
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: const Color(0xFFCF6679),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        primaryContainer: const Color(0xFF1E4620),
        onPrimaryContainer: const Color(0xFFB9F6CA),
        secondaryContainer: Colors.grey[800]!,
        onSecondaryContainer: Colors.white,
        errorContainer: const Color(0xFF590007),
        onErrorContainer: const Color(0xFFFFB4AB),
      ),
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        titleLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.cairo(color: Colors.white),
        bodyMedium: GoogleFonts.cairo(color: Colors.white70),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 8,
        backgroundColor: const Color(0xFF1E1E1E),
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E4620),
        contentTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

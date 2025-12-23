import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F46E5), // Indigo
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,

    scaffoldBackgroundColor: const Color(0xFFF5F5F7), // ✅ Off-white background

    textTheme: GoogleFonts.poppinsTextTheme(),

    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

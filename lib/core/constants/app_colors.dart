import 'package:flutter/material.dart';

class AppColors {
  // Main Colors (Pastel tones inspired by MiraiMind)
  static const Color primary = Color(0xFF6C63FF);      // Lavender purple
  static const Color primaryLight = Color(0xFFB5B0FF);
  static const Color secondary = Color(0xFFFFB8D9);    // Soft pink
  static const Color background = Color(0xFFF8F9FA);   // Soft off-white
  static const Color surface = Color(0xFFFFFFFF);      // Pure white
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textLight = Color(0xFF9E9E9E);

  // Accent Colors (Anime style)
  static const Color accentPink = Color(0xFFFF85A1);
  static const Color accentBlue = Color(0xFF80D0FF);
  static const Color accentYellow = Color(0xFFFFD966);
  static const Color accentGreen = Color(0xFFB5EAD7);

  // Gradient Collections
  static const List<Color> mainGradient = [
    Color(0xFF6C63FF),
    Color(0xFF9D86FF),
  ];

  static const List<Color> pinkGradient = [
    Color(0xFFFFB8D9),
    Color(0xFFFF85A1),
  ];

  static const List<Color> blueGradient = [
    Color(0xFF80D0FF),
    Color(0xFF6C63FF),
  ];

  // Functional Colors
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFD93D);

  // Chat bubble colors
  static const Color myMessage = Color(0xFF6C63FF);
  static const Color theirMessage = Color(0xFFF0F0F0);
}
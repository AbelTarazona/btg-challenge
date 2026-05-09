import 'package:flutter/material.dart';

class AppColors {
  final Color deepNavy;
  final Color darkBlue;
  final Color midBlue;
  final Color accentGold;
  final Color accentGoldLight;
  final Color accentTeal;
  final Color cardDark;
  final Color cardDarkAlt;
  final Color surface;
  final Color surfaceLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color riskLow;
  final Color riskMedium;
  final Color riskHigh;
  final LinearGradient balanceGradient;
  final LinearGradient goldGradient;
  final LinearGradient backgroundGradient;

  const AppColors({
    required this.deepNavy,
    required this.darkBlue,
    required this.midBlue,
    required this.accentGold,
    required this.accentGoldLight,
    required this.accentTeal,
    required this.cardDark,
    required this.cardDarkAlt,
    required this.surface,
    required this.surfaceLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.riskLow,
    required this.riskMedium,
    required this.riskHigh,
    required this.balanceGradient,
    required this.goldGradient,
    required this.backgroundGradient,
  });

  // ── Dark Theme ──
  static const dark = AppColors(
    deepNavy: Color(0xFF0D1B2A),
    darkBlue: Color(0xFF1B2838),
    midBlue: Color(0xFF1E3A5F),
    accentGold: Color(0xFFD4A853),
    accentGoldLight: Color(0xFFE8C97A),
    accentTeal: Color(0xFF2EC4B6),
    cardDark: Color(0xFF162233),
    cardDarkAlt: Color(0xFF1A2D42),
    surface: Color(0xFF0F1923),
    surfaceLight: Color(0xFF243447),
    textPrimary: Color(0xFFF0F4F8),
    textSecondary: Color(0xFF8899AA),
    textMuted: Color(0xFF5A6B7D),
    riskLow: Color(0xFF2EC4B6),
    riskMedium: Color(0xFFF4A261),
    riskHigh: Color(0xFFE76F51),
    balanceGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A5F), Color(0xFF0D1B2A)],
    ),
    goldGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0D1B2A), Color(0xFF0F1923)],
    ),
  );

  // ── Light Theme ──
  static const light = AppColors(
    deepNavy: Color(0xFFF8FAFC),
    darkBlue: Color(0xFFF1F5F9),
    midBlue: Color(0xFF1E3A5F),
    accentGold: Color(0xFFB8860B),
    accentGoldLight: Color(0xFFD4A853),
    accentTeal: Color(0xFF0D9488),
    cardDark: Color(0xFFFFFFFF),
    cardDarkAlt: Color(0xFFF8FAFC),
    surface: Color(0xFFF1F5F9),
    surfaceLight: Color(0xFFCBD5E1),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    riskLow: Color(0xFF059669),
    riskMedium: Color(0xFFD97706),
    riskHigh: Color(0xFFDC2626),
    balanceGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A5F), Color(0xFF2D4A6F)],
    ),
    goldGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
    ),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    ),
  );

  /// Obtiene los colores según el brillo del tema actual.
  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

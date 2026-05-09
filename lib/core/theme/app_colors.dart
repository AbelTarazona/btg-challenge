import 'package:flutter/material.dart';

/// Paleta de colores BTG Pactual con tonos premium.
class AppColors {
  AppColors._();

  // ── Primarios ──
  static const Color deepNavy = Color(0xFF0D1B2A);
  static const Color darkBlue = Color(0xFF1B2838);
  static const Color midBlue = Color(0xFF1E3A5F);

  // ── Acentos ──
  static const Color accentGold = Color(0xFFD4A853);
  static const Color accentGoldLight = Color(0xFFE8C97A);
  static const Color accentTeal = Color(0xFF2EC4B6);

  // ── Superficies ──
  static const Color cardDark = Color(0xFF162233);
  static const Color cardDarkAlt = Color(0xFF1A2D42);
  static const Color surface = Color(0xFF0F1923);
  static const Color surfaceLight = Color(0xFF243447);

  // ── Texto ──
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8899AA);
  static const Color textMuted = Color(0xFF5A6B7D);

  // ── Riesgo ──
  static const Color riskLow = Color(0xFF2EC4B6);
  static const Color riskMedium = Color(0xFFF4A261);
  static const Color riskHigh = Color(0xFFE76F51);

  // ── Gradientes ──
  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF0D1B2A)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1B2A), Color(0xFF0F1923)],
  );
}

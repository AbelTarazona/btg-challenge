import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle heading3;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle balance;
  final TextStyle balanceCurrency;

  const AppTextStyles._({
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.subtitle,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.balance,
    required this.balanceCurrency,
  });

  static AppTextStyles _fromColors(AppColors colors) {
    return AppTextStyles._(
      heading1: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.5,
      ),
      heading2: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: -0.3,
      ),
      heading3: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      subtitle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
      ),
      body: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
      ),
      label: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.textMuted,
        letterSpacing: 0.8,
      ),
      balance: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -1.0,
      ),
      balanceCurrency: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.accentGold,
      ),
    );
  }

  static final _light = _fromColors(AppColors.light);
  static final _dark = _fromColors(AppColors.dark);

  static AppTextStyles of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }
}

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

extension AppThemeX on BuildContext {
  AppColors get colors => AppColors.of(this);
  AppTextStyles get textStyles => AppTextStyles.of(this);
}

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.deepNavy,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.midBlue,
      surface: AppColors.light.surface,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.deepNavy,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.midBlue,
      surface: AppColors.dark.surface,
    ),
  );
}

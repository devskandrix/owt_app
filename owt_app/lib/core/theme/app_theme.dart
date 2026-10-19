import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.dark.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPink,
        brightness: Brightness.dark,
        surface: AppColors.dark.background,
      ),
      extensions: const [AppColors.dark],
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.light.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPink,
        brightness: Brightness.light,
        surface: AppColors.light.background,
      ),
      extensions: const [AppColors.light],
    );
  }
}

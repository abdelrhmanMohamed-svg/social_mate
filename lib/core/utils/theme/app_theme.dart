import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    
  );
}

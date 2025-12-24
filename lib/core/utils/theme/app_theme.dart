import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,

      labelColor: AppColors.black,
      labelPadding: EdgeInsets.only(right: 30.0),

      unselectedLabelColor: AppColors.blackwith60Opacity,
      indicatorColor: AppColors.primary,

      dividerColor: AppColors.blackwith60Opacity,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.gray200),
      ),
    ),
  );
}

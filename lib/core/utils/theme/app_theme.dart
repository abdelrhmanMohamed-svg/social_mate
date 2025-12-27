import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    fontFamily: AppFonts.manrope,
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
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
      hintStyle: TextStyle(color: AppColors.gray200),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
     fontFamily: AppFonts.manrope,
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryButton,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryButton,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackgroundColor,
      elevation: 0,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: AppColors.primaryText,
      displayColor: AppColors.secondaryText,
    ),
    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,

      labelColor: AppColors.primaryText,
      labelPadding: EdgeInsets.only(right: 30.0),

      unselectedLabelColor: AppColors.secondaryText,
      indicatorColor: AppColors.primaryButton,

      dividerColor: AppColors.dividerColor,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      hintStyle: TextStyle(color: AppColors.inputHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.primaryButtonText,
        textStyle: TextStyle(color: AppColors.primaryButtonText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_fonts.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      iconSize: 30.r,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: AppTextStyles.headingH5.copyWith(
        color: AppColors.black45,
      ),
      iconTheme: IconThemeData(color: AppColors.black45),
      actionsIconTheme: IconThemeData(color: AppColors.black45),

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
      hintStyle: TextStyle(color: AppColors.black45),
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.socialButtonBackground,
      foregroundColor: AppColors.white,
      iconSize: 30.r,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,

      titleTextStyle: AppTextStyles.headingH5.copyWith(color: AppColors.white),
      iconTheme: IconThemeData(color: AppColors.white),
      actionsIconTheme: IconThemeData(color: AppColors.white),
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

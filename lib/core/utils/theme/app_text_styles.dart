import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();
  // heading
  static TextStyle headingH6 = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle headingH5 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    height: 1.4,
  );

  static TextStyle headingH4 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    height: 1.5,
  );

  static TextStyle headingH3 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 32.sp,
    height: 1.4,
  );

  static TextStyle headingH2 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 40.sp,
    height: 1.2,
  );

  static TextStyle headingH1 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 48.sp,
    height: 1.2,
  );

  // body xs
  static TextStyle xsRegular = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 12.sp,
    height: 1.55,
    letterSpacing: -0.24,
  );
  static TextStyle xsMedium = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.24,
  );

  static TextStyle xsSemiBold = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.24,
  );

  // body small
  static TextStyle sRegular = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 13.sp,
    height: 1.55,
    letterSpacing: -0.28,
  );
  static TextStyle sMedium = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.28,
  );

  static TextStyle sSemiBold = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.28,
  );

  // body medium
  static TextStyle mRegular = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 16.sp,
    height: 1.6,
    letterSpacing: -0.32,
  );
  static TextStyle mMedium = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: -0.32,
  );

  static TextStyle mSemiBold = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: -0.32,
  );

  // body medium
  static TextStyle lRegular = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 18.sp,
    height: 1.55,
  );
  static TextStyle lMedium = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.55,
  );

  static TextStyle lSemiBold = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.55,
  );
}

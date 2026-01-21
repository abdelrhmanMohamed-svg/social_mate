import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xff007AFF);
  static const Color lightBackground = Color(0xffffffff);
  static const Color darkBackgroundColor = Color(0xFF0B1020);
  static const Color inactiveColor = Color(0xff45556C);
  static Color gray = Color(0xff000000).withValues(alpha: 0.4);
  static Color gray100 = Colors.grey.shade100;

  static Color red = Color(0xffFF0000);
  static Color black45 = Colors.black45;
  static Color black54 = Colors.black54;
  static Color black87 = Colors.black87;
  static const Color black12 = Colors.black12;
  static const Color black26 = Colors.black26;

  static const Color logoShadow = Color(0xffD8F1FE);
  static const Color black = Color(0xff000000);
  static Color blackwith60Opacity = Color(0xff000000).withValues(alpha: 0.6);
  static Color gray200 = Colors.grey.shade300;
  static const Color white = Color(0xffffffff);
  static Color whiteA9 = Colors.white.withValues(alpha: 0.92);

  static const Color primaryText = Color(
    0xFFFFFFFF,
  ); // Main text (Sign in, labels)
  static const Color secondaryText = Color(
    0xFF9AA3B2,
  ); // Hint text, inactive tab
  static const Color dividerColor = Color(0xFF2A2F45);

  static const Color inputBackground = Color(0xFF161C32);
  static const Color inputBorder = Color(0xFF2C3350);
  static const Color inputHint = Color(0xFF7F8AA3);

  // gradiants colors
  static const Color gradiantColorDark1 = Color(0xFF0B1020);
  static const Color gradiantColorDark2 = Color(0xFF141A2E);
  static const Color gradiantColorLight1 = Color(0xffD8F1FE);
  static const Color gradiantColorLight2 = Color(0xFFFFFFFF);

  static const Color primaryButton = Color(0xFF2F6BFF);
  static const Color primaryButtonText = Color(0xFFFFFFFF);
  static const Color linkColor = Color(0xFF6FA1FF);
  static const Color socialButtonBackground = Color(0xFF1B2138);
  static const Color socialButtonBorder = Color(0xFF2E3555);
}

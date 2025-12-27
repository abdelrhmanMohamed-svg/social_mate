import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class AppGradiant {
  AppGradiant._();

  static const LinearGradient backgroundGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradiantColorDark1, AppColors.gradiantColorDark2],
  );
  static const LinearGradient backgroundGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.gradiantColorLight1,
      AppColors.gradiantColorLight2,
      AppColors.gradiantColorLight1,
    ],
  );
}

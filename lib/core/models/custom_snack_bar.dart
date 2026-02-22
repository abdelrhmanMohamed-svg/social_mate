import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/app_keys.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static void show(String message, [bool isError=false]) {
    AppKeys.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.red : AppColors.greenStory,
        duration: isError
            ? const Duration(days: 265)
            : const Duration(seconds: 2),
      ),
    );
  }
  static void hide() {
    AppKeys.scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }
}

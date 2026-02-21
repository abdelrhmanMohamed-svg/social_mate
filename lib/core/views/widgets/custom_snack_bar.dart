import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  SnackBarAction? action,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      backgroundColor: isError ? AppColors.red : AppColors.primary,
      duration: const Duration(seconds: 2),
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
    ),
  );
}

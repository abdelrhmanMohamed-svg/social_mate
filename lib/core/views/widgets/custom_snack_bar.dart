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
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: isError ? AppColors.red : AppColors.primary,
      duration: Duration(seconds: 2),
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
    ),
  );
}

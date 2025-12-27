import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class CircleShadow extends StatelessWidget {
  const CircleShadow({super.key, required this.offset});
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.logoShadow,
            spreadRadius: 100,
            blurRadius: 100,
            offset: offset
          ),
        ],
      ),
    );
  }
}

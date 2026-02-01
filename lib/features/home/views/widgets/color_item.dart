import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class ColorItem extends StatelessWidget with SU {
  const ColorItem({super.key, required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 25.h,
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

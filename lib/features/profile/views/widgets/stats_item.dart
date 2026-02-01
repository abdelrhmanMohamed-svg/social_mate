import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class StatsItem extends StatelessWidget with SU {
  const StatsItem({super.key, required this.value, required this.title, this.onTap});
  final int value;
  final String title;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(value.toString(), style: AppTextStyles.headingH4),
          2.verticalSpace,
      
          Text(title, style: AppTextStyles.sMedium),
        ],
      ),
    );
  }
}

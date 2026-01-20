import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class StatsItem extends StatelessWidget with SU {
  const StatsItem({super.key, required this.value, required this.title});
  final int value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value.toString(), style: AppTextStyles.headingH4),
        2.verticalSpace,

        Text(title, style: AppTextStyles.sMedium),
      ],
    );
  }
}

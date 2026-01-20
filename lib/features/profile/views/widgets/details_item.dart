import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class DetailsItem extends StatelessWidget with SU {
  const DetailsItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });
  final String title;
  final IconData icon;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      child: SizedBox(
        width: double.infinity,
        height: 150.h,
        child: Card(
          color: AppColors.white,
          elevation: 1.5,
          child: Padding(
            padding: EdgeInsets.all(20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 30.h),
                    5.horizontalSpace,
                    Text(title, style: AppTextStyles.lSemiBold),
                  ],
                ),
                15.verticalSpace,
                Text(
                  value ?? "There is not set yet..",
                  style: AppTextStyles.mMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

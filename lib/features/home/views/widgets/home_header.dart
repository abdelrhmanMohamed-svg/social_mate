import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';

class HomeHeader extends StatelessWidget with SU {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppConstants.logoPath, width: 200.w, height: 80.h),
        Row(
          children: [
            Icon(Icons.search, size: 28.sp),
            15.horizontalSpace,
            Icon(Icons.notifications_none_outlined, size: 28.sp),
            15.horizontalSpace,
            Icon(Icons.message_outlined, size: 28.sp),
          ],
        ),
      ],
    );
  }
}

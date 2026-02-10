import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/features/home/views/widgets/notification_section.dart';

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
            Icon(Icons.search, size: 28.h),
            15.horizontalSpace,
            NotificationSection(),
            15.horizontalSpace,
            InkWell(
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.inboxPageRoute),
              child: Icon(Icons.inbox_outlined, size: 28.h),
            ),
          ],
        ),
      ],
    );
  }
}

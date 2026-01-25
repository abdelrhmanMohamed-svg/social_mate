import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/views/widgets/stats_item.dart';

class ProfileStats extends StatelessWidget with SU {
  const ProfileStats({super.key, required this.userData});
  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade300, width: 2.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsItem(title: 'Posts', value: userData.postsCount),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: AppColors.black26, width: 3.w),
              ),

              StatsItem(
                title: 'Followers',
                value: userData.followers != null
                    ? userData.followers!.length
                    : 0,
              ),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: AppColors.black26, width: 3.w),
              ),
              StatsItem(
                title: 'Following',
                value: userData.following != null
                    ? userData.following!.length
                    : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

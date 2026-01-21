import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

class CustomDrawerHeader extends StatelessWidget with SU {
  const CustomDrawerHeader({super.key, required this.userData});
  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 110.h,
          width: 110.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 4.w),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  userData.profileImageUrl != null
                      ? userData.profileImageUrl!
                      : AppConstants.userIMagePLaceholder,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        10.verticalSpace,
        Text(userData.name ?? "Unknown", style: AppTextStyles.headingH6),
        10.verticalSpace,
        Text(userData.bio ?? "There is no Bio yet.."),
      ],
    );
  }
}

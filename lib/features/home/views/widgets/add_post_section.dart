import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_gradiant.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class AddPostSection extends StatelessWidget {
  const AddPostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppGradiant.paddPostBoxGradient,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20.r),
              SizedBox(width: 10.w),
              Text(
                "What's on your mind?",
                style: AppTextStyles.headingH6.copyWith(color: AppColors.gray),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.image, color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text("Image", style: AppTextStyles.mSemiBold),
                ],
              ),
              SizedBox(
                height: 15.h,
                child: VerticalDivider(color: AppColors.black),
              ),
              Row(
                children: [
                  Icon(Icons.video_file, color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text("Videos", style: AppTextStyles.mSemiBold),
                ],
              ),
              SizedBox(
                height: 15.h,
                child: VerticalDivider(color: AppColors.black),
              ),
              Row(
                children: [
                  Icon(Icons.file_open, color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text("Image", style: AppTextStyles.mSemiBold),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

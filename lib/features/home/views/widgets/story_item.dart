import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/models/story_model.dart';

class StoryItem extends StatelessWidget with SU {
  const StoryItem({super.key, this.story});
  final StoryModel? story;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2.0.w),
          ),
          child: CircleAvatar(
            radius: 40.r,
            backgroundImage: story == null
                ? null
                : NetworkImage(story!.imageUrl),
            child: story == null
                ? Icon(Icons.add, color: AppColors.primary, size: 30.sp)
                : null,
          ),
        ),
        5.verticalSpace,
        Text(
          story == null ? "Share Story" : (story!.authorName).split(' ').first,
          style: AppTextStyles.mSemiBold,
        ),
      ],
    );
  }
}

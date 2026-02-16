import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/add_story_model_args.dart';
import 'package:social_mate/features/home/models/story_model.dart';

class StoryItem extends StatelessWidget with SU {
  const StoryItem({super.key, this.story, this.onLongPress});
  final StoryModel? story;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return Column(
      children: [
        InkWell(
          onLongPress: onLongPress,
          onTap: () {
            if (story == null) {
              Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.addStoryPage,
                arguments: AddStoryModelArgs(cubit: homeCubit),
              );
            } else {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.viewStoryPage, arguments: story!.authorId);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.0.w),
            ),
            child: _buildStoryContent(story),
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

Widget _buildStoryContent(StoryModel? story) {
  if (story == null) {
    return CircleAvatar(
      radius: 40.r,
      backgroundColor: AppColors.primary,
      child: Icon(Icons.add, color: AppColors.white, size: 30.sp),
    );
  } else if (story.imageUrl != null) {
    return CircleAvatar(
      radius: 40.r,
      backgroundImage: CachedNetworkImageProvider(story.imageUrl!),
    );
  } else if (story.text != null) {
    return CircleAvatar(
      radius: 40.r,
      backgroundColor: Color(story.color),
      child: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Text(
          story.text!,
          textAlign: TextAlign.center,
          style: AppTextStyles.sSemiBold.copyWith(color: AppColors.white),
        ),
      ),
    );
  } else {
    return Container(color: Color(story.color));
  }
}

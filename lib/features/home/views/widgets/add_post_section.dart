import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_gradiant.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/add_post_args.dart';

class AddPostSection extends StatelessWidget {
  const AddPostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Container(
      padding: EdgeInsets.all(25.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppGradiant.paddPostBoxGradient,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pushNamed(
                    AppRoutes.addPostPage,
                    arguments: AddPostArgs(homeCubit: homeCubit),
                  )
                  .then((_) => homeCubit.fetchPosts(isReset: true)),
              child: Row(
                children: [
                  CircleAvatar(radius: 20.r),
                  SizedBox(width: 10.w),
                  Text(
                    "What's on your mind?",
                    style: AppTextStyles.headingH6.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(
                      AppRoutes.addPostPage,
                      arguments: AddPostArgs(
                        homeCubit: homeCubit,
                        openCameraDirectly: true,
                      ),
                    )
                    .then((_) => homeCubit.fetchPosts(isReset: true)),
                child: Row(
                  children: [
                    Icon(Icons.image, color: AppColors.primary, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text("Camera", style: AppTextStyles.mSemiBold),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
                child: VerticalDivider(color: AppColors.black),
              ),
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(
                      AppRoutes.addPostPage,
                      arguments: AddPostArgs(
                        homeCubit: homeCubit,
                        openVideoDirectly: true,
                      ),
                    )
                    .then((_) => homeCubit.fetchPosts(isReset: true)),
                child: Row(
                  children: [
                    Icon(
                      Icons.video_file,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text("Videos", style: AppTextStyles.mSemiBold),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
                child: VerticalDivider(color: AppColors.black),
              ),
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(
                      AppRoutes.addPostPage,
                      arguments: AddPostArgs(
                        homeCubit: homeCubit,
                        openGalleryDirectly: true,
                      ),
                    )
                    .then((_) => homeCubit.fetchPosts(isReset: true)),
                child: Row(
                  children: [
                    Icon(
                      Icons.file_open,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text("Gallery", style: AppTextStyles.mSemiBold),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

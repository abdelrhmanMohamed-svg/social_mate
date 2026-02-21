import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/models/profile_args.dart';
import 'package:social_mate/features/profile/views/widgets/stats_item.dart';
import 'package:social_mate/generated/l10n.dart';

class ProfileStats extends StatelessWidget with SU {
  const ProfileStats({super.key, required this.userData});
  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 2.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsItem(
                title: S.of(context).postsLabel,
                value: userData.postsCount,
              ),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: AppColors.black26, width: 3.w),
              ),

              StatsItem(
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.followersPage,
                      arguments: ProfileArgs(
                        userData: userData,
                        profileCubit: profileCubit,
                      ),
                    ),
                title: S.of(context).followersLabel,
                value: userData.followers != null
                    ? userData.followers!.length
                    : 0,
              ),
              SizedBox(
                height: 50.h,
                child: VerticalDivider(color: AppColors.black26, width: 3.w),
              ),
              StatsItem(
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.followingPage,
                      arguments: ProfileArgs(
                        userData: userData,
                        profileCubit: profileCubit,
                      ),
                    ),
                title: S.of(context).followingLabel,
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

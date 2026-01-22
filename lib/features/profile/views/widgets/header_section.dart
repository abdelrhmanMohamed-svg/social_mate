import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/models/edit_profile_args.dart';
import 'package:social_mate/features/profile/views/widgets/profile_stats.dart';

class HeaderSection extends StatelessWidget with SU {
  const HeaderSection({
    super.key,
    required this.userData,
    this.isPublic = false,
  });
  final UserModel userData;
  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 250.h,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: userData.coverImageUrl == null
                      ? null
                      : DecorationImage(
                          image: CachedNetworkImageProvider(
                            userData.coverImageUrl!,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            Positioned(
              bottom: -45.h,
              right: 0,
              left: 0,
              child: SizedBox(
                height: 150.h,
                width: 150.w,
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    if (isPublic) {
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Icon(
                    isPublic ? Icons.chevron_left : Icons.menu,
                    size: 28.h,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 60.h),
        Text(userData.name ?? "unknown", style: AppTextStyles.headingH4),
        SizedBox(height: 6.h),
        Text(
          userData.bio ?? "There is no Bio yet..",
          style: AppTextStyles.mMedium,
        ),
        SizedBox(height: 20.h),
        isPublic
            ? MainButton(width: 250.h, onTap: () {}, child: Text("FOLLOW"))
            : MainButton(
                width: 250.h,
                onTap: () async {
                  final updatedUser =
                      await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(
                        AppRoutes.editProfilePage,
                        arguments: EditProfileArgs(
                          userData: userData,
                          profileCubit: profileCubit,
                        ),
                      );
                  if (updatedUser is UserModel) {
                    profileCubit.setUser(updatedUser);
                  }
                },
                isTransperent: true,
                child: Text("EDIT PROFILE"),
              ),
        SizedBox(height: 25.h),
        ProfileStats(userData: userData),
      ],
    );
  }
}

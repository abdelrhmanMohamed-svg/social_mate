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
import 'package:social_mate/features/discover/cubit/discover_cubit.dart';
import 'package:social_mate/features/discover/models/public_profile_args.dart';
import 'package:social_mate/generated/l10n.dart';

class DiscoverItem extends StatelessWidget with SU {
  const DiscoverItem({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final dicoverCubit = context.read<DiscoverCubit>();
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.profilePage,
            arguments: PublicProfileArgs(user: user, isPublic: true),
          );
        },
        leading: CircleAvatar(
          radius: 30.r,
          backgroundImage: CachedNetworkImageProvider(
            user.profileImageUrl ?? AppConstants.userIMagePLaceholder,
          ),
        ),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          user.name ?? S.of(context).unknown,
          style: AppTextStyles.lMedium,
        ),
        subtitle: Text(
          " ${user.followers?.length ?? 0} ${S.of(context).followersLabel}",
          style: AppTextStyles.mMedium.copyWith(color: AppColors.gray),
        ),
        trailing: BlocBuilder<DiscoverCubit, DiscoverState>(
          bloc: dicoverCubit,
          buildWhen: (previous, current) =>
              (current is FollowUserLoading && current.userId == user.id) ||
              (current is FollowUserSuccess && current.userId == user.id) ||
              (current is FollowUserFailure && current.userId == user.id),

          builder: (context, state) {
            if (state is FollowUserLoading) {
              return MainButton(height: 40.h, width: 115.w, isLoading: true);
            } else {
              if (state is FollowUserSuccess) {
                return MainButton(
                  height: 40.h,
                  width: 115.w,

                  onTap: () async {
                    await dicoverCubit.followUser(user.id!);
                  },
                  child: Text(
                    state.isUserToFollow
                        ? S.of(context).followLabel
                        : S.of(context).request,
                    style: AppTextStyles.mMedium,
                  ),
                );
              }
              return MainButton(
                height: 40.h,
                width: 115.w,
                onTap: () async => await dicoverCubit.followUser(user.id!),
                child: Text(
                  user.isFollowWaiting
                      ? S.of(context).request
                      : S.of(context).followLabel,
                  style: AppTextStyles.mMedium,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

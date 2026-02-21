import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/generated/l10n.dart';

class FollowOrFollowingItem extends StatelessWidget with SU {
  const FollowOrFollowingItem({
    super.key,
    required this.user,
    this.followerPage = false,
  });
  final UserModel user;
  final bool followerPage;

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        onTap: () {},
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
          S.of(context).followersCount(user.followers?.length ?? 0),
          style: AppTextStyles.mMedium.copyWith(color: AppColors.gray),
        ),
        trailing: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listenWhen: (previous, current) =>
              (current is FollowUserSuccess && current.userId == user.id) ||
              (current is UnFollowUserSuccess && current.userId == user.id) ||
              (current is FollowUserFailure && current.userId == user.id) ||
              (current is UnFollowUserFailure && current.userId == user.id) ||
              (current is UnSendRequestSuccess && current.userId == user.id) ||
              (current is UnSendRequestFailure && current.userId == user.id),

          listener: (context, state) {
            if (state is FollowUserSuccess ||
                state is UnFollowUserSuccess ||
                state is UnSendRequestSuccess) {
              showCustomSnackBar(
                context,
                (state is UnSendRequestSuccess)
                    ? S.of(context).requestSentSuccessfully
                    : (state is FollowUserSuccess)
                    ? S.of(context).followedSuccessfully
                    : S.of(context).unfollowedSuccessfully,
              );
              if (followerPage) {
                profileCubit.fetchFollowers();
              } else {
                profileCubit.fetchFollowing();
              }
            }
            if (state is FollowUserFailure ||
                state is UnFollowUserFailure ||
                state is UnSendRequestFailure) {
              showCustomSnackBar(context, (state as dynamic).error);
            }
          },
          buildWhen: (previous, current) =>
              (current is FollowUserSuccess && current.userId == user.id) ||
              (current is UnFollowUserSuccess && current.userId == user.id) ||
              (current is FollowUserFailure && current.userId == user.id) ||
              (current is UnFollowUserFailure && current.userId == user.id) ||
              (current is FollowUserLoading && current.userId == user.id) ||
              (current is UnFollowUserLoading && current.userId == user.id) ||
              (current is UnSendRequestLoading && current.userId == user.id) ||
              (current is UnSendRequestSuccess && current.userId == user.id) ||
              (current is UnSendRequestFailure && current.userId == user.id),

          builder: (context, state) {
            if (state is FollowUserLoading ||
                state is UnFollowUserLoading ||
                state is UnSendRequestLoading) {
              return MainButton(height: 50.h, width: 130.w, isLoading: true);
            }
            return MainButton(
              onTap: () {
                if (followerPage == false) {
                  profileCubit.unFollowUser(user.id!);
                } else {
                  if (user.isFollow) {
                    profileCubit.unFollowUser(user.id!);
                  } else {
                    if (user.isFollowWaiting == true) {
                      profileCubit.unSendRequest(user.id!);
                    } else {
                      profileCubit.followUser(user.id!);
                    }
                  }
                }
              },
              height: 50.h,
              width: 130.w,
              child: CustomText(followerPage: followerPage, user: user),
            );
          },
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.followerPage, required this.user});

  final bool followerPage;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (followerPage) {
      if (user.isFollowWaiting == true)
        return Text(
          S.of(context).followRequested,
          style: AppTextStyles.sSemiBold,
        );
      if (user.isFollow == true)
        return Text(
          S.of(context).followFollowing,
          style: AppTextStyles.sSemiBold,
        );
      return Text(S.of(context).follow, style: AppTextStyles.sSemiBold);
    }

    return Text(S.of(context).unfollow, style: AppTextStyles.sSemiBold);
  }
}

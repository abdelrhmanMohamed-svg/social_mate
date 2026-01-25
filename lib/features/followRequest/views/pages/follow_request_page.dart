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
import 'package:social_mate/features/followRequest/cubit/follow_request_cubit.dart';

class FollowRequestPage extends StatefulWidget with SU {
  const FollowRequestPage({super.key, required this.users});
  final List<UserModel> users;

  @override
  State<FollowRequestPage> createState() => _FollowRequestPageState();
}

class _FollowRequestPageState extends State<FollowRequestPage> {
  late FollowRequestCubit _followRequestCubit;
  @override
  void initState() {
    super.initState();
    _followRequestCubit = context.read<FollowRequestCubit>();
    _followRequestCubit.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Follow Requests')),
      body: widget.users.isEmpty
          ? Center(child: Text("No Follow Requests"))
          : ListView.separated(
              itemBuilder: (context, index) {
                final user = widget.users[index];
                return Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.r,
                        backgroundImage: CachedNetworkImageProvider(
                          user.profileImageUrl ??
                              AppConstants.userIMagePLaceholder,
                        ),
                      ),
                      title: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        user.name ?? "Unknown",
                        style: AppTextStyles.lMedium,
                      ),
                      trailing:
                          BlocConsumer<FollowRequestCubit, FollowRequestState>(
                            bloc: _followRequestCubit,
                            listenWhen: (previous, current) =>
                                current is FollowRequestAcceptSuccess ||
                                current is FollowRequestRejectSuccess,
                            listener: (context, state) {
                              if (state is FollowRequestAcceptSuccess) {
                                showCustomSnackBar(context, "Request Accepted");
                              }
                              if (state is FollowRequestRejectSuccess) {
                                showCustomSnackBar(context, "Request Rejected");
                              }
                            },
                            buildWhen: (previous, current) =>
                                (current is FollowRequestAcceptLoading &&
                                    current.id == user.id) ||
                                (current is FollowRequestAcceptSuccess &&
                                    current.id == user.id) ||
                                (current is FollowRequestAcceptError &&
                                    current.id == user.id) ||
                                (current is FollowRequestRejectLoading &&
                                    current.id == user.id) ||
                                (current is FollowRequestRejectSuccess &&
                                    current.id == user.id) ||
                                (current is FollowRequestRejectError &&
                                    current.id == user.id),
                            builder: (context, state) {
                              if (state is FollowRequestAcceptLoading ||
                                  state is FollowRequestRejectLoading) {
                                return CircularProgressIndicator.adaptive();
                              } else if (state is FollowRequestAcceptSuccess) {
                                return AcceptAndRejectState(isAccepted: true);
                              } else if (state is FollowRequestRejectSuccess) {
                                return AcceptAndRejectState(isAccepted: false);
                              }
                              return AcceptAndRejectState(
                                onTapAccept: () {
                                  _followRequestCubit.accept(user.id!);
                                },
                                onTapReject: () {
                                  _followRequestCubit.reject(user.id!);
                                },
                              );
                            },
                          ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => 15.verticalSpace,
              itemCount: widget.users.length,
            ),
    );
  }
}

class AcceptAndRejectState extends StatelessWidget {
  const AcceptAndRejectState({
    super.key,
    this.isAccepted,
    this.onTapAccept,
    this.onTapReject,
  });
  final bool? isAccepted;
  final VoidCallback? onTapAccept;
  final VoidCallback? onTapReject;

  @override
  Widget build(BuildContext context) {
    if (isAccepted == true) {
      return MainButton(
        height: 45.h,
        width: 120.w,
        color: AppColors.red,

        child: Text("Accepted", style: AppTextStyles.sMedium),
      );
    } else if (isAccepted == false) {
      return MainButton(
        height: 45.h,
        width: 120.w,
        color: AppColors.red,

        child: Text("Rejected", style: AppTextStyles.sMedium),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MainButton(
          onTap: onTapReject,
          height: 45.h,
          width: 100.w,
          color: AppColors.red,

          child: Text("Reject", style: AppTextStyles.sMedium),
        ),
        10.horizontalSpace,
        MainButton(
          onTap: onTapAccept,
          height: 45.h,

          width: 100.w,
          child: Text("Accept", style: AppTextStyles.sMedium),
        ),
      ],
    );
  }
}

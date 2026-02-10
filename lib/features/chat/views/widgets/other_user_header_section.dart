import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/chat/cubit/single_chat/single_chat_cubit.dart';

class OtherUserHeaderSection extends StatelessWidget with SU {
  const OtherUserHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final singleChatCubit = context.read<SingleChatCubit>();
    return BlocBuilder<SingleChatCubit, SingleChatState>(
      bloc: singleChatCubit,
      buildWhen: (previous, current) =>
          current is SingleChatOtherUserLoading ||
          current is SingleChatOtherUserLoaded ||
          current is SingleChatOtherUserError,
      builder: (context, state) {
        if (state is SingleChatOtherUserLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is SingleChatOtherUserLoaded) {
          final otherUser = state.otherUser;
          return Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundImage: NetworkImage(
                  otherUser.profileImageUrl ??
                      AppConstants.userIMagePLaceholder,
                ),
              ),
              15.horizontalSpace,

              Text(
                otherUser.name ?? 'Unknown',
                style: AppTextStyles.headingH6.copyWith(
                  color: AppColors.black87,
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/generated/l10n.dart';

class CommentSection extends StatelessWidget with SU {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return BlocBuilder<PostCubit, PostState>(
      bloc: postCubit,
      buildWhen: (previous, current) =>
          current is FetchCommentsLoading ||
          current is FetchCommentsSuccess ||
          current is FetchCommentsError,
      builder: (context, state) {
        if (state is FetchCommentsLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FetchCommentsError) {
          return Center(
            child: Text('${S.of(context).errorPrefix} ${state.message}'),
          );
        } else if (state is FetchCommentsSuccess) {
          final comments = state.comments;
          if (comments.isEmpty) {
            return Center(
              child: Text(
                'No comments yet. Be the first to comment!',
                style: AppTextStyles.lRegular,
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundImage: NetworkImage(
                      comment.authorImage ?? AppConstants.userIMagePLaceholder,
                    ),
                  ),
                  12.horizontalSpace,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 15.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.authorName ?? 'Unknown',
                            style: AppTextStyles.lMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            DateFormat(
                              'h:mm a',
                            ).format(DateTime.parse(comment.createdAt)),
                            style: AppTextStyles.sMedium.copyWith(
                              color: AppColors.black45,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            comment.text,
                            style: AppTextStyles.lRegular.copyWith(
                              color: AppColors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/models/post_model.dart';

class PostLikeSection extends StatelessWidget with SU {
  const PostLikeSection({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final  postCubit= context.read<PostCubit>();

    return BlocConsumer<PostCubit, PostState>(
      bloc: postCubit,
      listenWhen: (previous, current) => current is ToggleLikePostError,
      listener: (context, state) {
        if (state is ToggleLikePostError) {
          showCustomSnackBar(context, state.message, isError: true);
        }
      },
      buildWhen: (previous, current) =>
          (current is ToggleLikePostLoading &&
              current.postId == post.id) ||
          (current is ToggleLikePostSuccess &&
              current.postId == post.id) ||
          (current is ToggleLikePostError && current.postId == post.id),
      builder: (context, state) {
        if (state is ToggleLikePostLoading) {
          return Transform.scale(
            scale: 0.5.r,
            child: const CircularProgressIndicator.adaptive(),
          );
        }

        return Row(
          children: [
            InkWell(
              onTap: () async => postCubit.toggleLikePost(post.id),
              child: Icon(
                (state is ToggleLikePostSuccess
                        ? state.isLiked
                        : post.isLiked)
                    ? Icons.thumb_up
                    : Icons.thumb_up_outlined,
                color:
                    (state is ToggleLikePostSuccess
                        ? state.isLiked
                        : post.isLiked)
                    ? AppColors.primary
                    : AppColors.black,
              ),
            ),
            10.horizontalSpace,
            Text(
              (state is ToggleLikePostSuccess
                      ? state.likeCount
                      : post.likes?.length ?? 0)
                  .toString(),
              style: AppTextStyles.lMedium,
            ),
          ],
        );
      },
    );
  }
}

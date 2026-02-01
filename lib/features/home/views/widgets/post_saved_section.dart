import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/models/post_model.dart';

class PostSavedSection extends StatelessWidget {
  const PostSavedSection({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return BlocConsumer<PostCubit, PostState>(
      bloc: postCubit,
      listenWhen: (previous, current) =>
          current is ToggleSavedPostError ||
          (current is ToggleSavedPostSuccess &&
              current.postId == post.id &&
              previous is! ToggleSavedPostSuccess),
      listener: (context, state) {
        if (state is ToggleSavedPostError) {
          showCustomSnackBar(context, state.message, isError: true);
        } else if (state is ToggleSavedPostSuccess) {
          showCustomSnackBar(
            context,
            state.isSaved
                ? "Post saved successfully"
                : "Post unsaved successfully",
          );
        }
      },
      buildWhen: (previous, current) =>
          (current is ToggleSavedPostLoading && current.postId == post.id) ||
          (current is ToggleSavedPostSuccess && current.postId == post.id) ||
          (current is ToggleSavedPostError && current.postId == post.id),
      builder: (context, state) {
        if (state is ToggleSavedPostLoading) {
          return Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator.adaptive(),
          );
        }

        return InkWell(
          onTap: () async => await postCubit.toggleSavedPost(post.id),
          child: Icon(
            (state is ToggleSavedPostSuccess ? state.isSaved : post.isSaved)
                ? Icons.bookmark
                : Icons.bookmark_outline,
            color:
                (state is ToggleSavedPostSuccess ? state.isSaved : post.isSaved)
                ? AppColors.yellowStory
                : AppColors.black,
          ),
        );
      },
    );
  }
}

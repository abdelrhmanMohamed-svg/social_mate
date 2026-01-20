import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/views/widgets/post_item.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return BlocBuilder<PostCubit, PostState>(
      bloc: postCubit,
      buildWhen: (previous, current) =>
          current is FetchedUserPosts ||
          current is FetchingUserPostsError ||
          current is FetchingUserPosts,
      builder: (context, state) {
        if (state is FetchingUserPosts) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FetchingUserPostsError) {
          return Center(child: Text(state.message));
        } else if (state is FetchedUserPosts) {
          final posts = state.posts;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostItem(post: posts[index]),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

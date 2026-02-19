import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/views/widgets/post_item.dart';
import 'package:social_mate/generated/l10n.dart';

class SavedPostsPage extends StatelessWidget {
  const SavedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>()..fetchSavedPosts();

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).savedPosts)),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: postCubit,
        buildWhen: (previous, current) =>
            current is FetchSavedPostsLoading ||
            current is FetchSavedPostsSuccess ||
            current is FetchSavedPostsError,
        builder: (context, state) {
          if (state is FetchSavedPostsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is FetchSavedPostsError) {
            return Center(child: Text(state.message));
          } else if (state is FetchSavedPostsSuccess) {
            final posts = state.posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => PostItem(post: posts[index]),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

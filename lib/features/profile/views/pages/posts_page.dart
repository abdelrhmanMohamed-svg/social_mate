import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/post_item.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late PostCubit postCubit;
  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    postCubit.fetchUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Posts')),
      body: BlocBuilder<PostCubit, PostState>(
        buildWhen: (previous, current) =>
            current is FetchingUserPosts ||
            current is FetchedUserPosts ||
            current is FetchingUserPostsError,
        builder: (context, state) {
          if (state is FetchingUserPosts) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is FetchingUserPostsError) {
            return Center(child: Text(state.message));
          }
          if (state is FetchedUserPosts) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return Center(
                child: Text('No posts found', style: AppTextStyles.headingH6),
              );
            }
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

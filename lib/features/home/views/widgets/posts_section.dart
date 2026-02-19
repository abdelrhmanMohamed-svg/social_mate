import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_mate/core/views/widgets/post_item.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/generated/l10n.dart';

class PostsSection extends StatelessWidget {
  const PostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
      buildWhen: (previous, current) =>
          current is PostsLoaded ||
          current is PostsLoading ||
          current is PostsError,

      builder: (context, state) {
        if (state is PostsLoading) {
          return _ListOfPosts(posts: state.fakePosts, isLoading: true);
        }
        if (state is PostsError) {
          return Center(child: Text(state.message));
        }
        if (state is PostsLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) return Text(S.of(context).noPostsFound);
          return _ListOfPosts(posts: posts);
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _ListOfPosts extends StatelessWidget {
  const _ListOfPosts({required this.posts, this.isLoading = false});

  final List<PostModel> posts;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,

        itemBuilder: (context, index) => PostItem(post: posts[index]),
      ),
    );
  }
}

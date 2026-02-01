import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/core/views/widgets/post_item.dart';

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
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is PostsError) {
          return Center(child: Text(state.message));
        }
        if (state is PostsLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) return Text("There are no posts");
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

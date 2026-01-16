import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/post_model.dart';

class LikeSection extends StatelessWidget {
  const LikeSection({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
      buildWhen: (previous, current) =>
          current is FetchLikesError ||
          current is FetchLikesSuccess ||
          current is FetchLikesLoading,
      builder: (context, state) {
        if (state is FetchLikesLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FetchLikesError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is FetchLikesSuccess) {
          final likedUsers = state.likedUsers;
          if (likedUsers.isEmpty) {
            return Center(
              child: Text('No likes yet.', style: AppTextStyles.mRegular),
            );
          }
          return Row(
            children: List.generate(likedUsers.length, (index) {
              if (index == 8) {
                return Text(
                  '+${likedUsers.length - 8} more',
                  style: AppTextStyles.mMedium,
                );
              } else if (index > 8) {
                return SizedBox.shrink();
              }
              return CircleAvatar(
                backgroundImage: NetworkImage(
                  post.authorImageUrl ?? AppConstants.userIMagePLaceholder,
                ),
              );
            }),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

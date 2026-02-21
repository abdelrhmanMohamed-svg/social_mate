import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/views/widgets/bottom_sheet_section.dart';

class PostCommentSection extends StatelessWidget with SU {
  const PostCommentSection({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return Row(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).cardColor,
              enableDrag: true,
              showDragHandle: true,
              useRootNavigator: true,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => BlocProvider.value(
                value: postCubit,
                child: BottomSheetSection(post: post),
              ),
            );
          },
          child: Icon(
            Icons.mode_comment_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        12.horizontalSpace,

        Text(post.commentsCount.toString(), style: AppTextStyles.lMedium),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/views/widgets/add_comment_section.dart';
import 'package:social_mate/features/home/views/widgets/comment_section.dart';
import 'package:social_mate/features/home/views/widgets/like_section.dart';

class BottomSheetSection extends StatefulWidget with SU {
  const BottomSheetSection({super.key, required this.post});
  final PostModel post;

  @override
  State<BottomSheetSection> createState() => _BottomSheetSectionState();
}

class _BottomSheetSectionState extends State<BottomSheetSection> {
  late PostCubit postCubit;
  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    postCubit.fetchLikesForPost(widget.post.id);
    postCubit.fetchCommentsForPost(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Like",
                    style: AppTextStyles.headingH5.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  15.verticalSpace,
                  LikeSection(post: widget.post),
                  20.verticalSpace,
                  Text(
                    "Comments",
                    style: AppTextStyles.headingH5.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  15.verticalSpace,
                  CommentSection(),
                ],
              ),
            ),
          ),
          Expanded(flex: 1, child: AddCommentSection(post: widget.post)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/generated/l10n.dart';

class AddCommentSection extends StatefulWidget with SU {
  const AddCommentSection({super.key, required this.post});
  final PostModel post;

  @override
  State<AddCommentSection> createState() => _AddCommentSectionState();
}

class _AddCommentSectionState extends State<AddCommentSection> {
  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextField(
            maxLines: 4,
            minLines: 1,
            controller: _textController,
            decoration: InputDecoration(hintText: "Wirte a comment"),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          flex: 2,
          child: BlocConsumer<PostCubit, PostState>(
            bloc: postCubit,
            listenWhen: (previous, current) =>
                current is AddCommentSuccess || current is AddCommentError,
            listener: (context, state) {
              if (state is AddCommentSuccess) {
                showCustomSnackBar(context, "Comment Added Successfully");
                _textController.clear();
                postCubit.fetchCommentsForPost(widget.post.id);
              }
              if (state is AddCommentError) {
                showCustomSnackBar(context, state.message);
              }
            },
            buildWhen: (previous, current) =>
                current is AddCommentSuccess ||
                current is AddCommentLoading ||
                current is AddCommentError,
            builder: (context, state) {
              if (state is AddCommentLoading) {
                return MainButton(width: 100.w, height: 100.h, isLoading: true);
              }
              return MainButton(
                width: 100.w,
                child: Text(
                  S.of(context).addLabel,
                  style: AppTextStyles.lMedium,
                ),
                onTap: () async {
                  if (_textController.text.isNotEmpty) {
                    await postCubit.addComment(
                      _textController.text,
                      widget.post.id,
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

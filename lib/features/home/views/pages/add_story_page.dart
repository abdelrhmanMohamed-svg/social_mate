import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubits/story_cubit/story_cubit.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/views/widgets/color_item.dart';

class AddStoryPage extends StatefulWidget with SU {
  const AddStoryPage({super.key, this.story});
  final StoryModel? story;

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit(this),
      child: AddStoryBody(),
    );
  }
}

class AddStoryBody extends StatefulWidget {
  const AddStoryBody({super.key});

  @override
  State<AddStoryBody> createState() => _AddStoryBodyState();
}

class _AddStoryBodyState extends State<AddStoryBody> {
  late TextEditingController _textController;
  late StoryCubit _storyCubit;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _storyCubit = context.read<StoryCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      bloc: _storyCubit,
      buildWhen: (previous, current) => current is StoryColorChanged,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state is StoryColorChanged
              ? state.color
              : AppColors.primary,
          appBar: AppBar(
            backgroundColor: state is StoryColorChanged
                ? state.color
                : AppColors.primary,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
              color: AppColors.white,
            ),
            actions: [
              BlocConsumer<StoryCubit, StoryState>(
                bloc: _storyCubit,
                listenWhen: (previous, current) =>
                    current is AddStoryError || current is AddStorySuccess,
                listener: (context, state) {
                  if (state is AddStoryError) {
                    showCustomSnackBar(context, state.error, isError: true);
                  } else if (state is AddStorySuccess) {
                    _textController.clear();
                    showCustomSnackBar(context, "Story added successfully");
                    Navigator.of(context).pop();
                  }
                },
                buildWhen: (previous, current) =>
                    current is AddStoryLoading ||
                    current is AddStorySuccess ||
                    current is AddStoryError,
                builder: (context, state) {
                  if (state is AddStoryLoading) {
                    return Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return TextButton(
                    onPressed: () async {
                      if (_textController.text.isEmpty) return;
                      await _storyCubit.addStory(_textController.text);
                    },
                    child: Text(
                      "Done",
                      style: AppTextStyles.lMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: null,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  onEditingComplete: () {
                    if (_textController.text.isEmpty) return;
                    _storyCubit.addStory(_textController.text);
                  },
                  textInputAction: TextInputAction.done,
                  style: AppTextStyles.headingH5.copyWith(
                    color: AppColors.white,
                  ),

                  textAlign: TextAlign.center,
                  showCursor: true,
                  cursorColor: AppColors.white,
                  decoration: InputDecoration(
                    hintText: "Write your thought with others",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: AppTextStyles.headingH5.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    storyColors.length,
                    (index) => ColorItem(
                      color: storyColors[index],
                      onTap: () =>
                          _storyCubit.setChosenStoryColor(storyColors[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

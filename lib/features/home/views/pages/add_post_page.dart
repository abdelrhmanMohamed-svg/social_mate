import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/views/widgets/add_post_txt_field_area.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late HomeCubit homeCubit;
  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>()..fetchCurrentUser();
    homeCubit.setToInitial();
    WidgetsBinding.instance.addPostFrameCallback((_) => openBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(children: [AddPostTxtFieldArea()]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomSheet(),

        child: Icon(Icons.add),
      ),
    );
  }

  void openBottomSheet() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.white,

      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.r),
          width: double.infinity,

          height: 350.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.white,
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.image_outlined,
                  color: AppColors.primary,
                  size: 35.r,
                ),
                title: Text("Add A Photo", style: AppTextStyles.headingH6),
                onTap: () {
                  homeCubit.pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                  size: 35.r,
                ),
                title: Text("Take A Photo", style: AppTextStyles.headingH6),
                onTap: () {
                  homeCubit.pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.video_camera_back_outlined,
                  color: AppColors.primary,
                  size: 35.r,
                ),
                title: Text("Add A Video", style: AppTextStyles.headingH6),
                onTap: () {
                  homeCubit.pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_file,
                  color: AppColors.primary,
                  size: 35.r,
                ),
                title: Text("Attach A File", style: AppTextStyles.headingH6),
                onTap: () {
                  homeCubit.pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

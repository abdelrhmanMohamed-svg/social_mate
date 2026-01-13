import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/views/widgets/file_download_tile.dart';

class PostItem extends StatelessWidget with SU {
  const PostItem({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Card(
      color: AppColors.white,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(25.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: post.authorImageUrl != null
                      ? CachedNetworkImageProvider(post.authorImageUrl!)
                      : null,
                  radius: 28.r,
                ),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName != null
                          ? post.authorName!.split(" ").first.toString()
                          : "Username",
                      style: AppTextStyles.headingH4,
                    ),
                    1.verticalSpace,
                    Text(
                      DateFormat(
                        "h:mm a",
                      ).format(DateTime.parse(post.createdAt)),

                      style: AppTextStyles.sSemiBold,
                    ),
                  ],
                ),
              ],
            ),

            10.verticalSpace,
            Text(post.content, style: AppTextStyles.lRegular),
            if (post.imageUrl != null) ...[
              20.verticalSpace,
              CachedNetworkImage(imageUrl: post.imageUrl!, fit: BoxFit.cover),
              20.verticalSpace,
            ],

            if (post.fileUrl != null && post.fileName != null) ...[
              15.verticalSpace,
              BlocConsumer<HomeCubit, HomeState>(
                bloc: homeCubit,
                listenWhen: (previous, current) => current is OpenFileError,
                listener: (context, state) {
                  if (state is OpenFileError) {
                    showCustomSnackBar(context, state.message, isError: true);
                  }
                },
                buildWhen: (previous, current) =>
                    current is DownloadFileLoading ||
                    current is DownloadFileError ||
                    current is DownloadFileSuccess,
                builder: (context, state) {
                  if (state is DownloadFileLoading) {
                    return FileDownloadTile(
                    fileName: post.fileName!,
                    fileUrl: post.fileUrl!,
                   isloading: true,
                  );
                  }

                  return FileDownloadTile(
                    fileName: post.fileName!,
                    fileUrl: post.fileUrl!,
                    onDownload: () async =>
                        await homeCubit.downloadFile(post.fileUrl!,post.fileName!),
                  );
                },
              ),
              10.verticalSpace,
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined, color: AppColors.black),
                    10.horizontalSpace,
                    Text(
                      post.likes != null
                          ? post.likes!.length.toStringAsFixed(3)
                          : '1',
                      style: AppTextStyles.lMedium,
                    ),
                    20.horizontalSpace,
                    Icon(Icons.mode_comment_outlined, color: AppColors.black),
                    10.horizontalSpace,
                    Text(
                      post.comments != null
                          ? post.comments!.length.toStringAsFixed(3)
                          : '1',
                      style: AppTextStyles.lMedium,
                    ),
                    20.horizontalSpace,
                    Icon(Icons.share_outlined, color: AppColors.black),
                  ],
                ),

                Icon(Icons.bookmark_outline, color: AppColors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

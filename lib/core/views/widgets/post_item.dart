import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart'as PostCubit;
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/views/widgets/file_download_tile.dart';
import 'package:social_mate/features/home/views/widgets/post_comment_section.dart';
import 'package:social_mate/features/home/views/widgets/post_like_section.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostItem extends StatefulWidget with SU {
  const PostItem({super.key, required this.post});
  final PostModel post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.post.videoUrl != null) {
      _initVideo(widget.post.videoUrl!);
    }
  }

  Future<void> _initVideo(String url) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller!.initialize();
    _controller!.setLooping(true);

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit.PostCubit>();
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
                  backgroundImage: widget.post.authorImageUrl != null
                      ? CachedNetworkImageProvider(widget.post.authorImageUrl!)
                      : null,
                  radius: 28.r,
                ),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.authorName != null
                          ? widget.post.authorName!.split(" ").first.toString()
                          : "Username",
                      style: AppTextStyles.headingH4,
                    ),
                    1.verticalSpace,
                    Text(
                      DateFormat(
                        "h:mm a",
                      ).format(DateTime.parse(widget.post.createdAt)),

                      style: AppTextStyles.sSemiBold,
                    ),
                  ],
                ),
              ],
            ),

            10.verticalSpace,
            Text(widget.post.content, style: AppTextStyles.lRegular),
            if (widget.post.imageUrl != null) ...[
              20.verticalSpace,
              CachedNetworkImage(
                imageUrl: widget.post.imageUrl!,
                fit: BoxFit.cover,
              ),
              20.verticalSpace,
            ],

            if (widget.post.fileUrl != null &&
                widget.post.fileName != null) ...[
              15.verticalSpace,
              BlocConsumer<PostCubit.PostCubit, PostCubit.PostState>(
                bloc: postCubit,
                listenWhen: (previous, current) => current is   PostCubit.OpenFileError,
                listener: (context, state) {
                  if (state is  PostCubit.OpenFileError) {
                    showCustomSnackBar(context, state.message, isError: true);
                  }
                },
                buildWhen: (previous, current) =>
                    current is  PostCubit.DownloadFileLoading ||
                    current is PostCubit.DownloadFileError ||
                    current is PostCubit.DownloadFileSuccess,
                builder: (context, state) {
                  if (state is  PostCubit.DownloadFileLoading) {
                    return FileDownloadTile(
                      fileName: widget.post.fileName!,
                      fileUrl: widget.post.fileUrl!,
                      isloading: true,
                    );
                  }

                  return FileDownloadTile(
                    fileName: widget.post.fileName!,
                    fileUrl: widget.post.fileUrl!,
                    onDownload: () async => await postCubit.downloadFile(
                      widget.post.fileUrl!,
                      widget.post.fileName!,
                    ),
                  );
                },
              ),
              10.verticalSpace,
            ],
            if (widget.post.videoUrl != null) ...[
              20.verticalSpace,
              _controller != null && _controller!.value.isInitialized
                  ? InkWell(
                      onTap: () => postCubit.togglePlay(_controller),
                      child: BlocBuilder< PostCubit.PostCubit,  PostCubit.PostState>(
                        bloc: postCubit,
                        buildWhen: (previous, current) =>
                            current is VideoPickedSuccess,
                        builder: (context, state) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),

                                child: SizedBox(
                                  height: 200.h,
                                  width: double.infinity,
                                  child: VisibilityDetector(
                                    key: Key(widget.post.id),
                                    onVisibilityChanged: (info) {
                                      if (info.visibleFraction < 0.5) {
                                        _controller?.pause();
                                      }
                                    },
                                    child: VideoPlayer(_controller!),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: state is  PostCubit.VideoPickedSuccess
                                      ? Icon(
                                          state.controller.value.isPlaying
                                              ? null
                                              : Icons.play_circle_outline,
                                          color: AppColors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          size: 64.sp,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
            ],
            20.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PostLikeSection(post: widget.post),
                    12.horizontalSpace,

                    PostCommentSection(post: widget.post),
                    12.horizontalSpace,
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

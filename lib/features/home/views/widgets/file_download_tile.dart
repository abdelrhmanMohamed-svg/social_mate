import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/views/widgets/file_icon.dart';

class FileDownloadTile extends StatelessWidget with SU {
  final String fileName;
  final String fileUrl;
  final VoidCallback? onDownload;
  final bool isloading;

  const FileDownloadTile({
    super.key,
    required this.fileName,
    required this.fileUrl,
    this.onDownload,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onDownload,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.gray200, width: 1.r),
          ),
          child: Row(
            children: [
              FileIcon(fileName: fileName),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mSemiBold,
                    ),
                    4.verticalSpace,
                    Text(
                      'Tap to download',
                      style: AppTextStyles.sMedium.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              isloading
                  ? Transform.scale(
                      scale: 0.5.r,
                      child: const CircularProgressIndicator.adaptive(),
                    )
                  : const Icon(Icons.download_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

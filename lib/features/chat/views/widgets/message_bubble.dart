import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/chat/models/response_message_model.dart';

class MessageBubble extends StatelessWidget with SU {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isLoading,
  });
  final ResponseMessageModel message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMine;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.gray,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomLeft: isMe ? Radius.circular(12.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(12.r),
          ),
        ),
        child: Text(
          message.content,
          style: AppTextStyles.mRegular.copyWith(
            color: isLoading
                ? AppColors.gray100
                : isMe
                ? Colors.white
                : AppColors.black87,
          ),
        ),
      ),
    );
  }
}

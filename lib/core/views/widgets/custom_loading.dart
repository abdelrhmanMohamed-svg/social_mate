import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class CustomLoading extends StatelessWidget with SU {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: AppColors.primary,
        size: 30.h,
      ),
    );
  }
}

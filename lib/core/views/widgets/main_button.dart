import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    this.child,
    this.onTap,
    this.height = 50,
    this.width = double.infinity,
    this.isLoading = false,
    this.isTransperent = false,
    this.color = AppColors.primary,
  }) : assert(child == null || isLoading == false);
  final Widget? child;
  final VoidCallback? onTap;
  final double height;
  final bool isLoading;
  final double width;
  final bool isTransperent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isTransperent ? AppColors.white : color,
          foregroundColor: isTransperent ? AppColors.black : AppColors.white,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isTransperent
                ? BorderSide(color: AppColors.black26)
                : BorderSide.none,
          ),
        ),
        onPressed: onTap,
        child: isLoading
            ? Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.white,
                ),
              )
            : child,
      ),
    );
  }
}

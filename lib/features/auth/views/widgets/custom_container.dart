import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/extenstions/theme_extenstion.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.imgPath,
    required this.title,
    this.onTap,
  });
  final String imgPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: context.isDarkMode
                ? AppColors.socialButtonBorder
                : AppColors.blackwith60Opacity,
          ),
          color: context.isDarkMode
              ? AppColors.socialButtonBackground
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgPath,
              height: size.height * 0.03,
              fit: BoxFit.contain,
            ),
            SizedBox(width: size.width * 0.02),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

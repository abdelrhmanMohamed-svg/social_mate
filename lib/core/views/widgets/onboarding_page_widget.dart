import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_mate/core/utils/extenstions/theme_extenstion.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String svgAssetPath;
  final String title;
  final String subtitle;
  final String description;
  final bool isFirstPage;

  const OnboardingPageWidget({
    super.key,
    required this.svgAssetPath,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isFirstPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SVG Image
            SvgPicture.asset(svgAssetPath, height: 300.h, fit: BoxFit.contain),
            40.verticalSpace,
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingH3.copyWith(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            12.verticalSpace,
            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.lSemiBold.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            16.verticalSpace,
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.mRegular.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            60.verticalSpace,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.imgPath,
    required this.title,
  });
  final String imgPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.blackwith60Opacity),
      ),
      child: Row(
        children: [
          Image.asset(imgPath, height: size.height * 0.03, fit: BoxFit.contain),
          SizedBox(width: size.width * 0.02),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

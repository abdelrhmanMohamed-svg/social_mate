import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';

class DrawerItem extends StatelessWidget with SU {
  const DrawerItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.isSignout = false,
  }) : assert(
         isSignout == false || trailingIcon == null,
         "signout  must be true or trailingIcon must be set",
       );
  final String title;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final bool isSignout;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        size: 25.h,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.lRegular.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: isSignout
          ? null
          : Icon(
              trailingIcon,
              size: 23.h,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/home/views/widgets/add_post_section.dart';
import 'package:social_mate/features/home/views/widgets/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [HomeHeader(), 20.verticalSpace, AddPostSection()],
        ),
      ),
    );
  }
}

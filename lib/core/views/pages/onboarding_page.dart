import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/cubits/onboarding/onboarding_cubit.dart';
import 'package:social_mate/core/views/widgets/onboarding_button.dart';
import 'package:social_mate/core/views/widgets/onboarding_page_widget.dart';
import 'package:social_mate/core/views/widgets/page_indicator_dots.dart';
import 'package:social_mate/generated/l10n.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  static const int _totalPages = 4;
  static const List<String> _svgAssets = [
    'assets/svgs/onboarding1.svg',
    'assets/svgs/onboarding2.svg',
    'assets/svgs/onboarding3.svg',
    'assets/svgs/onboarding4.svg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _getStarted() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await context.read<OnboardingCubit>().completeOnboarding();
  }

  String _getTitle(int page, S l10n) {
    return switch (page) {
      0 => l10n.onboardingTitle1,
      1 => l10n.onboardingTitle2,
      2 => l10n.onboardingTitle3,
      3 => l10n.onboardingTitle4,
      _ => '',
    };
  }

  String _getSubtitle(int page, S l10n) {
    return switch (page) {
      0 => l10n.onboardingSubtitle1,
      1 => l10n.onboardingSubtitle2,
      2 => l10n.onboardingSubtitle3,
      3 => l10n.onboardingSubtitle4,
      _ => '',
    };
  }

  String _getDescription(int page, S l10n) {
    return switch (page) {
      0 => l10n.onboardingDescription1,
      1 => l10n.onboardingDescription2,
      2 => l10n.onboardingDescription3,
      3 => l10n.onboardingDescription4,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: List.generate(
                  _totalPages,
                  (index) {
                    return OnboardingPageWidget(
                    svgAssetPath: _svgAssets[index],
                    title: _getTitle(index, l10n),
                    subtitle: _getSubtitle(index, l10n),
                    description: _getDescription(index, l10n),
                  );
                  },
                ),
              ),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  // Page Indicator
                  PageIndicatorDots(
                    totalPages: _totalPages,
                    currentPage: _currentPage,
                  ),
                  SizedBox(height: 30.h),

                  // Buttons
                  OnboardingButton(
                    label: _currentPage == _totalPages - 1
                        ? l10n.getStarted
                        : l10n.next,
                    onPressed: _currentPage == _totalPages - 1
                        ? _getStarted
                        : _nextPage,
                    isPrimary: true,
                  ),
                  SizedBox(height: 12.h),
                  OnboardingButton(
                    label: l10n.skip,
                    onPressed: _skipOnboarding,
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

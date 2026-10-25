import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/storage/app_flags.dart';
import '../../../../core/storage/local_cache_service.dart';
import '../../../../core/widgets/common/custom_step_indicator.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../routes/route_names.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_top_bar.dart';
import '../widgets/onboarding_item_widget.dart';

import '../../../../core/utils/responsive.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      mobile: const OnboardingMobileView(),
      tablet: const OnboardingTabView(),
    );
  }
}

class OnboardingMobileView extends ConsumerStatefulWidget {
  const OnboardingMobileView({super.key});

  @override
  ConsumerState<OnboardingMobileView> createState() => _OnboardingMobileViewState();
}

class _OnboardingMobileViewState extends ConsumerState<OnboardingMobileView> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppFlags.setOnboardingDone(ref.read(localCacheServiceProvider));
    if (!mounted) return;
    context.go(RouteNames.login);
  }

  void _next(bool isLastSlide) {
    if (isLastSlide) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final slides = ref.read(onboardingControllerProvider.notifier).slidesFor(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen swipeable background
          PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => OnboardingItemWidget(data: slides[index]),
          ),

          // Bottom scrim so text/controls stay legible over any image
          const IgnorePointer(
            child: Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.transparent, Colors.black87],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Skip button (top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
              child: OnboardingTopBar(onSkip: _finish),
            ),
          ),

          // Step indicator + CTA button (bottom)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomStepIndicator(stepCount: slides.length, currentStep: _currentIndex),
                    const SizedBox(height: AppSizes.lg),
                    PrimaryButton(
                      label: _currentIndex == slides.length - 1
                          ? AppLocalizations.of(context)!.getStarted
                          : AppLocalizations.of(context)!.next,
                      onPressed: () => _next(_currentIndex == slides.length - 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Same behavior as [OnboardingMobileView] for wider (tablet/web) viewports —
/// still full-bleed, content just isn't width-constrained since the image
/// should fill the whole viewport regardless of device size.
class OnboardingTabView extends ConsumerStatefulWidget {
  const OnboardingTabView({super.key});

  @override
  ConsumerState<OnboardingTabView> createState() => _OnboardingTabViewState();
}

class _OnboardingTabViewState extends ConsumerState<OnboardingTabView> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppFlags.setOnboardingDone(ref.read(localCacheServiceProvider));
    if (!mounted) return;
    context.go(RouteNames.login);
  }

  void _next(bool isLastSlide) {
    if (isLastSlide) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final slides = ref.read(onboardingControllerProvider.notifier).slidesFor(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => OnboardingItemWidget(data: slides[index]),
          ),
          const IgnorePointer(
            child: Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.transparent, Colors.black87],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.sm),
              child: OnboardingTopBar(onSkip: _finish),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomStepIndicator(stepCount: slides.length, currentStep: _currentIndex),
                    const SizedBox(height: AppSizes.lg),
                    PrimaryButton(
                      label: _currentIndex == slides.length - 1
                          ? AppLocalizations.of(context)!.getStarted
                          : AppLocalizations.of(context)!.next,
                      onPressed: () => _next(_currentIndex == slides.length - 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
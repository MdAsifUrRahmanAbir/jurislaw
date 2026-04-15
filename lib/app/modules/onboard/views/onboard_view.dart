import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMid,
                  vertical: AppSizes.paddingSmall,
                ),
                child: TextButton(
                  onPressed: controller.skip,
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return _OnboardPage(
                    emoji: page['image'] ?? '🎯',
                    title: page['title'] ?? '',
                    subtitle: page['subtitle'] ?? '',
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Dot indicator + navigation
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMid,
              ),
              child: Column(
                children: [
                  // Dots
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.totalPages,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPage.value == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == i
                                ? AppColors.primary
                                : AppColors.greyLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.gapLarge),

                  // Next / Get Started
                  Obx(
                    () => PrimaryButton(
                      text: controller.isLastPage
                          ? AppStrings.getStarted
                          : AppStrings.next,
                      onPressed: controller.nextPage,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gapMid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isDark;

  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 96)),
          const SizedBox(height: AppSizes.gapXLarge),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.fontXXLarge,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSizes.gapMid),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppSizes.fontMedium,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

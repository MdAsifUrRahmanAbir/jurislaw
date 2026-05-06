part of 'onboard_view.dart';

class OnboardMobile extends GetView<OnboardController> {
  const OnboardMobile({super.key});

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
                  child: Text(
                    AppStrings.skip,
                    style: const TextStyle(
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
                  return OnboardPage(
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

part of 'onboard_view.dart';

class OnboardMobile extends GetView<OnboardController> {
  const OnboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBackground : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // PageView containing illustrations and texts
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  final page = controller.pagesData[index];
                  return OnboardPage(
                    index: index,
                    title1: page['title1'] ?? '',
                    title2: page['title2'] ?? '',
                    subtitle: page['subtitle'] ?? '',
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Bottom Navigation row matching the mockup design
            Obx(() {
              final isLast = controller.isLastPage;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                  vertical: AppSizes.paddingMid,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SKIP Button (left-aligned)
                    TextButton(
                      onPressed: controller.skip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white70 : AppColors.primary.withOpacity(0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                    // Page Indicator Dots (centered)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        controller.totalPages,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPage.value == i ? 10 : 8,
                          height: controller.currentPage.value == i ? 10 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == i
                                ? AppColors.primary
                                : AppColors.grey.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Next / Get Started Action Button (right-aligned)
                    GestureDetector(
                      onTap: controller.nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isLast ? AppColors.gold : AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: (isLast ? AppColors.gold : AppColors.primary).withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLast ? 'GET STARTED' : 'NEXT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

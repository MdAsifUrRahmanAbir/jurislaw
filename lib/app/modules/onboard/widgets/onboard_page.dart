import 'package:flutter/material.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'onboard_illustrations.dart';

class OnboardPage extends StatelessWidget {
  final int index;
  final String title1;
  final String title2;
  final String subtitle;
  final bool isDark;

  const OnboardPage({
    super.key,
    required this.index,
    required this.title1,
    required this.title2,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Illustration container based on page index
            _buildIllustration(),
            const SizedBox(height: 20),
            
            // Styled Headline
            Text(
              title1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.gold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtitle Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    switch (index) {
      case 0:
        return const OnboardIllustrationOne();
      case 1:
        return const OnboardIllustrationTwo();
      case 2:
        return const OnboardIllustrationThree();
      default:
        return const SizedBox(height: 280);
    }
  }
}

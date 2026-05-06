import 'package:flutter/material.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';

class OnboardPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isDark;

  const OnboardPage({
    super.key,
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

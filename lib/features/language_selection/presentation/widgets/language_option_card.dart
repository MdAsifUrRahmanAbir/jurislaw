import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_card.dart';

class LanguageOptionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const LanguageOptionCard({
    super.key,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      accentColor: selected ? AppColors.primary : null,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? AppColors.primary : context.appColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                ),
                const SizedBox(height: AppSizes.xs / 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: AppSizes.iconSm, color: context.appColors.textSecondary),
        ],
      ),
    );
  }
}

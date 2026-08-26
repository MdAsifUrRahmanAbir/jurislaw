import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';

class LawyerCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const LawyerCategoryChips({super.key, required this.categories, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : context.appColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppColors.textWhite : context.appColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: AppSizes.fontSm,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

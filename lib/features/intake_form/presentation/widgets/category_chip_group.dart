import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';

/// Multi-select chip row — no equivalent in core/widgets, so this is
/// intake_form-local. Reuses [AppColors]/[AppSizes] tokens for consistency
/// with the rest of the design system.
class CategoryChipGroup extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const CategoryChipGroup({super.key, required this.options, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option),
            selected: selected.contains(option),
            onSelected: (_) => onToggle(option),
            selectedColor: AppColors.primary.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              fontSize: AppSizes.fontSm,
              color: selected.contains(option) ? AppColors.primary : context.appColors.textPrimary,
              fontWeight: selected.contains(option) ? FontWeight.w600 : FontWeight.w400,
            ),
            side: BorderSide(color: selected.contains(option) ? AppColors.primary : AppColors.border),
            backgroundColor: context.appColors.surface,
          ),
      ],
    );
  }
}

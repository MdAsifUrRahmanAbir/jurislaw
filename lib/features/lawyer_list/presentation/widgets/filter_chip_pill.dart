import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Small dismissible pill shown in the active-filters row.
class FilterChipPill extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const FilterChipPill({super.key, required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSizes.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + AppSizes.xs, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700)),
          const SizedBox(width: AppSizes.xs),
          GestureDetector(onTap: onClear, child: const Icon(Icons.close, size: 14, color: AppColors.primary)),
        ],
      ),
    );
  }
}

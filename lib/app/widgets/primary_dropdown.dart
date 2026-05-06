import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// PrimaryDropdown — consistent dropdown used across all forms.
class PrimaryDropdown<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isRequired;
  final bool? isDark;

  const PrimaryDropdown({
    super.key,
    this.label,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark ?? (Theme.of(context).brightness == Brightness.dark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label!,
              style: TextStyle(
                fontSize: AppSizes.fontSmall,
                fontWeight: FontWeight.w600,
                color: effectiveIsDark ? AppColors.textLight : AppColors.textPrimary,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall - 2),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          dropdownColor: effectiveIsDark ? AppColors.darkCardBackground : Colors.white,
          style: TextStyle(
            color: effectiveIsDark ? Colors.white : AppColors.textPrimary,
            fontSize: AppSizes.fontMedium,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: effectiveIsDark
                ? AppColors.darkCardBackground
                : AppColors.greyLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMid,
              vertical: AppSizes.paddingSmall,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: BorderSide(
                color: effectiveIsDark ? AppColors.greyDark : AppColors.greyLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

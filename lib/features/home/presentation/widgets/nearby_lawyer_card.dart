import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../data/models/lawyer_model.dart';

/// Horizontally-scrolling lawyer tile — home's "Nearby You" row.
class NearbyLawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  final VoidCallback onTap;

  const NearbyLawyerCard({super.key, required this.lawyer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: AppSizes.md, bottom: AppSizes.sm),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: AppSizes.sm, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMd)),
              child: Image.network(lawyer.photo, height: 130, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm + AppSizes.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lawyer.name, style: TextStyle(fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
                  Text(lawyer.specialty, style: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontXs)),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.warning, size: AppSizes.iconSm - 2),
                          Text(' ${lawyer.rating}', style: const TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Text('৳${lawyer.fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/lawyer_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../routes/app_pages.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  const LawyerCard({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.lawyerDetails, arguments: lawyer),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.gapMid),
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: lawyer.photo.isEmpty
                  ? _photoPlaceholder()
                  : Image.network(
                      lawyer.photo,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _photoPlaceholder(),
                    ),
            ),
            const SizedBox(width: AppSizes.gapMid),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lawyer.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontMedium,
                          ),
                        ),
                      ),
                      if (lawyer.rating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.gold, size: 14),
                          Text(
                            ' ${lawyer.rating}',
                            style: const TextStyle(
                              fontSize: AppSizes.fontXS,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    lawyer.specialty,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: AppSizes.fontXS,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.textHint, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lawyer.location,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.fontXS,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${lawyer.experience}+ Years Exp.',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        lawyer.fee > 0
                            ? '${'starting_from'.tr} ৳${lawyer.fee.toStringAsFixed(0)}'
                            : 'no_open_slots'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: lawyer.fee > 0 ? null : 10,
                          color: lawyer.fee > 0 ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
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

  Widget _photoPlaceholder() => Container(
        width: 80,
        height: 80,
        color: AppColors.gold.withValues(alpha: 0.1),
        child: const Icon(Icons.person, color: AppColors.gold, size: 40),
      );
}

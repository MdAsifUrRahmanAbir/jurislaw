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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: Image.network(
                lawyer.photo,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
                      Text(
                        lawyer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMedium,
                        ),
                      ),
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
                        '৳${lawyer.fee}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
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
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../data/models/lawyer_model.dart';

/// Full-width lawyer row — used by home's "Top Rated" list and by
/// lawyer_list's results list.
class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  final VoidCallback onTap;

  const LawyerCard({super.key, required this.lawyer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.network(lawyer.photo, width: 64, height: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lawyer.name,
                    style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                  ),
                  const SizedBox(height: AppSizes.xs / 2),
                  Text(
                    lawyer.specialty,
                    style: const TextStyle(fontSize: AppSizes.fontSm, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: AppSizes.iconSm, color: AppColors.warning),
                      Text(
                        ' ${lawyer.rating} (${lawyer.reviewsCount})',
                        style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        '৳${lawyer.fee.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w700, color: AppColors.primary),
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

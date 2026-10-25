import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/initials_avatar.dart';
import '../../data/models/advocate_model.dart';

/// Directory card — avatar + name + location, practice-area tags, a short
/// bio, then years of experience, starting price and "View Details".
class AdvocateCard extends StatelessWidget {
  final AdvocateSummary advocate;
  final VoidCallback onTap;

  const AdvocateCard({super.key, required this.advocate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                InitialsAvatar(name: advocate.name, imageUrl: advocate.photoUrl, size: 48),
                const SizedBox(width: AppSizes.sm + AppSizes.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              advocate.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: colors.textPrimary),
                            ),
                          ),
                          if (advocate.isVerified) ...[
                            const SizedBox(width: AppSizes.xs),
                            const Icon(Icons.verified_rounded, size: AppSizes.iconSm, color: AppColors.info),
                          ],
                        ],
                      ),
                      if (advocate.location.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: colors.textSecondary),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                advocate.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.divider),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (advocate.practiceAreas.isNotEmpty) ...[
                  Wrap(
                    spacing: AppSizes.xs + 2,
                    runSpacing: AppSizes.xs + 2,
                    children: [
                      for (final area in advocate.practiceAreas.take(3)) TagChip(label: area),
                      if (advocate.practiceAreas.length > 3) TagChip(label: '+${advocate.practiceAreas.length - 3}', color: colors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm + AppSizes.xs),
                ],
                if (advocate.bio.isNotEmpty)
                  Text(
                    advocate.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppSizes.fontSm, height: 1.4, color: colors.textSecondary),
                  ),
                const SizedBox(height: AppSizes.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${advocate.experienceYears}+ ',
                                  style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary),
                                ),
                                TextSpan(text: 'Years Exp', style: TextStyle(color: colors.textSecondary)),
                              ],
                            ),
                            style: const TextStyle(fontSize: AppSizes.fontXs),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            advocate.startingPrice != null
                                ? 'From ${CurrencyFormatter.taka(advocate.startingPrice!)}'
                                : 'No open slots',
                            style: TextStyle(
                              fontSize: AppSizes.fontSm,
                              fontWeight: FontWeight.w700,
                              color: advocate.startingPrice != null ? AppColors.primary : colors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

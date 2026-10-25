import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/initials_avatar.dart';
import '../../../../core/widgets/common/status_badge.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';

/// Header card (avatar, name, location, practice areas) plus the bio and
/// whatever professional details the profile carries.
class AdvocateProfileSection extends StatelessWidget {
  final AdvocateSummary advocate;

  const AdvocateProfileSection({super.key, required this.advocate});

  Widget _sectionTitle(BuildContext context, String text) => Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: context.appColors.textSecondary),
      );

  Widget _detailRow(BuildContext context, IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(top: AppSizes.sm + AppSizes.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppSizes.iconSm + 2, color: AppColors.primary),
            const SizedBox(width: AppSizes.sm + AppSizes.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w600, color: context.appColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final detail = advocate is AdvocateDetail ? advocate as AdvocateDetail : null;
    final details = <Widget>[
      if (detail?.court != null) _detailRow(context, Icons.account_balance_outlined, 'Practicing Court', detail!.court!),
      if (detail?.chamber != null) _detailRow(context, Icons.business_outlined, 'Chamber', detail!.chamber!),
      if (detail?.education != null) _detailRow(context, Icons.school_outlined, 'Education', detail!.education!),
      if (detail?.barEnrollment != null) _detailRow(context, Icons.badge_outlined, 'Bar Council Enrollment', detail!.barEnrollment!),
      if (detail != null && detail.languages.isNotEmpty)
        _detailRow(context, Icons.translate_rounded, 'Languages', detail.languages.join(', ')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomCard(
          child: Column(
            children: [
              InitialsAvatar(name: advocate.name, imageUrl: advocate.photoUrl, size: 104),
              const SizedBox(height: AppSizes.md),
              Text(
                advocate.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppSizes.fontXxl, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                '${advocate.experienceYears}+ Years of Legal Excellence',
                style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary),
              ),
              if (advocate.location.isNotEmpty) ...[
                const SizedBox(height: AppSizes.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined, size: AppSizes.iconSm, color: colors.textSecondary),
                    const SizedBox(width: 2),
                    Text(advocate.location, style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary)),
                  ],
                ),
              ],
              if (advocate.isVerified) ...[
                const SizedBox(height: AppSizes.sm + AppSizes.xs),
                const StatusBadge(
                  text: 'VERIFIED ADVOCATE',
                  type: StatusBadgeType.success,
                  icon: Icons.verified_rounded,
                  compact: true,
                ),
              ],
              if (advocate.practiceAreas.isNotEmpty) ...[
                const SizedBox(height: AppSizes.lg),
                Align(alignment: Alignment.centerLeft, child: _sectionTitle(context, 'Practice Areas')),
                const SizedBox(height: AppSizes.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: AppSizes.xs + 2,
                    runSpacing: AppSizes.xs + 2,
                    children: [for (final area in advocate.practiceAreas) TagChip(label: area)],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (advocate.bio.isNotEmpty) ...[
          const SizedBox(height: AppSizes.md),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Bio'),
                const SizedBox(height: AppSizes.sm),
                Text(advocate.bio, style: TextStyle(fontSize: AppSizes.fontSm, height: 1.55, color: colors.textSecondary)),
              ],
            ),
          ),
        ],
        if (details.isNotEmpty) ...[
          const SizedBox(height: AppSizes.md),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_sectionTitle(context, 'Professional Details'), ...details],
            ),
          ),
        ],
      ],
    );
  }
}

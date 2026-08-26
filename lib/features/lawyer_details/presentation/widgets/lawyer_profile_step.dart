import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../home/data/models/lawyer_model.dart';
import 'lawyer_details_widgets.dart';

class LawyerProfileStep extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerProfileStep({super.key, required this.lawyer});

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm + AppSizes.xs),
      child: Text(title, style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
    );
  }

  Widget _feeRow(BuildContext context, String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs + AppSizes.xs / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.appColors.textSecondary)),
          Text('৳ ${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.radiusXl),
              bottomRight: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.network(lawyer.photo, width: 90, height: 90, fit: BoxFit.cover),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lawyer.name, style: const TextStyle(color: AppColors.textWhite, fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700)),
                    Text(lawyer.specialty, style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSizes.xs),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.warning, size: AppSizes.iconSm),
                        Text(
                          ' ${lawyer.rating} (${lawyer.reviewsCount})',
                          style: const TextStyle(color: AppColors.primaryLight, fontSize: AppSizes.fontXs),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: AppSizes.lg),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            children: [
              QuickInfoItem(icon: Icons.location_on_outlined, label: 'Location', value: lawyer.location.split(',').last.trim()),
              QuickInfoItem(icon: Icons.history, label: 'Experience', value: '${lawyer.experience}+ years'),
              QuickInfoItem(icon: Icons.payments_outlined, label: 'Fee', value: '৳${lawyer.fee.toStringAsFixed(0)}'),
              QuickInfoItem(icon: Icons.language, label: 'Language', value: lawyer.languages.isEmpty ? '-' : lawyer.languages.first),
              const QuickInfoItem(icon: Icons.check_circle_outline, label: 'Available', value: 'Today'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(context, 'Biography'),
              Text(lawyer.bio, style: TextStyle(color: context.appColors.textSecondary, height: 1.5)),
              const SizedBox(height: AppSizes.lg),
              _sectionHeader(context, 'Practice Area'),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.xs,
                children: [
                  for (final area in lawyer.practiceAreas)
                    Chip(
                      label: Text(area),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              _sectionHeader(context, 'Education & Qualification'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school_outlined, color: AppColors.primary, size: AppSizes.iconSm),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(child: Text(lawyer.education, style: TextStyle(color: context.appColors.textSecondary))),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              _sectionHeader(context, 'Bar Council Enrollment'),
              Row(
                children: [
                  const Icon(Icons.assignment_ind_outlined, color: AppColors.primary, size: AppSizes.iconSm),
                  const SizedBox(width: AppSizes.sm),
                  Text('Enrollment No: ${lawyer.barEnrollment}', style: TextStyle(color: context.appColors.textSecondary)),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              _sectionHeader(context, 'Success Rate'),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded, color: AppColors.success, size: AppSizes.iconMd),
                  const SizedBox(width: AppSizes.sm),
                  Text('Estimated Success Rate: ${lawyer.successRate}', style: TextStyle(fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              _sectionHeader(context, 'Consultation Fee Details'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _feeRow(context, 'Virtual Consultation', lawyer.fee),
                    const Divider(),
                    _feeRow(context, 'Physical Meeting', lawyer.fee + 1000),
                    const Divider(),
                    _feeRow(context, 'Urgent Request', lawyer.fee + 500),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              _sectionHeader(context, 'Reviews & Feedback'),
              for (final review in lawyer.reviews) ReviewCard(review: review),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../home/data/models/lawyer_model.dart';

class QuickInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const QuickInfoItem({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: AppSizes.sm + AppSizes.xs),
      padding: const EdgeInsets.all(AppSizes.sm + AppSizes.xs),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: AppSizes.iconSm),
          const SizedBox(height: AppSizes.xs),
          Text(label, style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final LawyerReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(review.date, style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Row(
            children: List.generate(
              5,
              (index) => Icon(Icons.star_rounded, size: 14, color: index < review.rating ? AppColors.warning : AppColors.border),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(review.comment, style: TextStyle(color: context.appColors.textSecondary, fontSize: AppSizes.fontSm)),
        ],
      ),
    );
  }
}

class PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentTile({super.key, required this.icon, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm + AppSizes.xs),
      child: ListTile(
        onTap: onTap,
        tileColor: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        leading: Icon(icon, color: isSelected ? AppColors.primary : context.appColors.textSecondary, size: 30),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : context.appColors.textPrimary)),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
            : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}

class ConsultationTypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ConsultationTypeOption({super.key, required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + AppSizes.xs),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : context.appColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : context.appColors.textSecondary),
              const SizedBox(height: AppSizes.xs),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : context.appColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

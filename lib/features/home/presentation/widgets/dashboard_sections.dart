import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../data/models/dashboard_model.dart';

/// Section title with an optional "See all" link.
class HomeSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const HomeSectionTitle({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text('See all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

/// Horizontal row of stat tiles from `stats`.
class DashboardStatsRow extends StatelessWidget {
  final List<DashboardStat> stats;

  const DashboardStatsRow({super.key, required this.stats});

  static const _icons = <String, IconData>{
    'upcoming': Icons.event_rounded,
    'pending': Icons.hourglass_top_rounded,
    'pending_payment': Icons.payment_rounded,
    'pending_advocate': Icons.hourglass_top_rounded,
    'confirmed': Icons.event_available_rounded,
    'completed': Icons.task_alt_rounded,
    'cancelled': Icons.event_busy_rounded,
  };

  static const _colors = [AppColors.primary, AppColors.info, AppColors.success, AppColors.warning, AppColors.accent];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm + AppSizes.xs),
        itemBuilder: (context, index) {
          final stat = stats[index];
          final tint = _colors[index % _colors.length];
          final number = double.tryParse(stat.value);
          final value = DashboardModel.isMoney(stat.key) && number != null ? CurrencyFormatter.taka(number) : stat.value;
          return SizedBox(
            width: 132,
            child: CustomCard(
              padding: const EdgeInsets.all(AppSizes.sm + AppSizes.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(_icons[stat.key] ?? Icons.insights_rounded, color: tint, size: AppSizes.iconMd),
                  Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                  Text(stat.label, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Muted placeholder row inside a section.
class HomeEmptyNote extends StatelessWidget {
  final IconData icon;
  final String text;

  const HomeEmptyNote({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Icon(icon, color: context.appColors.textHint),
          const SizedBox(width: AppSizes.sm + AppSizes.xs),
          Expanded(child: Text(text, style: TextStyle(color: context.appColors.textSecondary))),
        ],
      ),
    );
  }
}

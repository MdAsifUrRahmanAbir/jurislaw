import 'package:flutter/material.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final bool isDark;

  const SettingsSection({
    super.key,
    this.title,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.toUpperCase(),
            style: const TextStyle(
              fontSize: AppSizes.fontXS,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardBackground
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;
  final Color? iconColor;
  final Color? titleColor;
  final Widget? trailing;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
    this.iconColor,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: AppSizes.iconSmall,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w500,
          color:
              titleColor ??
              (isDark ? AppColors.textLight : AppColors.textPrimary),
        ),
      ),
      trailing:
          trailing ??
          (showChevron
              ? const Icon(Icons.chevron_right_rounded, color: AppColors.grey)
              : null),
      onTap: onTap,
    );
  }
}

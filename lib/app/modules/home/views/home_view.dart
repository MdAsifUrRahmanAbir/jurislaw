import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark
                  ? AppColors.darkScaffoldBackground
                  : AppColors.scaffoldBackground,
              elevation: 0,
              title: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${controller.userName.value} 👋',
                      style: TextStyle(
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.appTagline,
                      style: const TextStyle(
                        fontSize: AppSizes.fontXS,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(Routes.settings),
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      boxShadow: [
                        BoxShadow(color: AppColors.shadow, blurRadius: 4),
                      ],
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      size: AppSizes.iconSmall,
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSmall),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(AppSizes.paddingMid),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Hero card
                  _HeroCard(isDark: isDark),
                  const SizedBox(height: AppSizes.gapLarge),

                  // Quick actions
                  _SectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: AppSizes.gapSmall),
                  _QuickActions(),
                  const SizedBox(height: AppSizes.gapLarge),

                  // Recent activity
                  _SectionTitle(title: 'Recent Activity'),
                  const SizedBox(height: AppSizes.gapSmall),
                  ...List.generate(
                    4,
                    (i) => _ActivityItem(index: i, isDark: isDark),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final bool isDark;
  const _HeroCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Dashboard',
            style: TextStyle(
              fontSize: AppSizes.fontLarge,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSizes.gapXSmall),
          Text(
            'Everything is looking great today!',
            style: TextStyle(
              fontSize: AppSizes.fontSmall,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: AppSizes.gapLarge),
          Row(
            children: [
              _StatChip(label: 'Tasks', value: '12'),
              SizedBox(width: AppSizes.gapSmall),
              _StatChip(label: 'Done', value: '8'),
              SizedBox(width: AppSizes.gapSmall),
              _StatChip(label: 'Pending', value: '4'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingXSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: AppSizes.fontLarge,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.fontXS,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: AppSizes.fontMedium,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textLight : AppColors.textPrimary,
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.bar_chart_rounded,
        'label': 'Reports',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.people_alt_rounded,
        'label': 'Team',
        'color': const Color(0xFF7B61FF),
      },
      {
        'icon': Icons.task_alt_rounded,
        'label': 'Tasks',
        'color': AppColors.success,
      },
      {
        'icon': Icons.settings_rounded,
        'label': 'Settings',
        'color': AppColors.accent,
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return _ActionCard(
          icon: a['icon'] as IconData,
          label: a['label'] as String,
          color: a['color'] as Color,
        );
      }).toList(),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconMid),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontXS,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final int index;
  final bool isDark;
  const _ActivityItem({required this.index, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.gapSmall),
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.primary,
              size: AppSizes.iconSmall,
            ),
          ),
          const SizedBox(width: AppSizes.gapSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Item ${index + 1}',
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '2 hours ago',
                  style: const TextStyle(
                    fontSize: AppSizes.fontXS,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

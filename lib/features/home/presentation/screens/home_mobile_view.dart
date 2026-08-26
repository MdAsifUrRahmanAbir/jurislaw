import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../routes/route_names.dart';
import '../../data/repositories/lawyer_repository.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/lawyer_card.dart';
import '../widgets/lawyer_category_chips.dart';
import '../widgets/nearby_lawyer_card.dart';

class HomeMobileView extends ConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionControllerProvider).user;
    final lawyers = ref.watch(lawyersProvider);
    final selectedCategory = ref.watch(homeControllerProvider);

    return Column(
      children: [
        HomeHeader(
          userName: user?.name ?? 'User',
          avatarUrl: user?.profilePhoto,
          hasUnreadNotifications: true,
          onNotificationTap: () => context.push(RouteNames.notifications),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text(
                    'Select Category',
                    style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: LawyerCategoryChips(
                    categories: lawyerCategories,
                    selected: selectedCategory,
                    onSelected: (c) => ref.read(homeControllerProvider.notifier).selectCategory(c),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text(
                    'Top Rated',
                    style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Column(
                    children: [
                      for (final lawyer in lawyers)
                        LawyerCard(
                          lawyer: lawyer,
                          onTap: () => context.push(RouteNames.lawyerDetails, extra: lawyer),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text(
                    'Nearby You',
                    style: TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    children: [
                      for (final lawyer in lawyers)
                        NearbyLawyerCard(
                          lawyer: lawyer,
                          onTap: () => context.push(RouteNames.lawyerDetails, extra: lawyer),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

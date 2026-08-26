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

/// Wider-viewport layout for home — same content as [HomeMobileView],
/// centered in a max-width column with the lawyer list laid out as a grid.
class HomeTabView extends ConsumerWidget {
  const HomeTabView({super.key});

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
          onNotificationTap: () => context.go(RouteNames.notifications),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                    ),
                    const SizedBox(height: AppSizes.md),
                    LawyerCategoryChips(
                      categories: lawyerCategories,
                      selected: selectedCategory,
                      onSelected: (c) => ref.read(homeControllerProvider.notifier).selectCategory(c),
                    ),
                    const SizedBox(height: AppSizes.xl),
                    Text(
                      'Top Rated',
                      style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                    ),
                    const SizedBox(height: AppSizes.md),
                    for (final lawyer in lawyers)
                      LawyerCard(
                        lawyer: lawyer,
                        onTap: () => context.go(RouteNames.lawyerDetails, extra: lawyer),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

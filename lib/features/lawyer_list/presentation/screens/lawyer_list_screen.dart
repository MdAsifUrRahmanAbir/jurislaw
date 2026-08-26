import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/search_field.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../../../routes/route_names.dart';
import '../../../home/presentation/widgets/lawyer_card.dart';
import '../controllers/lawyer_list_controller.dart';
import '../widgets/filter_chip_pill.dart';
import '../widgets/lawyer_filter_sheet.dart';

class LawyerListScreen extends ConsumerWidget {
  const LawyerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: const _LawyerListBody(maxWidth: double.infinity),
        tablet: const _LawyerListBody(maxWidth: 700),
      ),
    );
  }
}

class _LawyerListBody extends ConsumerWidget {
  final double maxWidth;

  const _LawyerListBody({required this.maxWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(lawyerFilterControllerProvider);
    final controller = ref.read(lawyerFilterControllerProvider.notifier);
    final lawyers = ref.watch(filteredLawyersProvider);

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            title: 'Find Advocates',
            showBack: false,
            trailing: IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () => showLawyerFilterSheet(context, ref),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: SearchField(hintText: 'Search advocates...'),
                    ),
                    if (filter.isActive)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSizes.md, bottom: AppSizes.sm),
                        child: SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              if (filter.area != 'All') FilterChipPill(label: filter.area, onClear: () => controller.setArea('All')),
                              if (filter.location != 'All')
                                FilterChipPill(label: filter.location, onClear: () => controller.setLocation('All')),
                              if (filter.minExperience > 0)
                                FilterChipPill(label: '${filter.minExperience}+ years', onClear: () => controller.setMinExperience(0)),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: lawyers.isEmpty
                          ? EmptyState(
                              title: 'No advocates found',
                              icon: Icons.search_off_rounded,
                              actionLabel: 'Reset Filters',
                              onAction: controller.reset,
                            )
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                              children: [
                                for (final lawyer in lawyers)
                                  LawyerCard(
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
          ),
        ],
      ),
    );
  }
}

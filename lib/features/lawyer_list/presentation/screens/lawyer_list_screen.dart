import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/search_field.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../../../core/widgets/utility/paged_list_view.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/advocate_model.dart';
import '../controllers/lawyer_list_controller.dart';
import '../widgets/advocate_card.dart';
import '../widgets/advocate_filter_sheet.dart';
import '../widgets/filter_chip_pill.dart';

/// The advocate directory (A4.1) — search by name/bio, sort, filter by
/// practice area / division / district / availability, infinite scroll.
class LawyerListScreen extends ConsumerWidget {
  const LawyerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Responsive(
        mobile: _LawyerListBody(maxWidth: double.infinity),
        tablet: _LawyerListBody(maxWidth: 760),
      ),
    );
  }
}

class _LawyerListBody extends ConsumerStatefulWidget {
  final double maxWidth;

  const _LawyerListBody({required this.maxWidth});

  @override
  ConsumerState<_LawyerListBody> createState() => _LawyerListBodyState();
}

class _LawyerListBodyState extends ConsumerState<_LawyerListBody> {
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(advocateQueryProvider).q);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(advocateQueryProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(advocateQueryProvider);
    final queryController = ref.read(advocateQueryProvider.notifier);
    final listState = ref.watch(advocateDirectoryProvider);
    final listController = ref.read(advocateDirectoryProvider.notifier);
    final sorts = ref.watch(advocateFiltersProvider).value?.sorts ?? AdvocateFilters.defaultSorts;

    // The home search card can change the query while this tab is alive.
    ref.listen(advocateQueryProvider, (_, next) {
      if (_searchController.text != next.q) _searchController.text = next.q;
    });

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            title: 'Find Advocates',
            showBack: false,
            trailing: Badge(
              isLabelVisible: query.activeFilterCount > 0,
              label: Text('${query.activeFilterCount}'),
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Filters',
                onPressed: () => showAdvocateFilterSheet(context),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxWidth),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.sm),
                      child: SearchField(
                        hintText: 'Search advocate by name...',
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onSubmitted: (value) {
                          _debounce?.cancel();
                          queryController.setSearch(value);
                        },
                        onClear: query.q.isEmpty
                            ? null
                            : () {
                                _searchController.clear();
                                queryController.setSearch('');
                              },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        children: [
                          _SortChip(sorts: sorts, value: query.sort, onChanged: queryController.setSort),
                          const SizedBox(width: AppSizes.sm),
                          if (query.practiceArea != null)
                            FilterChipPill(
                              label: query.practiceArea!,
                              onClear: () => queryController.set(query.copyWith(clearPracticeArea: true)),
                            ),
                          if (query.division != null)
                            FilterChipPill(
                              label: query.division!,
                              onClear: () => queryController.set(query.copyWith(clearDivision: true, clearDistrict: true)),
                            ),
                          if (query.district != null)
                            FilterChipPill(
                              label: query.district!,
                              onClear: () => queryController.set(query.copyWith(clearDistrict: true)),
                            ),
                          if (query.availableOnly)
                            FilterChipPill(
                              label: 'Available now',
                              onClear: () => queryController.set(query.copyWith(availableOnly: false)),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PagedListView<AdvocateSummary>(
                        state: listState,
                        onRefresh: listController.refresh,
                        onLoadMore: listController.loadMore,
                        onRetryMore: listController.retryMore,
                        empty: EmptyState(
                          title: 'No advocates found',
                          message: query.hasFilters ? 'Try a different name or clear some filters.' : null,
                          icon: Icons.search_off_rounded,
                          actionLabel: query.hasFilters ? 'Clear filters' : null,
                          onAction: query.hasFilters
                              ? () {
                                  _searchController.clear();
                                  queryController.reset();
                                }
                              : null,
                        ),
                        itemBuilder: (context, advocate, _) => AdvocateCard(
                          advocate: advocate,
                          onTap: () => context.push(RouteNames.lawyerDetailsPath(advocate.id), extra: advocate),
                        ),
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

class _SortChip extends StatelessWidget {
  final List<SortOption> sorts;
  final String value;
  final ValueChanged<String> onChanged;

  const _SortChip({required this.sorts, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final current = sorts.where((s) => s.value == value);
    final label = current.isNotEmpty ? current.first.label : 'Recommended';

    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => [for (final s in sorts) PopupMenuItem(value: s.value, child: Text(s.label))],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + AppSizes.xs),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(color: context.appColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert_rounded, size: AppSizes.iconSm, color: context.appColors.textSecondary),
            const SizedBox(width: AppSizes.xs),
            Text(label, style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w600, color: context.appColors.textPrimary)),
            Icon(Icons.arrow_drop_down_rounded, color: context.appColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

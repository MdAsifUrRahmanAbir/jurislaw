import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/dropdown_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../data/models/advocate_model.dart';
import '../../data/repositories/advocate_repository.dart';
import '../controllers/lawyer_list_controller.dart';

Future<void> showAdvocateFilterSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
    builder: (_) => const _AdvocateFilterSheet(),
  );
}

/// Edits a draft copy of the query and applies it on "Show results", so
/// the list is fetched once instead of on every tap.
class _AdvocateFilterSheet extends ConsumerStatefulWidget {
  const _AdvocateFilterSheet();

  @override
  ConsumerState<_AdvocateFilterSheet> createState() => _AdvocateFilterSheetState();
}

class _AdvocateFilterSheetState extends ConsumerState<_AdvocateFilterSheet> {
  late AdvocateQuery _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(advocateQueryProvider);
  }

  void _apply() {
    ref.read(advocateQueryProvider.notifier).set(_draft);
    Navigator.of(context).pop();
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.sm),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
      );

  @override
  Widget build(BuildContext context) {
    final filtersAsync = ref.watch(advocateFiltersProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
        child: filtersAsync.when(
          loading: () => const SizedBox(height: 240, child: CustomLoader()),
          error: (_, _) => const SizedBox.shrink(),
          data: (filters) => SingleChildScrollView(child: _content(filters)),
        ),
      ),
    );
  }

  Widget _content(AdvocateFilters filters) {
    final districts = filters.districtsFor(_draft.division);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Filter Advocates', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
            TextButton(
              onPressed: () => setState(() => _draft = AdvocateQuery(sort: _draft.sort, q: _draft.q)),
              child: const Text('Clear all', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        if (filters.practiceAreas.isNotEmpty) ...[
          _label('Practice Area'),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.xs,
            children: [
              for (final area in filters.practiceAreas)
                ChoiceChip(
                  label: Text(area),
                  selected: _draft.practiceArea == area,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(color: _draft.practiceArea == area ? AppColors.primary : null),
                  onSelected: (selected) => setState(
                    () => _draft = selected ? _draft.copyWith(practiceArea: area) : _draft.copyWith(clearPracticeArea: true),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
        ],
        _label('Location'),
        DropdownField<String>(
          label: 'Division',
          value: _draft.division,
          items: [
            const DropdownMenuItem(value: null, child: Text('All Divisions')),
            for (final d in filters.divisions) DropdownMenuItem(value: d, child: Text(d)),
          ],
          onChanged: (value) => setState(
            () => _draft = value == null
                ? _draft.copyWith(clearDivision: true, clearDistrict: true)
                : _draft.copyWith(division: value, clearDistrict: true),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        DropdownField<String>(
          key: ValueKey('district-${_draft.division}'),
          label: 'District',
          value: districts.contains(_draft.district) ? _draft.district : null,
          items: [
            const DropdownMenuItem(value: null, child: Text('All Districts')),
            for (final d in districts) DropdownMenuItem(value: d, child: Text(d)),
          ],
          onChanged: (value) => setState(
            () => _draft = value == null ? _draft.copyWith(clearDistrict: true) : _draft.copyWith(district: value),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
          title: Text('Available now', style: TextStyle(fontWeight: FontWeight.w600, color: context.appColors.textPrimary)),
          subtitle: const Text('Hide advocates with no bookable slot'),
          value: _draft.availableOnly,
          onChanged: (value) => setState(() => _draft = _draft.copyWith(availableOnly: value)),
        ),
        const SizedBox(height: AppSizes.lg),
        PrimaryButton(label: 'Show results', onPressed: _apply),
      ],
    );
  }
}

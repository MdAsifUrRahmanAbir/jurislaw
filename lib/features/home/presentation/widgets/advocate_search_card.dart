import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/dropdown_field.dart';
import '../../../lawyer_list/data/repositories/advocate_repository.dart';
import '../../../lawyer_list/presentation/controllers/lawyer_list_controller.dart';

/// "Search by name / Division / District → Find Advocates" — the same
/// search box as the web dashboard. Submitting sets the directory query;
/// [onSearch] then switches to the Lawyers tab.
class AdvocateSearchCard extends ConsumerStatefulWidget {
  final VoidCallback onSearch;

  const AdvocateSearchCard({super.key, required this.onSearch});

  @override
  ConsumerState<AdvocateSearchCard> createState() => _AdvocateSearchCardState();
}

class _AdvocateSearchCardState extends ConsumerState<AdvocateSearchCard> {
  final _nameController = TextEditingController();
  String? _division;
  String? _district;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final current = ref.read(advocateQueryProvider);
    ref.read(advocateQueryProvider.notifier).set(AdvocateQuery(
          sort: current.sort,
          q: _nameController.text.trim(),
          division: _division,
          district: _district,
        ));
    widget.onSearch();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final filters = ref.watch(advocateFiltersProvider).value;
    final divisions = filters?.divisions ?? const <String>[];
    final districts = filters?.districtsFor(_division) ?? const <String>[];

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find the right advocate',
            style: TextStyle(color: AppColors.textWhite, fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Find the best legal expertise for your needs',
            style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.85), fontSize: AppSizes.fontSm),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Enter advocate name...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: DropdownField<String>(
                  hint: 'All Divisions',
                  value: _division,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Divisions')),
                    for (final d in divisions) DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (value) => setState(() {
                    _division = value;
                    _district = null;
                  }),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: DropdownField<String>(
                  key: ValueKey('home-district-$_division'),
                  hint: 'All Districts',
                  value: _district,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Districts')),
                    for (final d in districts) DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (value) => setState(() => _district = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + AppSizes.xs),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight - 4,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.search_rounded, size: AppSizes.iconSm),
              label: const Text('Find Advocates'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                elevation: 0,
                textStyle: const TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

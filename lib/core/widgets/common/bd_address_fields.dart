import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_sizes.dart';
import '../../network/bd_geo_service.dart';
import 'dropdown_field.dart';
import 'primary_input_field.dart';

/// Division → District → Upazila dropdowns, loaded from bdapis.com, plus a
/// free-text Village / Mohalla field. Shared by complete-profile and
/// edit-profile so both send the same values.
///
/// 1. Divisions load when the widget first builds.
/// 2. Picking a division loads its districts — each already carries its
///    upazila list, so…
/// 3. …picking a district fills the upazilas with no new request.
///
/// The chosen upazila is written into [upazilaController], so callers read
/// it exactly as before. If the lookup has no upazilas (offline fallback),
/// the upazila field becomes free text.
class BdAddressFields extends ConsumerWidget {
  final String? division;
  final String? district;
  final TextEditingController upazilaController;
  final TextEditingController villageController;
  final ValueChanged<String?> onDivisionChanged;
  final ValueChanged<String?> onDistrictChanged;
  final bool required;

  const BdAddressFields({
    super.key,
    required this.division,
    required this.district,
    required this.upazilaController,
    required this.villageController,
    required this.onDivisionChanged,
    required this.onDistrictChanged,
    this.required = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisionsAsync = ref.watch(bdDivisionsProvider);
    final districtsAsync = division == null ? null : ref.watch(bdDistrictsProvider(division!));

    final districtMap = districtsAsync?.value ?? const <String, List<String>>{};
    final upazilas = district == null ? const <String>[] : districtMap[district] ?? const <String>[];

    // A stored value that is not in the fetched list (spelling differences
    // from the backend) still has to show, or the dropdown asserts.
    final divisionItems = {...?divisionsAsync.value, ?division}.toList();
    final districtItems = {...districtMap.keys, ?district}.toList();

    final divisionsLoading = divisionsAsync.isLoading && !divisionsAsync.hasValue;
    final districtsLoading = districtsAsync != null && districtsAsync.isLoading && !districtsAsync.hasValue;
    final upazilaIsFreeText = district != null && !districtsLoading && upazilas.isEmpty;

    return Column(
      children: [
        DropdownField<String>(
          // Rebuild once the list arrives so a pre-filled value shows.
          key: ValueKey('division-${divisionItems.length}'),
          label: 'Division${required ? ' *' : ''}',
          hint: divisionsLoading ? 'Loading divisions…' : 'Select division',
          value: division,
          enabled: !divisionsLoading,
          items: [for (final d in divisionItems) DropdownMenuItem(value: d, child: Text(d))],
          onChanged: (value) {
            if (value == division) return;
            upazilaController.clear();
            onDivisionChanged(value);
          },
          validator: required ? (value) => value == null ? 'Division is required' : null : null,
        ),
        const SizedBox(height: AppSizes.md),
        DropdownField<String>(
          // Rebuild when the division (or its loaded list) changes so the old
          // district is cleared.
          key: ValueKey('district-$division-${districtItems.length}'),
          label: 'District${required ? ' *' : ''}',
          hint: division == null
              ? 'Select a division first'
              : districtsLoading
                  ? 'Loading districts…'
                  : 'Select district',
          value: districtItems.contains(district) ? district : null,
          enabled: division != null && !districtsLoading,
          items: [for (final d in districtItems) DropdownMenuItem(value: d, child: Text(d))],
          onChanged: (value) {
            if (value == district) return;
            upazilaController.clear();
            onDistrictChanged(value);
          },
          validator: required ? (value) => value == null ? 'District is required' : null : null,
        ),
        const SizedBox(height: AppSizes.md),
        if (upazilaIsFreeText)
          PrimaryInputField(
            label: 'Upazila / Thana',
            hint: 'e.g. Kaliganj',
            controller: upazilaController,
          )
        else
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: upazilaController,
            builder: (context, value, _) {
              final current = value.text.trim().isEmpty ? null : value.text.trim();
              final upazilaItems = {...upazilas, if (district != null) ?current}.toList();
              return DropdownField<String>(
                key: ValueKey('upazila-$division-$district-${upazilaItems.length}'),
                label: 'Upazila / Thana',
                hint: district == null ? 'Select a district first' : 'Select upazila',
                value: upazilaItems.contains(current) ? current : null,
                enabled: district != null,
                items: [for (final u in upazilaItems) DropdownMenuItem(value: u, child: Text(u))],
                onChanged: (u) => upazilaController.text = u ?? '',
              );
            },
          ),
        const SizedBox(height: AppSizes.md),
        PrimaryInputField(
          label: 'Village / Mohalla',
          hint: 'e.g. Test Village',
          controller: villageController,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../constants/bd_locations.dart';
import 'dropdown_field.dart';
import 'primary_input_field.dart';

/// Division → District dropdowns (district list follows the division)
/// plus free-text Upazila / Thana and Village / Mohalla fields. Shared by
/// complete-profile and edit-profile so both send the same values.
class BdAddressFields extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final districts = BdLocations.districtsOf(division);
    // A stored value that is not in the static list (spelling differences
    // from the backend) still has to show, or the dropdown asserts.
    final divisionItems = {...BdLocations.divisions, ?division}.toList();
    final districtItems = {...districts, if (district != null && division != null) district!}.toList();

    return Column(
      children: [
        DropdownField<String>(
          label: 'Division${required ? ' *' : ''}',
          hint: 'Select division',
          value: division,
          items: [for (final d in divisionItems) DropdownMenuItem(value: d, child: Text(d))],
          onChanged: onDivisionChanged,
          validator: required ? (value) => value == null ? 'Division is required' : null : null,
        ),
        const SizedBox(height: AppSizes.md),
        DropdownField<String>(
          // Rebuild when the division changes so the old district is cleared.
          key: ValueKey('district-$division'),
          label: 'District${required ? ' *' : ''}',
          hint: division == null ? 'Select a division first' : 'Select district',
          value: districtItems.contains(district) ? district : null,
          enabled: division != null,
          items: [for (final d in districtItems) DropdownMenuItem(value: d, child: Text(d))],
          onChanged: onDistrictChanged,
          validator: required ? (value) => value == null ? 'District is required' : null : null,
        ),
        const SizedBox(height: AppSizes.md),
        PrimaryInputField(
          label: 'Upazila / Thana',
          hint: 'e.g. Kaliganj',
          controller: upazilaController,
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

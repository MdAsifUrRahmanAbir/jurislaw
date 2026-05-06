part of '../views/registration_view.dart';

class RegistrationAddressInfo extends GetView<RegistrationController> {
  const RegistrationAddressInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADDRESS INFORMATION',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.gapLarge),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => PrimaryDropdown<String>(
                label: 'Division',
                hint: 'Select Division',
                value: controller.selectedDivision.value,
                items: controller.divisions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => controller.selectedDivision.value = v,
                validator: (v) => controller.validateRequired(v, 'Division'),
              )),
            ),
            const SizedBox(width: AppSizes.gapMid),
            Expanded(
              child: Obx(() => PrimaryDropdown<String>(
                label: 'District',
                hint: 'Select District',
                value: controller.selectedDistrict.value,
                items: controller.districts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => controller.selectedDistrict.value = v,
                validator: (v) => controller.validateRequired(v, 'District'),
              )),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.gapMid),

        Obx(() => PrimaryDropdown<String>(
          label: 'Upazila / Thana',
          hint: 'Select Upazila / Thana',
          value: controller.selectedUpazila.value,
          items: controller.upazilas.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => controller.selectedUpazila.value = v,
        )),

        const SizedBox(height: AppSizes.gapMid),
        PrimaryInputField(
          label: 'Village / Mohalla',
          hint: 'e.g. Dhanmondi 32',
          controller: controller.villageCtrl,
        ),      ],
    );
  }
}

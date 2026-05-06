part of 'intake_form_view.dart';

class IntakeFormMobile extends GetView<IntakeFormController> {
  const IntakeFormMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('describe_issue'.tr, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'intake_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            _sectionHeader('problem_category'.tr),
            Obx(() => Wrap(
              spacing: 8,
              children: controller.categories.map((cat) {
                final isSelected = controller.selectedCategories.contains(cat);
                return FilterChip(
                  label: Text(cat.split(' / ').last),
                  selected: isSelected,
                  onSelected: (_) => controller.toggleCategory(cat),
                  selectedColor: AppColors.gold.withOpacity(0.2),
                  labelStyle: TextStyle(color: isSelected ? AppColors.gold : Colors.black, fontSize: 12),
                  side: BorderSide(color: isSelected ? AppColors.gold : Colors.grey[300]!),
                );
              }).toList(),
            )),

            const SizedBox(height: 32),
            _sectionHeader('your_location'.tr),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'division'.tr,
                    value: controller.selectedDivision.value.isEmpty ? null : controller.selectedDivision.value,
                    items: controller.divisions,
                    onChanged: (val) => controller.selectedDivision.value = val!,
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'district'.tr,
                    value: controller.selectedDistrict.value.isEmpty ? null : controller.selectedDistrict.value,
                    items: controller.districts,
                    onChanged: (val) => controller.selectedDistrict.value = val!,
                  )),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _sectionHeader('describe_problem'.tr),
            TextField(
              controller: controller.issueDescription,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'intake_hint'.tr,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
                helperText: 'intake_helper'.tr,
              ),
            ),

            const SizedBox(height: 32),
            _sectionHeader('emergency_flag'.tr),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('emergency_label'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('emergency_subtitle'.tr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Obx(() => Switch(
                        value: controller.isEmergency.value,
                        onChanged: (val) => controller.isEmergency.value = val,
                        activeColor: AppColors.error,
                      )),
                    ],
                  ),
                  Obx(() => controller.isEmergency.value 
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Text('prioritized'.tr, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _sectionHeader('additional_info'.tr),
            _buildInfoCard([
              _buildSimpleDropdown('consultation_type'.tr, controller.selectedConsultationType, ['video_call'.tr, 'audio_call'.tr, 'chat_only'.tr, 'in_person'.tr]),
              const Divider(),
              _buildSimpleDropdown('preferred_lang'.tr, controller.selectedLanguage, ['bangla'.tr, 'english'.tr, 'Both']),
              const Divider(),
              _buildSimpleDropdown('advocate_gender'.tr, controller.preferredGender, ['any'.tr, 'male'.tr, 'female'.tr]),
              const Divider(),
              _buildSimpleDropdown('budget_range'.tr, controller.selectedBudget, ['৳1000 – ৳3000', '৳3000 – ৳5000', '৳5000+']),
            ]),

            const SizedBox(height: 24),
            _sectionHeader('Documents'),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: Text('upload_doc'.tr),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: AppColors.gold),
                foregroundColor: AppColors.gold,
              ),
            ),

            const SizedBox(height: 48),
            PrimaryButton(
              text: 'find_suitable_advocates'.tr,
              onPressed: controller.submitForm,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildDropdown({required String label, String? value, required List<String> items, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      ),
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSimpleDropdown(String label, RxString value, List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Obx(() => DropdownButton<String>(
          value: value.value,
          underline: const SizedBox(),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))).toList(),
          onChanged: (val) => value.value = val!,
        )),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(children: children),
    );
  }
}

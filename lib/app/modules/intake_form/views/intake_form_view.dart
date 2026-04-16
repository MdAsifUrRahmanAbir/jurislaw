import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/intake_form_controller.dart';

class IntakeFormView extends GetView<IntakeFormController> {
  const IntakeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Describe Your Legal Issue', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'আপনার সমস্যাটি বিস্তারিত বলুন, যাতে আমরা সবচেয়ে উপযুক্ত Advocate খুঁজে দিতে পারি',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            _SectionHeader('1. Problem Category'),
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
            _SectionHeader('2. Your Location'),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'Division',
                    value: controller.selectedDivision.value.isEmpty ? null : controller.selectedDivision.value,
                    items: controller.divisions,
                    onChanged: (val) => controller.selectedDivision.value = val!,
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'District',
                    value: controller.selectedDistrict.value.isEmpty ? null : controller.selectedDistrict.value,
                    items: controller.districts,
                    onChanged: (val) => controller.selectedDistrict.value = val!,
                  )),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _SectionHeader('3. Describe Your Problem'),
            TextField(
              controller: controller.issueDescription,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'আপনার সমস্যাটি বিস্তারিত লিখুন। উদাহরণ: আমার স্বামী ৮ মাস ধরে বাসায় ফিরছেন না। আমি divorce চাই এবং সন্তানের ভরণপোষণ চাই।',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
                helperText: 'যত বিস্তারিত লিখবেন, Advocate তত ভালোভাবে বুঝতে পারবেন।',
              ),
            ),

            const SizedBox(height: 32),
            _SectionHeader('4. Emergency Flag'),
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('এটি জরুরি (Emergency)', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('যেমন: Arrest, Bail, Domestic Violence ইত্যাদি', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
                            const Text('Your request will be prioritized', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _SectionHeader('5. Additional Information'),
            _buildInfoCard([
              _buildSimpleDropdown('Consultation Type', controller.selectedConsultationType, ['Video Call', 'Audio Call', 'Chat Only', 'In-person']),
              const Divider(),
              _buildSimpleDropdown('Preferred Language', controller.selectedLanguage, ['Bengali', 'English', 'Both']),
              const Divider(),
              _buildSimpleDropdown('Advocate Gender', controller.preferredGender, ['Any', 'Male', 'Female']),
              const Divider(),
              _buildSimpleDropdown('Budget Range', controller.selectedBudget, ['৳1000 – ৳3000', '৳3000 – ৳5000', '৳5000+']),
            ]),

            const SizedBox(height: 24),
            _SectionHeader('Documents'),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Related Documents (PDF, JPG)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: AppColors.gold),
                foregroundColor: AppColors.gold,
              ),
            ),

            const SizedBox(height: 48),
            PrimaryButton(
              text: 'Find Suitable Advocates',
              onPressed: controller.submitForm,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _SectionHeader(String title) {
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

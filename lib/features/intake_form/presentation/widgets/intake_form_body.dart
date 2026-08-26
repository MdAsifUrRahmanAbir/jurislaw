import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/dropdown_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/primary_input_field.dart';
import '../../../../core/widgets/common/primary_switch.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/intake_form_controller.dart';
import 'category_chip_group.dart';

/// Shared form body for both mobile and tablet intake_form layouts —
/// only the surrounding scaffold/padding differs between the two.
class IntakeFormBody extends ConsumerWidget {
  final VoidCallback onSubmitted;

  const IntakeFormBody({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(intakeFormControllerProvider.notifier);
    final state = ref.watch(intakeFormControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tell us about your legal issue and we'll match you with the right advocate.",
          style: TextStyle(color: context.appColors.textSecondary, fontSize: AppSizes.fontSm),
        ),
        const SizedBox(height: AppSizes.lg),
        const SectionHeader(title: 'Problem Category'),
        const SizedBox(height: AppSizes.sm),
        CategoryChipGroup(
          options: IntakeFormOptions.categories,
          selected: state.selectedCategories,
          onToggle: controller.toggleCategory,
        ),
        const SizedBox(height: AppSizes.xl),
        const SectionHeader(title: 'Your Location'),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: DropdownField<String>(
                label: 'Division',
                hint: 'Select Division',
                value: state.division,
                items: [for (final d in IntakeFormOptions.divisions) DropdownMenuItem(value: d, child: Text(d))],
                onChanged: controller.setDivision,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: DropdownField<String>(
                label: 'District',
                hint: 'Select District',
                value: state.district,
                items: [for (final d in IntakeFormOptions.districts) DropdownMenuItem(value: d, child: Text(d))],
                onChanged: controller.setDistrict,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        const SectionHeader(title: 'Describe Your Problem'),
        const SizedBox(height: AppSizes.sm),
        PrimaryInputField(
          controller: controller.issueDescriptionController,
          hint: 'Explain your situation in a few sentences...',
          maxLines: 6,
        ),
        const SizedBox(height: AppSizes.xl),
        const SectionHeader(title: 'Emergency'),
        const SizedBox(height: AppSizes.sm),
        CustomCard(
          child: Column(
            children: [
              PrimarySwitch(
                value: state.isEmergency,
                onChanged: controller.setEmergency,
                label: 'This is an emergency',
                subtitle: 'We will prioritize matching you with an available advocate',
              ),
              if (state.isEmergency)
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.sm),
                  padding: const EdgeInsets.all(AppSizes.sm),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: AppSizes.iconSm),
                      const SizedBox(width: AppSizes.sm),
                      const Text(
                        'This request will be prioritized',
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: AppSizes.fontSm),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        const SectionHeader(title: 'Additional Info'),
        const SizedBox(height: AppSizes.sm),
        CustomCard(
          child: Column(
            children: [
              DropdownField<String>(
                label: 'Consultation Type',
                value: state.consultationType,
                items: [for (final t in IntakeFormOptions.consultationTypes) DropdownMenuItem(value: t, child: Text(t))],
                onChanged: (v) => controller.setConsultationType(v!),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownField<String>(
                label: 'Preferred Language',
                value: state.language,
                items: [for (final l in IntakeFormOptions.languages) DropdownMenuItem(value: l, child: Text(l))],
                onChanged: (v) => controller.setLanguage(v!),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownField<String>(
                label: 'Advocate Gender',
                value: state.preferredGender,
                items: [for (final g in IntakeFormOptions.genders) DropdownMenuItem(value: g, child: Text(g))],
                onChanged: (v) => controller.setPreferredGender(v!),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownField<String>(
                label: 'Budget Range',
                value: state.budget,
                items: [for (final b in IntakeFormOptions.budgets) DropdownMenuItem(value: b, child: Text(b))],
                onChanged: (v) => controller.setBudget(v!),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        const SectionHeader(title: 'Documents'),
        const SizedBox(height: AppSizes.sm),
        OutlinedButton.icon(
          onPressed: () => CustomSnackbar.show(context, 'Document upload coming soon'),
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('Upload Supporting Document'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSizes.xxl),
        PrimaryButton(
          label: 'Find Suitable Advocates',
          onPressed: () {
            if (!controller.submit()) {
              CustomSnackbar.show(context, 'Please select at least one category and describe your issue.', error: true);
              return;
            }
            onSubmitted();
          },
        ),
        const SizedBox(height: AppSizes.xl),
      ],
    );
  }
}

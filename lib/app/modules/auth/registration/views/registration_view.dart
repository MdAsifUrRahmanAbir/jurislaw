import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/primary_input_field.dart';
import '../../../../widgets/rich_text_widget.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.gapXXLarge),

                // Header
                Text(
                  'Register for Jurisheba ✨',
                  style: const TextStyle(
                    fontSize: AppSizes.fontXXXLarge,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSizes.gapXSmall),
                const Text(
                  'Join Bangladesh\'s leading legal network',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.gapXXLarge),

                // Full name
                PrimaryInputField(
                  label: AppStrings.fullName,
                  hint: AppStrings.fullNameHint,
                  controller: controller.nameCtrl,
                  validator: controller.validateName,
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.gold),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Phone
                PrimaryInputField(
                  label: AppStrings.phoneNumber,
                  hint: AppStrings.phoneHint,
                  controller: controller.phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                  prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.gold),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Email
                PrimaryInputField(
                  label: AppStrings.email + ' (Optional)',
                  hint: AppStrings.emailHint,
                  controller: controller.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.gold),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // District
                PrimaryInputField(
                  label: 'District / City',
                  hint: 'e.g. Dhaka, Chittagong',
                  controller: controller.districtCtrl,
                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.gold),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Gender (Simple Choice)
                const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() => Row(
                  children: [
                    _GenderOption(
                      label: 'Male', 
                      isSelected: controller.gender.value == 'Male',
                      onTap: () => controller.gender.value = 'Male',
                    ),
                    const SizedBox(width: 8),
                    _GenderOption(
                      label: 'Female', 
                      isSelected: controller.gender.value == 'Female',
                      onTap: () => controller.gender.value = 'Female',
                    ),
                  ],
                )),

                const SizedBox(height: AppSizes.gapXXLarge),

                // Register button
                Obx(
                  () => PrimaryButton(
                    text: 'Register Account',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Login link
                Center(
                  child: RichTextWidget(
                    normalText: AppStrings.alreadyHaveAccount,
                    highlightText: AppStrings.signIn,
                    onTap: controller.goToLogin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _GenderOption({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : AppColors.chipBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

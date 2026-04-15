import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../widgets/primary_appbar_widget.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/primary_input_field.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(title: AppStrings.changePassword),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              const SizedBox(height: AppSizes.gapMid),

              // Info card
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingMid),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: AppSizes.iconSmall,
                    ),
                    SizedBox(width: AppSizes.gapXSmall),
                    Expanded(
                      child: Text(
                        'Choose a strong password with at least 6 characters.',
                        style: TextStyle(
                          fontSize: AppSizes.fontSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.gapXLarge),

              // Current password
              Obx(
                () => PrimaryInputField(
                  label: 'Current Password',
                  hint: 'Enter current password',
                  controller: controller.currentPasswordCtrl,
                  obscureText: !controller.isCurrentPasswordVisible.value,
                  validator: controller.validateCurrent,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textHint,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isCurrentPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textHint,
                    ),
                    onPressed: controller.toggleCurrentVisibility,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // New password
              Obx(
                () => PrimaryInputField(
                  label: 'New Password',
                  hint: 'Enter new password',
                  controller: controller.newPasswordCtrl,
                  obscureText: !controller.isNewPasswordVisible.value,
                  validator: controller.validateNew,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textHint,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textHint,
                    ),
                    onPressed: controller.toggleNewVisibility,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // Confirm password
              Obx(
                () => PrimaryInputField(
                  label: AppStrings.confirmPassword,
                  hint: AppStrings.confirmPasswordHint,
                  controller: controller.confirmPasswordCtrl,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  validator: controller.validateConfirm,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textHint,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textHint,
                    ),
                    onPressed: controller.toggleConfirmVisibility,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.gapXLarge),

              // Submit button
              Obx(
                () => PrimaryButton(
                  text: AppStrings.changePassword,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

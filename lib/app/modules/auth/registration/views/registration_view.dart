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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  'Create Account ✨',
                  style: TextStyle(
                    fontSize: AppSizes.fontXXXLarge,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSizes.gapXSmall),
                const Text(
                  'Fill in the details to get started',
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
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Email
                PrimaryInputField(
                  label: AppStrings.email,
                  hint: AppStrings.emailHint,
                  controller: controller.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Password
                Obx(
                  () => PrimaryInputField(
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    controller: controller.passwordCtrl,
                    obscureText: !controller.isPasswordVisible.value,
                    validator: controller.validatePassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textHint,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textHint,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Confirm Password
                Obx(
                  () => PrimaryInputField(
                    label: AppStrings.confirmPassword,
                    hint: AppStrings.confirmPasswordHint,
                    controller: controller.confirmPasswordCtrl,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    validator: controller.validateConfirmPassword,
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
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.gapXLarge),

                // Register button
                Obx(
                  () => PrimaryButton(
                    text: AppStrings.signUp,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Login link
                RichTextWidget(
                  normalText: AppStrings.alreadyHaveAccount,
                  highlightText: AppStrings.signIn,
                  onTap: controller.goToLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

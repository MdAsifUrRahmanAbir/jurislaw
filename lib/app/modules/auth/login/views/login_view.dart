import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/primary_input_field.dart';
import '../../../../widgets/rich_text_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: AppSizes.fontXXXLarge,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSizes.gapXSmall),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.gapXXLarge),

                // Email field
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

                // Password field
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
                const SizedBox(height: AppSizes.gapXSmall),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {}, // TODO: navigate to forgot password
                    child: const Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        fontSize: AppSizes.fontSmall,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.gapXLarge),

                // Login button
                Obx(
                  () => PrimaryButton(
                    text: AppStrings.signIn,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  ),
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Register link
                RichTextWidget(
                  normalText: AppStrings.dontHaveAccount,
                  highlightText: AppStrings.signUp,
                  onTap: controller.goToRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

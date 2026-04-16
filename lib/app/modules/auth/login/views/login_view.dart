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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.gapXXLarge),
                
                // Branding/Logo could go here
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.paddingMid),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                    ),
                    child: const Icon(Icons.gavel_rounded, color: AppColors.gold, size: 50),
                  ),
                ),
                
                const SizedBox(height: AppSizes.gapXXLarge),

                Obx(() => Text(
                  controller.isOtpSent.value ? 'Enter OTP' : 'Welcome to Jurisheba',
                  style: const TextStyle(
                    fontSize: AppSizes.fontXXXLarge,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                )),
                const SizedBox(height: AppSizes.gapXSmall),
                Obx(() => Text(
                  controller.isOtpSent.value 
                    ? 'OTP sent to ${controller.phoneCtrl.text}' 
                    : 'Sign in with your phone number',
                  style: const TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                )),
                
                const SizedBox(height: AppSizes.gapXXLarge),

                Obx(() => controller.isOtpSent.value 
                  ? PrimaryInputField(
                      label: 'OTP Code',
                      hint: 'Enter 4-digit code',
                      controller: controller.otpCtrl,
                      keyboardType: TextInputType.number,
                      validator: controller.validateOtp,
                      prefixIcon: const Icon(Icons.lock_open_rounded, color: AppColors.gold),
                    )
                  : PrimaryInputField(
                      label: AppStrings.phoneNumber,
                      hint: AppStrings.phoneHint,
                      controller: controller.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: controller.validatePhone,
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.gold),
                    )
                ),

                const SizedBox(height: AppSizes.gapXLarge),

                Obx(() => PrimaryButton(
                  text: controller.isOtpSent.value ? 'Verify & Login' : 'Send OTP',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isOtpSent.value 
                    ? controller.verifyOtp 
                    : controller.sendOtp,
                )),

                const SizedBox(height: AppSizes.gapLarge),

                if (!controller.isOtpSent.value)
                  Center(
                    child: RichTextWidget(
                      normalText: AppStrings.dontHaveAccount,
                      highlightText: AppStrings.signUp,
                      onTap: controller.goToRegister,
                    ),
                  ),
                
                if (controller.isOtpSent.value)
                  Center(
                    child: TextButton(
                      onPressed: () => controller.isOtpSent.value = false,
                      child: const Text(
                        'Change Phone Number',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

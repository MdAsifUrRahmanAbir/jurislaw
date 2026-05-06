part of '../views/login_view.dart';

class LoginFooter extends GetView<LoginController> {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => !controller.isOtpSent.value
            ? Center(
                child: RichTextWidget(
                  normalText: AppStrings.dontHaveAccount,
                  highlightText: AppStrings.signUp,
                  onTap: controller.goToRegister,
                ),
              )
            : const SizedBox.shrink()),
        Obx(() => controller.isOtpSent.value
            ? Center(
                child: Column(
                  children: [
                    if (!controller.canResend.value)
                      Text(
                        'Resend OTP in ${controller.resendSeconds.value}s',
                        style: const TextStyle(color: AppColors.textSecondary),
                      )
                    else
                      TextButton(
                        onPressed: controller.resendOtp,
                        child: Text(
                          'resend_otp'.tr,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: AppSizes.gapSmall),
                    TextButton(
                      onPressed: () => controller.isOtpSent.value = false,
                      child: Text(
                        'change_phone'.tr,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}

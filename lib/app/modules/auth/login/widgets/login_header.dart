part of '../views/login_view.dart';

class LoginHeader extends GetView<LoginController> {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              controller.isOtpSent.value ? 'enter_otp'.tr : 'welcome_to'.tr,
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
                  ? 'otp_sent_to'.trParams({'phone': controller.phoneCtrl.text})
                  : 'sign_in_phone'.tr,
              style: const TextStyle(
                fontSize: AppSizes.fontMedium,
                color: AppColors.textSecondary,
              ),
            )),
      ],
    );
  }
}

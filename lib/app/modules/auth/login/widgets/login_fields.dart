part of '../views/login_view.dart';

class LoginFields extends GetView<LoginController> {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isOtpSent.value
        ? PrimaryInputField(
            label: 'otp_code'.tr,
            hint: 'enter_4_digit'.tr,
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
          ));
  }
}

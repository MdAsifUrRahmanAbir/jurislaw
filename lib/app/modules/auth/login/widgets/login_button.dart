part of '../views/login_view.dart';

class LoginButton extends GetView<LoginController> {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PrimaryButton(
          text: controller.isOtpSent.value ? 'verify_login'.tr : 'send_otp'.tr,
          isLoading: controller.isOtpSent.value ? controller.isVerifyLoading : controller.isLoading,
          onPressed: controller.isOtpSent.value ? controller.verifyOtp : controller.sendOtp,
        ));
  }
}

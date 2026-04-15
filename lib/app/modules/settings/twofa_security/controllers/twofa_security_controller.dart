import 'package:get/get.dart';

class TwofaSecurityController extends GetxController {
  final isTwoFaEnabled = false.obs;
  final otpCtrl = ''.obs;
  final isLoading = false.obs;

  void toggleTwoFa(bool value) {
    isTwoFaEnabled.value = value;
    // TODO: call backend to enable/disable 2FA
  }

  void onOtpChanged(String value) => otpCtrl.value = value;

  Future<void> verifyOtp() async {
    if (otpCtrl.value.length < 6) {
      Get.snackbar(
        'Error',
        'Please enter the full 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;
    try {
      // TODO: verify OTP via API or Firebase
      await Future.delayed(const Duration(milliseconds: 800));
      Get.back();
      Get.snackbar(
        'Success',
        '2FA security updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}

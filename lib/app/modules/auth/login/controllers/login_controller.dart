import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/app_snackbar.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  
  final isOtpSent = false.obs;
  final isLoading = false.obs;

  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone number is required';
    if (v.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? validateOtp(String? v) {
    if (v == null || v.isEmpty) return 'OTP is required';
    if (v.length < 4) return 'Enter 4 digit OTP';
    return null;
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // Simulate sending OTP
      await Future.delayed(const Duration(seconds: 1));
      isOtpSent.value = true;
      AppSnackBar.success('OTP sent to your phone');
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpCtrl.text.length < 4) {
      AppSnackBar.error('Please enter a valid OTP');
      return;
    }
    isLoading.value = true;
    try {
      // Simulate verifying OTP
      await Future.delayed(const Duration(seconds: 1));
      
      await LocalStorage.savePhone(phone: phoneCtrl.text.trim());
      await LocalStorage.setLoggedIn(value: true);

      Get.offAllNamed(Routes.bottomNav);
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(Routes.register);

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    super.onClose();
  }
}

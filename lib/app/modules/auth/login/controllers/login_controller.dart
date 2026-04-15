import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/app_snackbar.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(v)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // TODO: replace with AuthApiServices.signInProcessApi(body: {...})
      await Future.delayed(const Duration(milliseconds: 800)); // Simulated

      // On success:
      await LocalStorage.saveToken(token: 'simulated_token_here');
      await LocalStorage.saveEmail(email: emailCtrl.text.trim());
      await LocalStorage.setLoggedIn(value: true);

      Get.offAllNamed(Routes.bottomNav);
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(Routes.register);
  void goToForgotPassword() {}

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}

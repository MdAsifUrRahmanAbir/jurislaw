import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/app_snackbar.dart';
import '../../../../routes/app_pages.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return 'Full name is required';
    if (v.length < 2) return 'Name is too short';
    return null;
  }

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

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // TODO: replace with AuthApiServices.signUpProcessApi(body: {...})
      await Future.delayed(const Duration(milliseconds: 800)); // Simulated

      // On success:
      await LocalStorage.saveName(name: nameCtrl.text.trim());
      await LocalStorage.saveEmail(email: emailCtrl.text.trim());
      await LocalStorage.setLoggedIn(value: true);
      await LocalStorage.saveToken(token: 'simulated_token_here');

      Get.offAllNamed(Routes.bottomNav);
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.back();

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}

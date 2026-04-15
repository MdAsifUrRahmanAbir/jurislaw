import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void toggleCurrentVisibility() =>
      isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  String? validateCurrent(String? v) {
    if (v == null || v.isEmpty) return AppStrings.required;
    return null;
  }

  String? validateNew(String? v) {
    if (v == null || v.isEmpty) return AppStrings.required;
    if (v.length < 6) return AppStrings.weakPassword;
    return null;
  }

  String? validateConfirm(String? v) {
    if (v == null || v.isEmpty) return AppStrings.required;
    if (v != newPasswordCtrl.text) return AppStrings.passwordMismatch;
    return null;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // TODO: call ApiService or FirebaseService here
      await Future.delayed(const Duration(milliseconds: 800));
      Get.back();
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}

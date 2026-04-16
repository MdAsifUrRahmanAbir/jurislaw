import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/app_snackbar.dart';
import '../../../../routes/app_pages.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  
  final gender = 'Male'.obs;
  final isLoading = false.obs;

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return 'Full name is required';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone number is required';
    return null;
  }

  String? validateEmail(String? v) {
    if (v != null && v.isNotEmpty && !GetUtils.isEmail(v)) return 'Enter a valid email';
    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      await LocalStorage.saveName(name: nameCtrl.text.trim());
      await LocalStorage.savePhone(phone: phoneCtrl.text.trim());
      await LocalStorage.setLoggedIn(value: true);

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
    phoneCtrl.dispose();
    emailCtrl.dispose();
    districtCtrl.dispose();
    super.onClose();
  }
}

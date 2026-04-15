import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/app_snackbar.dart';

class UpdateProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() {
    nameCtrl.text = LocalStorage.getName();
    emailCtrl.text = LocalStorage.getEmail();
  }

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return 'Full name is required';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(v)) return 'Enter a valid email address';
    return null;
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // TODO: call ApiServices.post<ProfileModel>(ProfileModel.fromJson, AppEndpoint.profileUpdateURL, body: {...})
      await Future.delayed(const Duration(milliseconds: 800));

      await LocalStorage.saveName(name: nameCtrl.text.trim());
      await LocalStorage.saveEmail(email: emailCtrl.text.trim());

      Get.back();
      AppSnackBar.success('Profile updated successfully');
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    bioCtrl.dispose();
    locationCtrl.dispose();
    super.onClose();
  }
}

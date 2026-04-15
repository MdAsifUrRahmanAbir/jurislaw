import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = LocalStorage.isDarkMode();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    LocalStorage.saveDarkMode(isDark: value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: FCM subscribe/unsubscribe
  }

  void goToChangePassword() => Get.toNamed(Routes.changePassword);
  void goToTwoFaSecurity() => Get.toNamed(Routes.twofaSecurity);

  Future<void> logout() async {
    await LocalStorage.signOut();
    Get.offAllNamed(Routes.login);
  }

  String get appVersion => '1.0.0';
}

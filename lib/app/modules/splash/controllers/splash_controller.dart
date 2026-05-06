import 'dart:async';

import 'package:get/get.dart';

import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';

/// Matches Remitium's SplashController pattern exactly:
///  - onReady() (fires after widget is mounted)
///  - Timer (dart:async) for the delay — NOT Future.delayed
///  - Get.offAllNamed / Get.offAndToNamed for navigation
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 2), () {
      _goToScreen();
    });
  }

  void _goToScreen() {
    if (LocalStorage.isLoggedIn()) {
      Get.offAllNamed(Routes.bottomNav);
    } else if (!LocalStorage.isLanguageSet()) {
      Get.offAllNamed(Routes.languageSelection);
    } else if (LocalStorage.isOnboardDone()) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.onboard);
    }
  }
}

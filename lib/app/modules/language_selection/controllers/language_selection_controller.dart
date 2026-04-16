import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class LanguageSelectionController extends GetxController {
  void selectLanguage(String subTag, String name) async {
    await LocalStorage.saveLanguage(
      name: name,
      langSmall: subTag,
      langCap: subTag.toUpperCase(),
    );
    
    // After selection, go to Onboarding
    Get.offAllNamed(Routes.onboard);
  }
}

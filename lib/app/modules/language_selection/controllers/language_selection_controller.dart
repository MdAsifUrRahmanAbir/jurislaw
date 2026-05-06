import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';

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

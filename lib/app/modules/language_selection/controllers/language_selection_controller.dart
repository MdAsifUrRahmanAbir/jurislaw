import 'package:get/get.dart';
import 'package:ukil_chaai_client/app/core/services/local_storage_service.dart';
import 'package:ukil_chaai_client/app/routes/app_pages.dart';

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

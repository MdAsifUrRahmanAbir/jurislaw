import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userAvatar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() {
    userName.value = LocalStorage.getName().isNotEmpty
        ? LocalStorage.getName()
        : 'User';
    userEmail.value = LocalStorage.getEmail();
    userAvatar.value = LocalStorage.getImage() ?? '';
  }

  void goToEditProfile() => Get.toNamed(Routes.updateProfile);
  void goToSettings() => Get.toNamed(Routes.settings);

  Future<void> logout() async {
    await LocalStorage.signOut();
    Get.offAllNamed(Routes.login);
  }
}

import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';

class HomeController extends GetxController {
  final userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    userName.value = LocalStorage.getName().isNotEmpty
        ? LocalStorage.getName()
        : 'User';
  }

  // TODO: Add data fetching methods (ApiServices.get / FirebaseService) here
}

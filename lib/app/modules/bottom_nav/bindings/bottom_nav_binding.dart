import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

/// BottomNavBinding registers ALL controllers needed by the tab pages.
///
/// Why: BottomNavView uses IndexedStack — every tab widget is alive in the
/// tree at the same time, so each tab's controller must be registered BEFORE
/// the view builds. This is the Remitium pattern.
class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

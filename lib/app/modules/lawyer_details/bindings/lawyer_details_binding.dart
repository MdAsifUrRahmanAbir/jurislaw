import 'package:get/get.dart';
import '../controllers/lawyer_details_controller.dart';

class LawyerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LawyerDetailsController>(() => LawyerDetailsController());
  }
}

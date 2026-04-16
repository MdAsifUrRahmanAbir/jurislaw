import 'package:get/get.dart';
import '../controllers/intake_form_controller.dart';

class IntakeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntakeFormController>(() => IntakeFormController());
  }
}

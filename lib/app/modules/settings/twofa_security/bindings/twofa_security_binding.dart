import 'package:get/get.dart';
import '../controllers/twofa_security_controller.dart';

class TwofaSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwofaSecurityController>(() => TwofaSecurityController());
  }
}

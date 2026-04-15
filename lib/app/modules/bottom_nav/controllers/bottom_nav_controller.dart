import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) => currentIndex.value = index;
}

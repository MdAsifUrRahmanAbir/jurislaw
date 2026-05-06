import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';

class OnboardController extends GetxController {
  late PageController pageController;
  final currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'onboard_1_title'.tr,
      'subtitle': 'onboard_1_subtitle'.tr,
      'image': '⚖️',
    },
    {
      'title': 'onboard_2_title'.tr,
      'subtitle': 'onboard_2_subtitle'.tr,
      'image': '📅',
    },
    {
      'title': 'onboard_3_title'.tr,
      'subtitle': 'onboard_3_subtitle'.tr,
      'image': '💳',
    },
  ];

  int get totalPages => pages.length;
  bool get isLastPage => currentPage.value == totalPages - 1;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void skip() => completeOnboarding();

  Future<void> completeOnboarding() async {
    await LocalStorage.setOnboardDone(value: true);
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

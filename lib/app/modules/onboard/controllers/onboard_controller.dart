import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class OnboardController extends GetxController {
  late PageController pageController;
  final currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to My App',
      'subtitle':
          'The best place to manage your activities simply and efficiently.',
      'image': '🎯',
    },
    {
      'title': 'Stay Organized',
      'subtitle':
          'Track everything in one place and never miss an important task.',
      'image': '📋',
    },
    {
      'title': 'Get Started Today',
      'subtitle':
          'Join thousands of users already simplifying their daily lives.',
      'image': '🚀',
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

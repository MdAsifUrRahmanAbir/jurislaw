import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';

class OnboardController extends GetxController {
  late PageController pageController;
  final currentPage = 0.obs;

  List<Map<String, String>> get pagesData {
    final isBengali = Get.locale?.languageCode == 'bn';
    return [
      {
        'title1': isBengali ? 'আইনি সহায়তা' : 'Legal Help',
        'title2': isBengali ? 'এখন আপনার হাতে' : 'Now at Your Hand',
        'subtitle': isBengali
            ? 'যেকোনো সময়, যেকোনো স্থান থেকে অভিজ্ঞ ও যাচাইকৃত উকিল খুঁজুন এবং সহজেই আইনি সেবা গ্রহণ করুন।'
            : 'Find experienced and verified advocates anytime, anywhere, and receive legal services easily.',
      },
      {
        'title1': isBengali ? 'সহজেই খুঁজুন' : 'Easily Find',
        'title2': isBengali ? 'আপনার উকিল' : 'Your Advocate',
        'subtitle': isBengali
            ? 'বিশেষজ্ঞতা, অবস্থান বা প্রয়োজন অনুযায়ী উকিল খুঁজুন। প্রোফাইল, অভিজ্ঞতা ও রেটিং দেখে সঠিক সিদ্ধান্ত নিন।'
            : 'Find advocates by specialty, location, or needs. View profiles, experience, and ratings to make the right choice.',
      },
      {
        'title1': isBengali ? 'নিরাপদ ও দ্রুত' : 'Safe & Fast',
        'title2': isBengali ? 'আইনি পরামর্শ' : 'Legal Counsel',
        'subtitle': isBengali
            ? 'চ্যাট, কল বা অ্যাপয়েন্টমেন্টের মাধ্যমে সরাসরি উকিলের সাথে যোগাযোগ করুন এবং আপনার মামলার অগ্রগতি সহজেই অনুসরণ করুন।'
            : 'Connect directly with advocates via chat, call, or appointments, and track your case progress easily.',
      },
    ];
  }

  int get totalPages => pagesData.length;
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

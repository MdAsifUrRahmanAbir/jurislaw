import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntakeFormController extends GetxController {
  // Section 1: Categories
  final selectedCategories = <String>[].obs;
  final categories = [
    'Family Law / পারিবারিক আইন',
    'Divorce / বিবাহবিচ্ছেদ',
    'Child Custody / সন্তানের অভিভাবকত্ব',
    'Property / Land Dispute / জমি-সম্পত্তি বিরোধ',
    'Criminal Case / ফৌজদারি মামলা',
    'Business / Commercial Law',
    'Labour / Employment Issue',
    'Tax / VAT Issue',
    'Banking / Loan Dispute',
    'Cyber Crime / Digital Fraud',
    'Constitutional / Writ Matter',
    'Others / অন্যান্য'
  ];

  // Section 2: Location
  final selectedDivision = ''.obs;
  final selectedDistrict = ''.obs;
  final areaController = TextEditingController();

  final divisions = ['Dhaka', 'Chattogram', 'Sylhet', 'Rajshahi', 'Khulna', 'Barishal', 'Rangpur', 'Mymensingh'];
  final districts = ['Dhaka', 'Gazipur', 'Narayanganj', 'Uttara', 'Mirpur', 'Gulshan'];

  // Section 3: Issue Details
  final issueDescription = TextEditingController();

  // Section 4: Emergency
  final isEmergency = false.obs;

  // Section 5: Additional
  final selectedConsultationType = 'Video Call'.obs;
  final selectedLanguage = 'Bengali'.obs;
  final preferredGender = 'Any'.obs;
  final selectedBudget = '৳1000 – ৳3000'.obs;
  final uploadedFiles = <String>[].obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void submitForm() {
    if (selectedCategories.isEmpty || issueDescription.text.length < 10) {
      Get.snackbar('Alert', 'Please select at least one category and describe your issue details.');
      return;
    }
    
    Get.back();
    Get.snackbar(
      'Success', 
      'Your legal issue has been submitted. Our system is matching you with the best advocates.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

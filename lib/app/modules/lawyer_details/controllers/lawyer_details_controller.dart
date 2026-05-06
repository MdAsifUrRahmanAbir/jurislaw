import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/data/models/lawyer_model.dart';

class LawyerDetailsController extends GetxController {
  late Lawyer lawyer;
  
  final currentStep = 0.obs; // 0: Profile, 1: Form, 2: Preview, 3: Payment
  
  final selectedDate = DateTime.now().obs;
  final selectedTime = ''.obs;
  final consultationType = 'Video Call'.obs;
  final problemDescription = TextEditingController();
  final uploadedFileName = ''.obs;
  final selectedPaymentMethod = ''.obs;
  final isProcessingPayment = false.obs;
  
  final availableTimes = [
    '09:00 AM', '10:00 AM', '11:00 AM', 
    '02:00 PM', '03:00 PM', '04:00 PM'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    lawyer = Get.arguments as Lawyer;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void uploadDocument() {
    // Mock document upload
    uploadedFileName.value = "case_details.pdf";
  }

  void goToBooking() {
    currentStep.value = 1;
  }

  void goToPreview() {
    if (selectedTime.value.isEmpty) {
      Get.snackbar('Error', 'Please select a time slot');
      return;
    }
    currentStep.value = 2;
  }

  void goToPayment() {
    currentStep.value = 3;
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> finalizePayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return;
    }
    
    isProcessingPayment.value = true;
    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed('/bottom_nav'); // Go back to home
      Get.snackbar(
        'Payment Successful', 
        'Your consultation with ${lawyer.name} has been booked.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Payment failed. Please try again.');
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void processPayment(String method) {
    selectPaymentMethod(method);
  }

  void bookConsultation() {
    // This is now handled in steps
  }
}

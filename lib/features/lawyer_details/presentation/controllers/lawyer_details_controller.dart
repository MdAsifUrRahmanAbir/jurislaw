import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/lawyer_details_state.dart';

const availableConsultationTimes = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'];

class LawyerDetailsController extends Notifier<LawyerDetailsState> {
  late final TextEditingController problemDescriptionController;

  @override
  LawyerDetailsState build() {
    problemDescriptionController = TextEditingController();
    ref.onDispose(() => problemDescriptionController.dispose());
    return LawyerDetailsState(selectedDate: DateTime.now());
  }

  void selectDate(DateTime date) => state = state.copyWith(selectedDate: date);
  void selectTime(String time) => state = state.copyWith(selectedTime: time);
  void setConsultationType(String type) => state = state.copyWith(consultationType: type);

  /// Mock document upload — matches source, which never actually
  /// invokes a file picker either.
  void uploadDocument() => state = state.copyWith(uploadedFileName: 'case_details.pdf');

  void selectPaymentMethod(String method) => state = state.copyWith(selectedPaymentMethod: method);

  void goToStep(int step) => state = state.copyWith(currentStep: step);
  void goToBooking() => state = state.copyWith(currentStep: 1);

  bool goToPreview() {
    if (state.selectedTime.isEmpty) return false;
    state = state.copyWith(currentStep: 2);
    return true;
  }

  void goToPayment() => state = state.copyWith(currentStep: 3);

  /// TODO: no real payment gateway integrated — ported as-is from
  /// ukil-chaai, which also just simulates success with a delay.
  Future<bool> finalizePayment() async {
    if (state.selectedPaymentMethod.isEmpty) return false;
    state = state.copyWith(isProcessingPayment: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isProcessingPayment: false);
    return true;
  }
}

final lawyerDetailsControllerProvider =
    NotifierProvider.autoDispose<LawyerDetailsController, LawyerDetailsState>(LawyerDetailsController.new);

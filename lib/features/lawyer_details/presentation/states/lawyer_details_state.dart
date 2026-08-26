/// currentStep: 0 profile, 1 booking form, 2 preview, 3 payment
/// — mirrors ukil-chaai's LawyerDetailsController exactly.
class LawyerDetailsState {
  final int currentStep;
  final DateTime selectedDate;
  final String selectedTime;
  final String consultationType;
  final String uploadedFileName;
  final String selectedPaymentMethod;
  final bool isProcessingPayment;

  const LawyerDetailsState({
    this.currentStep = 0,
    required this.selectedDate,
    this.selectedTime = '',
    this.consultationType = 'Video Call',
    this.uploadedFileName = '',
    this.selectedPaymentMethod = '',
    this.isProcessingPayment = false,
  });

  LawyerDetailsState copyWith({
    int? currentStep,
    DateTime? selectedDate,
    String? selectedTime,
    String? consultationType,
    String? uploadedFileName,
    String? selectedPaymentMethod,
    bool? isProcessingPayment,
  }) {
    return LawyerDetailsState(
      currentStep: currentStep ?? this.currentStep,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      consultationType: consultationType ?? this.consultationType,
      uploadedFileName: uploadedFileName ?? this.uploadedFileName,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
    );
  }
}

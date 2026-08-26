class RegisterFormState {
  final String? division;
  final String? district;
  final String? upazila;
  final String? imagePath;
  final bool isSubmitting;
  final String? errorMessage;

  const RegisterFormState({
    this.division,
    this.district,
    this.upazila,
    this.imagePath,
    this.isSubmitting = false,
    this.errorMessage,
  });

  RegisterFormState copyWith({
    String? division,
    String? district,
    String? upazila,
    String? imagePath,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return RegisterFormState(
      division: division ?? this.division,
      district: district ?? this.district,
      upazila: upazila ?? this.upazila,
      imagePath: imagePath ?? this.imagePath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class RegisterFormState {
  final String? division;
  final String? district;
  final String? imagePath;
  final bool isSubmitting;
  final String? errorMessage;

  const RegisterFormState({
    this.division,
    this.district,
    this.imagePath,
    this.isSubmitting = false,
    this.errorMessage,
  });

  RegisterFormState copyWith({
    String? division,
    String? district,
    bool clearDistrict = false,
    String? imagePath,
    bool clearImage = false,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return RegisterFormState(
      division: division ?? this.division,
      district: clearDistrict ? district : (district ?? this.district),
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

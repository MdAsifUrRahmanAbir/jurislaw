class EditProfileState {
  final String? division;
  final String? district;
  final String? newPhotoPath;
  final bool isSubmitting;
  final String? errorMessage;

  const EditProfileState({
    this.division,
    this.district,
    this.newPhotoPath,
    this.isSubmitting = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    String? division,
    String? district,
    bool clearDistrict = false,
    String? newPhotoPath,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return EditProfileState(
      division: division ?? this.division,
      district: clearDistrict ? district : (district ?? this.district),
      newPhotoPath: newPhotoPath ?? this.newPhotoPath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

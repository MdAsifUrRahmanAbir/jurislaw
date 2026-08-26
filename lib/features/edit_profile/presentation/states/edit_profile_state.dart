class EditProfileState {
  final bool isSubmitting;
  final String? errorMessage;

  const EditProfileState({this.isSubmitting = false, this.errorMessage});

  EditProfileState copyWith({bool? isSubmitting, String? errorMessage}) {
    return EditProfileState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

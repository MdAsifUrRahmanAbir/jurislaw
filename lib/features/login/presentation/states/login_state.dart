class LoginState {
  final bool isSubmitting;
  final String? errorMessage;

  const LoginState({this.isSubmitting = false, this.errorMessage});

  LoginState copyWith({bool? isSubmitting, String? errorMessage}) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

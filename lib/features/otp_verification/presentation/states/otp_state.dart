class OtpState {
  final bool isVerifying;
  final bool isResending;
  final String? errorMessage;

  const OtpState({this.isVerifying = false, this.isResending = false, this.errorMessage});

  OtpState copyWith({bool? isVerifying, bool? isResending, String? errorMessage}) {
    return OtpState(
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      errorMessage: errorMessage,
    );
  }
}

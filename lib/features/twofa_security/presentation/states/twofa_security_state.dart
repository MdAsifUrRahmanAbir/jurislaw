class TwofaSecurityState {
  final bool isTwoFaEnabled;
  final bool isVerifying;

  const TwofaSecurityState({this.isTwoFaEnabled = false, this.isVerifying = false});

  TwofaSecurityState copyWith({bool? isTwoFaEnabled, bool? isVerifying}) {
    return TwofaSecurityState(
      isTwoFaEnabled: isTwoFaEnabled ?? this.isTwoFaEnabled,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }
}

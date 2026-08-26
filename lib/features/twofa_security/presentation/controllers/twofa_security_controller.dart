import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/twofa_security_state.dart';

/// Ports ukil-chaai's TwofaSecurityController as-is: the source has no
/// real 2FA backend at all (`toggleTwoFa`/`verifyOtp` are both TODO'd,
/// `verifyOtp` is a `Future.delayed` fake) — this stays UI-only to match.
class TwofaSecurityController extends Notifier<TwofaSecurityState> {
  @override
  TwofaSecurityState build() => const TwofaSecurityState();

  void toggleTwoFa(bool value) {
    // TODO: call backend to enable/disable 2FA once one exists.
    state = state.copyWith(isTwoFaEnabled: value);
  }

  /// Returns true on "success" (source treats any complete 6-digit code
  /// as valid — there's no real verification yet).
  Future<bool> verifyOtp(String otp) async {
    if (otp.length < 6) return false;

    state = state.copyWith(isVerifying: true);
    // TODO: verify OTP via the real API once one exists.
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isVerifying: false);
    return true;
  }
}

final twofaSecurityControllerProvider =
    NotifierProvider.autoDispose<TwofaSecurityController, TwofaSecurityState>(TwofaSecurityController.new);

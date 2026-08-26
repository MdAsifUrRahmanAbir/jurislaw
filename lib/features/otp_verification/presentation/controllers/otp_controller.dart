import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/app_user.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../login/data/repositories/login_repository.dart';
import '../../data/repositories/otp_repository.dart';
import '../states/otp_state.dart';

/// Result of a successful [OtpController.verify] call — tells the screen
/// which screen to route to next, matching ukil-chaai's
/// `isProfileComplete ? bottomNav : register` branch.
enum OtpVerifyOutcome { profileComplete, profileIncomplete }

class OtpController extends Notifier<OtpState> {
  @override
  OtpState build() => const OtpState();

  Future<OtpVerifyOutcome?> verify({required String phone, required String otp}) async {
    state = state.copyWith(isVerifying: true, errorMessage: null);
    try {
      final result = await ref.read(otpRepositoryProvider).verifyOtp(phone: phone, otp: otp);
      final AppUser user = result.user.toAppUser().copyWith(isProfileComplete: result.isProfileComplete);

      await ref.read(authSessionControllerProvider.notifier).onLoginSuccess(
            accessToken: result.token,
            user: user,
          );

      state = state.copyWith(isVerifying: false);
      return user.isProfileComplete ? OtpVerifyOutcome.profileComplete : OtpVerifyOutcome.profileIncomplete;
    } catch (e) {
      state = state.copyWith(isVerifying: false, errorMessage: getErrorMessage(e));
      return null;
    }
  }

  Future<bool> resend(String phone) async {
    state = state.copyWith(isResending: true, errorMessage: null);
    try {
      await ref.read(loginRepositoryProvider).requestOtp(phone);
      state = state.copyWith(isResending: false);
      return true;
    } catch (e) {
      state = state.copyWith(isResending: false, errorMessage: getErrorMessage(e));
      return false;
    }
  }
}

final otpControllerProvider = NotifierProvider.autoDispose<OtpController, OtpState>(OtpController.new);

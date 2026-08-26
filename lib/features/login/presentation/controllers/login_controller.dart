import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../data/repositories/login_repository.dart';
import '../states/login_state.dart';

class LoginController extends Notifier<LoginState> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController phoneController;

  @override
  LoginState build() {
    phoneController = TextEditingController();
    ref.onDispose(() => phoneController.dispose());
    return const LoginState();
  }

  LoginRepository get _repository => ref.read(loginRepositoryProvider);

  String? validatePhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.phoneRequired;
    if (value.trim().length < 10) return l10n.phoneInvalid;
    return null;
  }

  /// Validates the form, requests an OTP, and returns the phone number on
  /// success (so the caller can navigate to OTP verification with it) or
  /// null on validation/API failure — check [state.errorMessage] for why.
  Future<String?> sendOtp() async {
    if (!(formKey.currentState?.validate() ?? false)) return null;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final phone = phoneController.text.trim();
    try {
      await _repository.requestOtp(phone);
      state = state.copyWith(isSubmitting: false);
      return phone;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: getErrorMessage(e));
      return null;
    }
  }
}

final loginControllerProvider = NotifierProvider.autoDispose<LoginController, LoginState>(LoginController.new);

import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';

/// Informational note: there's no separate sign-up — verifying a phone
/// number that isn't registered yet creates the account automatically
/// (see [LoginController.sendOtp]/otp_verification's routing).
class RegisterPrompt extends StatelessWidget {
  const RegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.dontHaveAccount,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary),
    );
  }
}

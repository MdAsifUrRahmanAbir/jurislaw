import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';

/// Heading + subtitle shown at the top of the phone sign-in card.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.signIn,
          style: TextStyle(
            fontSize: AppSizes.fontXl,
            fontWeight: FontWeight.w700,
            color: context.appColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          l10n.signInPhoneSubtitle,
          style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary),
        ),
      ],
    );
  }
}

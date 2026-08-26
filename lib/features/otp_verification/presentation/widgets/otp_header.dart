import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_icon_badge.dart';

/// Icon badge + "Verify Your Number" heading + subtitle (with the phone
/// number interpolated in) at the top of the OTP verification screen.
class OtpHeader extends StatelessWidget {
  final String phone;

  const OtpHeader({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const CustomIconBadge(icon: Icons.mark_email_read_outlined),
        const SizedBox(height: AppSizes.lg),
        Text(
          l10n.otpTitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          l10n.otpSubtitle(phone),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: AppSizes.fontMd, color: context.appColors.textSecondary),
        ),
      ],
    );
  }
}

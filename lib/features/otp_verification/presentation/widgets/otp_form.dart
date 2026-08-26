import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/otp_input_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/link_button.dart';

/// OTP boxes + resend countdown + Verify button + "Didn't receive code?"
/// prompt — bundled together because the countdown is shared state
/// between the "Resend OTP in mm:ss" line and the bottom resend link.
///
/// Purely presentational/UI-state only (digits typed, seconds left).
/// The real verify/resend calls are supplied by the caller via
/// [onVerify] / [onResend].
class OtpForm extends StatefulWidget {
  final bool loading;
  final bool resending;
  final int resendSeconds;
  final int otpLength;
  final ValueChanged<String> onVerify;
  final VoidCallback? onResend;

  const OtpForm({
    super.key,
    required this.onVerify,
    this.onResend,
    this.loading = false,
    this.resending = false,
    this.resendSeconds = 60,
    this.otpLength = 6,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String _code = '';
  Timer? _timer;
  late int _secondsLeft;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.resendSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _handleResend() {
    if (_secondsLeft > 0) return;
    widget.onResend?.call();
    setState(() => _secondsLeft = widget.resendSeconds);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canResend = _secondsLeft <= 0;

    return Column(
      children: [
        OtpInputField(
          length: widget.otpLength,
          onChanged: (value) => setState(() => _code = value),
        ),
        const SizedBox(height: AppSizes.lg),
        if (!canResend)
          Text(
            l10n.resendOtpIn(_secondsLeft),
            style: TextStyle(fontSize: AppSizes.fontMd, color: context.appColors.textSecondary),
          ),
        const SizedBox(height: AppSizes.xl),
        PrimaryButton(
          label: l10n.verifyAndLogin,
          loading: widget.loading,
          onPressed: _code.length == widget.otpLength ? () => widget.onVerify(_code) : null,
        ),
        const SizedBox(height: AppSizes.lg),
        LinkButton(
          label: widget.resending ? '${l10n.resendOtp}…' : l10n.resendOtp,
          fontSize: AppSizes.fontSm,
          color: canResend ? AppColors.primary : context.appColors.textHint,
          onPressed: canResend && !widget.resending ? _handleResend : null,
        ),
      ],
    );
  }
}

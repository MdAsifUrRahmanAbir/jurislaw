import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../routes/route_names.dart';
import '../controllers/otp_controller.dart';
import '../widgets/otp_header.dart';
import '../widgets/otp_form.dart';

class OtpVerificationTabView extends ConsumerWidget {
  final String phone;

  const OtpVerificationTabView({super.key, required this.phone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpControllerProvider);
    final controller = ref.read(otpControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(otpControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: l10n.otpTitle),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSizes.md),
                      OtpHeader(phone: phone),
                      const SizedBox(height: AppSizes.xl),
                      OtpForm(
                        loading: state.isVerifying,
                        resending: state.isResending,
                        onVerify: (code) async {
                          final outcome = await controller.verify(phone: phone, otp: code);
                          if (!context.mounted || outcome == null) return;
                          context.go(
                            outcome == OtpVerifyOutcome.profileComplete ? RouteNames.mainShell : RouteNames.register,
                          );
                        },
                        onResend: () => controller.resend(phone),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/otp_input_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/primary_switch.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/twofa_security_controller.dart';

class TwofaSecurityScreen extends ConsumerWidget {
  const TwofaSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: const _TwofaSecurityBody(maxWidth: double.infinity),
        tablet: const _TwofaSecurityBody(maxWidth: 480),
      ),
    );
  }
}

class _TwofaSecurityBody extends ConsumerStatefulWidget {
  final double maxWidth;
  const _TwofaSecurityBody({required this.maxWidth});

  @override
  ConsumerState<_TwofaSecurityBody> createState() => _TwofaSecurityBodyState();
}

class _TwofaSecurityBodyState extends ConsumerState<_TwofaSecurityBody> {
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(twofaSecurityControllerProvider);
    final controller = ref.read(twofaSecurityControllerProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(title: 'Two-Factor Authentication'),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimarySwitch(
                          value: state.isTwoFaEnabled,
                          label: 'Enable Two-Factor Authentication',
                          subtitle: 'Require a one-time code at login for extra security',
                          onChanged: controller.toggleTwoFa,
                        ),
                        if (state.isTwoFaEnabled) ...[
                          const SizedBox(height: AppSizes.lg),
                          const Text('Enter the 6-digit code to confirm'),
                          const SizedBox(height: AppSizes.md),
                          Center(
                            child: OtpInputField(length: 6, onChanged: (v) => setState(() => _otp = v)),
                          ),
                          const SizedBox(height: AppSizes.lg),
                          PrimaryButton(
                            label: 'Verify',
                            loading: state.isVerifying,
                            onPressed: _otp.length == 6
                                ? () async {
                                    final success = await controller.verifyOtp(_otp);
                                    if (!context.mounted) return;
                                    if (success) {
                                      CustomSnackbar.show(context, '2FA security updated');
                                      context.pop();
                                    } else {
                                      CustomSnackbar.show(context, 'Please enter the full 6-digit code', error: true);
                                    }
                                  }
                                : null,
                          ),
                        ],
                      ],
                    ),
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

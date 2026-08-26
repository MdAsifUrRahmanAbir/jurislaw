import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/primary_input_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/login_controller.dart';

/// Phone-number field + "Send OTP" button. On success, hands the caller
/// the verified phone number so it can navigate to OTP verification.
class LoginForm extends ConsumerWidget {
  final void Function(String phone) onOtpSent;

  const LoginForm({super.key, required this.onOtpSent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(loginControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryInputField(
            label: l10n.phoneNumber,
            hint: l10n.phoneNumberHint,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_android_rounded),
            validator: (value) => controller.validatePhone(value, l10n),
          ),
          const SizedBox(height: AppSizes.lg),
          PrimaryButton(
            label: l10n.sendOtp,
            loading: state.isSubmitting,
            onPressed: () async {
              final phone = await controller.sendOtp();
              if (phone != null) onOtpSent(phone);
            },
          ),
        ],
      ),
    );
  }
}

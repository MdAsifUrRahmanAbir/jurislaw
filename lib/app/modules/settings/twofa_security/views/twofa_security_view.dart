import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../widgets/pin_code_field_widget.dart';
import '../../../../widgets/primary_appbar_widget.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/toggle_switch_widget.dart';
import '../controllers/twofa_security_controller.dart';

class TwofaSecurityView extends GetView<TwofaSecurityController> {
  const TwofaSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinCtrl = TextEditingController();
    return Scaffold(
      appBar: const PrimaryAppBar(title: AppStrings.twoFaSecurity),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.gapMid),

            // Toggle
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMid),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardBackground
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => ToggleSwitchWidget(
                  icon: Icons.security_rounded,
                  label: '2-Factor Authentication',
                  subtitle: 'Add extra layer of security to your account',
                  value: controller.isTwoFaEnabled.value,
                  onChanged: controller.toggleTwoFa,
                  activeColor: AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapXLarge),

            // OTP section (visible when enabled)
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.isTwoFaEnabled.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        key: const ValueKey('otp_section'),
                        children: [
                          Text(
                            'Enter Verification Code',
                            style: TextStyle(
                              fontSize: AppSizes.fontMedium,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.gapXSmall),
                          Text(
                            'Enter the 6-digit code from your authenticator app.',
                            style: const TextStyle(
                              fontSize: AppSizes.fontSmall,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.gapLarge),
                          PinCodeFieldWidget(
                            controller: pinCtrl,
                            length: 6,
                            onChanged: controller.onOtpChanged,
                          ),
                          const SizedBox(height: AppSizes.gapXLarge),
                          Obx(
                            () => PrimaryButton(
                              text: 'Verify & Enable 2FA',
                              isLoading: controller.isLoading.value,
                              onPressed: controller.verifyOtp,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

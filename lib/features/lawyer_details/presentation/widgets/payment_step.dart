import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../home/data/models/lawyer_model.dart';
import '../controllers/lawyer_details_controller.dart';
import 'lawyer_details_widgets.dart';

/// Payment is simulated — see [LawyerDetailsController.finalizePayment];
/// no real gateway is wired, matching ukil-chaai's source behavior.
class PaymentStep extends ConsumerWidget {
  final Lawyer lawyer;
  final VoidCallback onPaid;

  const PaymentStep({super.key, required this.lawyer, required this.onPaid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lawyerDetailsControllerProvider);
    final controller = ref.read(lawyerDetailsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select a payment method to continue', style: TextStyle(color: context.appColors.textSecondary)),
          const SizedBox(height: AppSizes.lg),
          PaymentTile(
            icon: Icons.account_balance_wallet_rounded,
            label: 'bKash',
            isSelected: state.selectedPaymentMethod == 'bKash',
            onTap: () => controller.selectPaymentMethod('bKash'),
          ),
          PaymentTile(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Nagad',
            isSelected: state.selectedPaymentMethod == 'Nagad',
            onTap: () => controller.selectPaymentMethod('Nagad'),
          ),
          PaymentTile(
            icon: Icons.rocket_launch_outlined,
            label: 'Rocket',
            isSelected: state.selectedPaymentMethod == 'Rocket',
            onTap: () => controller.selectPaymentMethod('Rocket'),
          ),
          PaymentTile(
            icon: Icons.credit_card_rounded,
            label: 'Debit / Credit Card',
            isSelected: state.selectedPaymentMethod == 'Card',
            onTap: () => controller.selectPaymentMethod('Card'),
          ),
          const SizedBox(height: AppSizes.xl),
          PrimaryButton(
            label: state.selectedPaymentMethod.isEmpty
                ? 'Select a method'
                : 'Pay ৳${lawyer.fee.toStringAsFixed(0)} with ${state.selectedPaymentMethod}',
            loading: state.isProcessingPayment,
            onPressed: state.selectedPaymentMethod.isEmpty
                ? null
                : () async {
                    final success = await controller.finalizePayment();
                    if (success) onPaid();
                  },
          ),
          const SizedBox(height: AppSizes.md),
          Center(
            child: Text(
              'Payments are processed through a secure gateway',
              style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

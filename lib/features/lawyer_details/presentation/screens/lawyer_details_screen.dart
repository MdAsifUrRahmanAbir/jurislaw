import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_step_indicator.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../routes/route_names.dart';
import '../../../home/data/models/lawyer_model.dart';
import '../controllers/lawyer_details_controller.dart';
import '../widgets/booking_form_step.dart';
import '../widgets/booking_preview_step.dart';
import '../widgets/lawyer_profile_step.dart';
import '../widgets/payment_step.dart';

const _stepTitles = ['Advocate Profile', 'Book Appointment', 'Booking Preview', 'Choose Payment'];

class LawyerDetailsScreen extends ConsumerWidget {
  final Lawyer lawyer;

  const LawyerDetailsScreen({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(lawyerDetailsControllerProvider).currentStep;
    final controller = ref.read(lawyerDetailsControllerProvider.notifier);

    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goToStep(step - 1);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: _stepTitles[step],
          onBackTap: () => step == 0 ? Navigator.of(context).maybePop() : controller.goToStep(step - 1),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (step > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                      child: CustomStepIndicator(stepCount: 3, currentStep: step - 1),
                    ),
                  switch (step) {
                    0 => LawyerProfileStep(lawyer: lawyer),
                    1 => BookingFormStep(lawyer: lawyer),
                    2 => BookingPreviewStep(lawyer: lawyer),
                    _ => PaymentStep(
                        lawyer: lawyer,
                        onPaid: () {
                          context.go(RouteNames.mainShell);
                          CustomSnackbar.show(context, 'Your consultation with ${lawyer.name} has been booked.');
                        },
                      ),
                  },
                  const SizedBox(height: AppSizes.xxl + AppSizes.xl),
                ],
              ),
            ),
            if (step == 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: context.appColors.surface,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: AppSizes.md, offset: const Offset(0, -4))],
                  ),
                  child: SafeArea(
                    top: false,
                    child: PrimaryButton(label: 'Book Consultation Now', onPressed: controller.goToBooking),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

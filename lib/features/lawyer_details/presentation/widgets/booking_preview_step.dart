import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../home/data/models/lawyer_model.dart';
import '../controllers/lawyer_details_controller.dart';

class BookingPreviewStep extends ConsumerWidget {
  final Lawyer lawyer;

  const BookingPreviewStep({super.key, required this.lawyer});

  Widget _item(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: context.appColors.textHint),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: context.appColors.textSecondary, fontSize: AppSizes.fontXs, fontWeight: FontWeight.w500)),
                const SizedBox(height: AppSizes.xs / 2),
                Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.fontSm, color: context.appColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lawyerDetailsControllerProvider);
    final controller = ref.read(lawyerDetailsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: AppSizes.sm, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSizes.sm),
                    const Text('Order Summary', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                      onPressed: () => controller.goToStep(1),
                    ),
                  ],
                ),
                const Divider(height: AppSizes.xl),
                _item(context, icon: Icons.person_outline_rounded, label: 'Lawyer', value: lawyer.name),
                _item(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: 'Date & Time',
                  value: '${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year} at ${state.selectedTime}',
                ),
                _item(context, icon: Icons.videocam_outlined, label: 'Consultation Type', value: state.consultationType),
                _item(
                  context,
                  icon: Icons.info_outline_rounded,
                  label: 'Subject',
                  value: controller.problemDescriptionController.text.isEmpty ? 'Not specified' : controller.problemDescriptionController.text,
                ),
                _item(
                  context,
                  icon: Icons.attach_file_rounded,
                  label: 'Attached File',
                  value: state.uploadedFileName.isEmpty ? 'No file' : state.uploadedFileName,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payable Amount', style: TextStyle(color: context.appColors.textSecondary, fontSize: AppSizes.fontSm)),
                    Text('Incl. all taxes', style: TextStyle(color: context.appColors.textHint, fontSize: AppSizes.fontXs)),
                  ],
                ),
                Text('৳ ${lawyer.fee.toStringAsFixed(0)}', style: const TextStyle(fontSize: AppSizes.fontXxl, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          PrimaryButton(label: 'Confirm & Proceed to Pay', onPressed: controller.goToPayment),
          const SizedBox(height: AppSizes.sm),
          Center(
            child: TextButton(
              onPressed: () => controller.goToStep(1),
              child: const Text('Back to Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}

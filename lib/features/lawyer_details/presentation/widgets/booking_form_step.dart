import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../home/data/models/lawyer_model.dart';
import '../controllers/lawyer_details_controller.dart';
import 'lawyer_details_widgets.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class BookingFormStep extends ConsumerWidget {
  final Lawyer lawyer;

  const BookingFormStep({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lawyerDetailsControllerProvider);
    final controller = ref.read(lawyerDetailsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Date', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          const SizedBox(height: AppSizes.sm + AppSizes.xs),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = state.selectedDate.day == date.day && state.selectedDate.month == date.month;
                return GestureDetector(
                  onTap: () => controller.selectDate(date),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: AppSizes.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : context.appColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdayLabels[date.weekday - 1],
                          style: TextStyle(color: isSelected ? AppColors.textWhite : context.appColors.textSecondary, fontSize: AppSizes.fontXs),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(color: isSelected ? AppColors.textWhite : context.appColors.textPrimary, fontWeight: FontWeight.w700, fontSize: AppSizes.fontMd),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Available Slots', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            children: [
              for (final time in availableConsultationTimes)
                ChoiceChip(
                  label: Text(time),
                  selected: state.selectedTime == time,
                  onSelected: (_) => controller.selectTime(time),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: state.selectedTime == time ? AppColors.textWhite : context.appColors.textPrimary),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Consultation Type', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              ConsultationTypeOption(
                icon: Icons.videocam_rounded,
                label: 'Video Call',
                isSelected: state.consultationType == 'Video Call',
                onTap: () => controller.setConsultationType('Video Call'),
              ),
              const SizedBox(width: AppSizes.sm),
              ConsultationTypeOption(
                icon: Icons.phone_rounded,
                label: 'Audio Call',
                isSelected: state.consultationType == 'Audio Call',
                onTap: () => controller.setConsultationType('Audio Call'),
              ),
              const SizedBox(width: AppSizes.sm),
              ConsultationTypeOption(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                isSelected: state.consultationType == 'Chat',
                onTap: () => controller.setConsultationType('Chat'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Problem Description', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          const SizedBox(height: AppSizes.sm),
          TextField(
            controller: controller.problemDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Briefly describe your legal concern...',
              filled: true,
              fillColor: context.appColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Supporting Documents', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary)),
          const SizedBox(height: AppSizes.sm),
          GestureDetector(
            onTap: controller.uploadDocument,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                color: AppColors.divider,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    state.uploadedFileName.isEmpty ? 'Upload case file' : state.uploadedFileName,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Consultation Fee', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('৳ ${lawyer.fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: AppSizes.fontLg, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          PrimaryButton(
            label: 'Continue to Preview',
            onPressed: () {
              if (!controller.goToPreview()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a time slot')));
              }
            },
          ),
        ],
      ),
    );
  }
}

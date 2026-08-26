import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../controllers/lawyer_list_controller.dart';

Future<void> showLawyerFilterSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
    builder: (sheetContext) => const _LawyerFilterSheetContent(),
  );
}

class _LawyerFilterSheetContent extends ConsumerWidget {
  const _LawyerFilterSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(lawyerFilterControllerProvider);
    final controller = ref.read(lawyerFilterControllerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Advanced Filters', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700)),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Text('Practice Area', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                children: [
                  for (final area in lawyerAreas)
                    ChoiceChip(
                      label: Text(area),
                      selected: filter.area == area,
                      onSelected: (_) => controller.setArea(area),
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(color: filter.area == area ? AppColors.primary : null),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                children: [
                  for (final location in lawyerLocations)
                    ChoiceChip(
                      label: Text(location),
                      selected: filter.location == location,
                      onSelected: (_) => controller.setLocation(location),
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(color: filter.location == location ? AppColors.primary : null),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Experience: ${filter.minExperience}+ years', style: const TextStyle(fontWeight: FontWeight.w700)),
              Slider(
                value: filter.minExperience.toDouble(),
                min: 0,
                max: 20,
                divisions: 4,
                activeColor: AppColors.primary,
                onChanged: (value) => controller.setMinExperience(value.toInt()),
              ),
              Text('Max Fee: ৳${filter.maxFee.toInt()}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Slider(
                value: filter.maxFee,
                min: 500,
                max: 10000,
                divisions: 19,
                activeColor: AppColors.primary,
                onChanged: (value) => controller.setMaxFee(value),
              ),
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(label: 'Apply Filters', onPressed: () => Navigator.of(context).pop()),
              const SizedBox(height: AppSizes.sm),
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset All', style: TextStyle(color: AppColors.error)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

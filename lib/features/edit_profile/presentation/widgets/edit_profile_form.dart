import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/primary_input_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileForm extends ConsumerWidget {
  final bool showSaveButton;
  final VoidCallback? onSaved;

  const EditProfileForm({super.key, this.showSaveButton = true, this.onSaved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editProfileControllerProvider.notifier);
    final state = ref.watch(editProfileControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(editProfileControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    return Form(
      key: controller.formKey,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryInputField(
              label: l10n.fullName,
              controller: controller.nameController,
              validator: (value) => controller.validateName(value, l10n),
            ),
            const SizedBox(height: AppSizes.md),
            PrimaryInputField(
              label: l10n.emailAddress,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => controller.validateEmail(value, l10n),
            ),
            const SizedBox(height: AppSizes.md),
            PrimaryInputField(
              label: l10n.phoneNumber,
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              enabled: false,
            ),
            const SizedBox(height: AppSizes.md),
            PrimaryInputField(
              label: 'Location',
              controller: controller.locationController,
            ),
            const SizedBox(height: AppSizes.md),
            PrimaryInputField(
              label: 'Bio',
              controller: controller.bioController,
              maxLines: 4,
            ),
            if (showSaveButton) ...[
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(
                label: l10n.save,
                loading: state.isSubmitting,
                onPressed: () async {
                  final success = await controller.submit();
                  if (success) onSaved?.call();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

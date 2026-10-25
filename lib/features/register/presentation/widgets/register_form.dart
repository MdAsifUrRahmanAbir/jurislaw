import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/avatar_photo_picker.dart';
import '../../../../core/widgets/common/bd_address_fields.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/primary_input_field.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/image_source_sheet.dart';
import '../controllers/register_controller.dart';

class RegisterForm extends ConsumerWidget {
  final void Function() onComplete;

  const RegisterForm({super.key, required this.onComplete});

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(registerControllerProvider.notifier);
    final hasPhoto = ref.read(registerControllerProvider).imagePath != null;
    final source = await showImageSourceSheet(context, onRemove: hasPhoto ? controller.removeImage : null);
    if (source != null) await controller.pickImage(source);
  }

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text,
        style: TextStyle(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: context.appColors.textPrimary,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(registerControllerProvider.notifier);
    final state = ref.watch(registerControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(registerControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: state.imagePath == null
                ? AvatarPhotoPicker(
                    actionLabel: 'Add profile photo (optional)',
                    onTap: () => _pickPhoto(context, ref),
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickPhoto(context, ref),
                        child: ClipOval(
                          child: Image.file(
                            File(state.imagePath!),
                            width: AppSizes.xxl * 2,
                            height: AppSizes.xxl * 2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      TextButton(onPressed: () => _pickPhoto(context, ref), child: Text(l10n.changePhoto)),
                    ],
                  ),
          ),
          const SizedBox(height: AppSizes.lg),
          PrimaryInputField(
            label: '${l10n.fullName} *',
            hint: l10n.fullNameHint,
            controller: controller.nameController,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (value) => controller.validateName(value, l10n),
          ),
          const SizedBox(height: AppSizes.md),
          PrimaryInputField(
            label: '${l10n.emailAddress} *',
            hint: l10n.emailHint,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            validator: (value) => controller.validateEmail(value, l10n),
          ),
          const SizedBox(height: AppSizes.lg),
          _sectionLabel(context, l10n.addressInformation),
          const SizedBox(height: AppSizes.md),
          BdAddressFields(
            division: state.division,
            district: state.district,
            upazilaController: controller.upazilaController,
            villageController: controller.villageController,
            onDivisionChanged: controller.setDivision,
            onDistrictChanged: controller.setDistrict,
          ),
          const SizedBox(height: AppSizes.lg),
          PrimaryButton(
            label: 'Save Profile & Continue',
            loading: state.isSubmitting,
            onPressed: () async {
              final success = await controller.submit(l10n);
              if (success) onComplete();
            },
          ),
        ],
      ),
    );
  }
}

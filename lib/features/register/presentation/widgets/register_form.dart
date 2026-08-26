import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/avatar_photo_picker.dart';
import '../../../../core/widgets/common/dropdown_field.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/primary_input_field.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/register_controller.dart';

class RegisterForm extends ConsumerWidget {
  final void Function() onComplete;

  const RegisterForm({super.key, required this.onComplete});

  Future<void> _showImageSourceSheet(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(registerControllerProvider.notifier);
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.md),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }

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
                    actionLabel: l10n.changePhoto,
                    onTap: () => _showImageSourceSheet(context, ref),
                  )
                : GestureDetector(
                    onTap: () => _showImageSourceSheet(context, ref),
                    child: ClipOval(
                      child: Image.file(
                        File(state.imagePath!),
                        width: AppSizes.xxl * 2,
                        height: AppSizes.xxl * 2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: AppSizes.lg),
          PrimaryInputField(
            label: l10n.fullName,
            hint: l10n.fullNameHint,
            controller: controller.nameController,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (value) => controller.validateName(value, l10n),
          ),
          const SizedBox(height: AppSizes.md),
          PrimaryInputField(
            label: l10n.emailAddress,
            hint: l10n.emailHint,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            validator: (value) => controller.validateEmail(value, l10n),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            l10n.addressInformation,
            style: TextStyle(
              fontSize: AppSizes.fontSm,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          DropdownField<String>(
            label: l10n.division,
            hint: l10n.selectDivision,
            value: state.division,
            items: [for (final d in RegisterAddressData.divisions) DropdownMenuItem(value: d, child: Text(d))],
            onChanged: controller.setDivision,
            validator: (value) => controller.validateDivision(value, l10n),
          ),
          const SizedBox(height: AppSizes.md),
          DropdownField<String>(
            label: l10n.district,
            hint: l10n.selectDistrict,
            value: state.district,
            items: [for (final d in RegisterAddressData.districts) DropdownMenuItem(value: d, child: Text(d))],
            onChanged: controller.setDistrict,
            validator: (value) => controller.validateDistrict(value, l10n),
          ),
          const SizedBox(height: AppSizes.md),
          DropdownField<String>(
            label: l10n.upazila,
            hint: l10n.selectUpazila,
            value: state.upazila,
            items: [for (final u in RegisterAddressData.upazilas) DropdownMenuItem(value: u, child: Text(u))],
            onChanged: controller.setUpazila,
          ),
          const SizedBox(height: AppSizes.md),
          PrimaryInputField(
            label: l10n.villageMohalla,
            hint: l10n.villageMohallaHint,
            controller: controller.villageController,
          ),
          const SizedBox(height: AppSizes.lg),
          PrimaryButton(
            label: l10n.completeProfile,
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

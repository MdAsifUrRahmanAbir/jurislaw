import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/avatar_photo_picker.dart';
import '../../../../core/widgets/utility/image_source_sheet.dart';
import '../controllers/edit_profile_controller.dart';

/// Centered avatar + "Change Profile Photo" link at the top of the
/// edit-profile form. Shows the newly picked file until it is saved.
class EditProfilePhotoSection extends ConsumerWidget {
  final String? avatarUrl;
  final String? name;

  const EditProfilePhotoSection({
    super.key,
    this.avatarUrl,
    this.name,
  });

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final source = await showImageSourceSheet(context);
    if (source != null) await ref.read(editProfileControllerProvider.notifier).pickPhoto(source);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newPhoto = ref.watch(editProfileControllerProvider.select((s) => s.newPhotoPath));
    final actionLabel = AppLocalizations.of(context)!.changePhoto;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
      child: Center(
        child: newPhoto == null
            ? AvatarPhotoPicker(
                imageUrl: avatarUrl,
                label: name,
                actionLabel: actionLabel,
                onTap: () => _pick(context, ref),
              )
            : GestureDetector(
                onTap: () => _pick(context, ref),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.file(
                        File(newPhoto),
                        width: (AppSizes.xxl + AppSizes.md) * 2,
                        height: (AppSizes.xxl + AppSizes.md) * 2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      actionLabel,
                      style: const TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

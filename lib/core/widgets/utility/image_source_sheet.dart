import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Camera / Gallery (and optional Remove) picker sheet. Returns the chosen
/// [ImageSource], or null when dismissed. [onRemove] adds a "Remove photo" row.
Future<ImageSource?> showImageSourceSheet(BuildContext context, {VoidCallback? onRemove}) {
  return showModalBottomSheet<ImageSource>(
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
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded),
            title: const Text('Gallery'),
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
          ),
          if (onRemove != null)
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              title: const Text('Remove photo', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.of(sheetContext).pop();
                onRemove();
              },
            ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    ),
  );
}

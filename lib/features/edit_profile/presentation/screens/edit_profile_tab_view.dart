import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../controllers/edit_profile_controller.dart';
import '../widgets/edit_profile_app_bar.dart';
import '../widgets/edit_profile_photo_section.dart';
import '../widgets/edit_profile_form.dart';

/// Same content as [EditProfileMobileView], centered in a
/// fixed-width column for wider (tablet/web) viewports.
class EditProfileTabView extends ConsumerWidget {
  const EditProfileTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(editProfileControllerProvider.notifier);
    final user = ref.watch(authSessionControllerProvider).user;

    void handleSaved() {
      CustomSnackbar.show(context, 'Profile updated successfully');
      context.pop();
    }

    return Scaffold(
      appBar: EditProfileAppBar(
        onDoneTap: () async {
          if (await controller.submit()) handleSaved();
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              children: [
                EditProfilePhotoSection(name: user?.name, avatarUrl: user?.profilePhoto),
                EditProfileForm(onSaved: handleSaved),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

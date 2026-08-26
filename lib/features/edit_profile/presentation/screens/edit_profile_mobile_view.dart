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

class EditProfileMobileView extends ConsumerWidget {
  const EditProfileMobileView({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            EditProfilePhotoSection(name: user?.name, avatarUrl: user?.profilePhoto),
            EditProfileForm(onSaved: handleSaved),
          ],
        ),
      ),
    );
  }
}

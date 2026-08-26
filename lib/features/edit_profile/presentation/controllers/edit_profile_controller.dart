import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../states/edit_profile_state.dart';

/// Mirrors ukil-chaai's UpdateProfileController: phone/bio/location fields
/// exist in the UI but only name/email are actually persisted — there is
/// no real profile-update endpoint on either side yet (source's own
/// `saveProfile()` is a `Future.delayed` stub referencing a URL that's
/// never called). Ported as-is rather than inventing a fake API call.
class EditProfileController extends Notifier<EditProfileState> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;
  late final TextEditingController locationController;

  @override
  EditProfileState build() {
    final cachedUser = ref.read(authSessionControllerProvider).user;
    nameController = TextEditingController(text: cachedUser?.name ?? '');
    emailController = TextEditingController(text: cachedUser?.email ?? '');
    phoneController = TextEditingController(text: cachedUser?.phone ?? '');
    bioController = TextEditingController();
    locationController = TextEditingController();

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      bioController.dispose();
      locationController.dispose();
    });

    return const EditProfileState();
  }

  String? validateName(String? value, AppLocalizations l10n) =>
      (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null;

  String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.emailRequired;
    if (!value.contains('@')) return l10n.emailInvalid;
    return null;
  }

  /// Returns true on success. Only name/email are sent anywhere (there is
  /// no real update-profile endpoint — see class doc) — bio/location/phone
  /// stay local-only UI fields, matching source.
  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      // TODO: call the real profile-update endpoint once one exists —
      // ukil-chaai never wired its own (dead `profileUpdateURL` reference).
      await Future.delayed(const Duration(milliseconds: 400));

      final session = ref.read(authSessionControllerProvider.notifier);
      final currentUser = ref.read(authSessionControllerProvider).user;
      if (currentUser != null) {
        await session.updateUser(currentUser.copyWith(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
        ));
      }

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: getErrorMessage(e));
      return false;
    }
  }
}

final editProfileControllerProvider =
    NotifierProvider.autoDispose<EditProfileController, EditProfileState>(EditProfileController.new);

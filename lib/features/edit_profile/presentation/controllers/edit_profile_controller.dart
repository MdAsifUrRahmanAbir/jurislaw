import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../data/repositories/edit_profile_repository.dart';
import '../states/edit_profile_state.dart';

/// Edits the client profile through POST /profile (`_method=PUT`, A2.3).
/// Phone is the login identity and is shown read-only.
class EditProfileController extends Notifier<EditProfileState> {
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController upazilaController;
  late final TextEditingController villageController;

  @override
  EditProfileState build() {
    final cachedUser = ref.read(authSessionControllerProvider).user;
    nameController = TextEditingController(text: cachedUser?.name ?? '');
    emailController = TextEditingController(text: cachedUser?.email ?? '');
    phoneController = TextEditingController(text: cachedUser?.phone ?? '');
    upazilaController = TextEditingController(text: cachedUser?.upazila ?? '');
    villageController = TextEditingController(text: cachedUser?.village ?? '');

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      upazilaController.dispose();
      villageController.dispose();
    });

    return EditProfileState(division: cachedUser?.division, district: cachedUser?.district);
  }

  void setDivision(String? value) {
    if (value == state.division) return;
    state = state.copyWith(division: value, clearDistrict: true);
  }

  void setDistrict(String? value) => state = state.copyWith(district: value);

  Future<void> pickPhoto(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 50, maxWidth: 1200);
    if (file != null) state = state.copyWith(newPhotoPath: file.path);
  }

  String? validateName(String? value, AppLocalizations l10n) =>
      (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null;

  String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.emailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) return l10n.emailInvalid;
    return null;
  }

  /// Returns true on success. Sends every editable field (the API treats
  /// it as a partial update), then re-reads GET /profile so the cached
  /// user — including the new photo URL — matches the server.
  Future<bool> submit() async {
    if (state.isSubmitting) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final upazila = upazilaController.text.trim();
      final village = villageController.text.trim();

      await ref.read(editProfileRepositoryProvider).updateProfile(
            name: name,
            email: email,
            division: state.division,
            district: state.district,
            upazila: upazila,
            village: village,
            imagePath: state.newPhotoPath,
          );

      final session = ref.read(authSessionControllerProvider.notifier);
      final currentUser = ref.read(authSessionControllerProvider).user;
      if (currentUser != null) {
        await session.updateUser(currentUser.copyWith(
          name: name,
          email: email,
          division: state.division,
          district: state.district,
          upazila: upazila,
          village: village,
        ));
      }
      await ref.read(profileControllerProvider.notifier).refresh();

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

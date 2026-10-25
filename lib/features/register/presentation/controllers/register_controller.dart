import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../data/repositories/register_repository.dart';
import '../states/register_state.dart';

class RegisterController extends Notifier<RegisterFormState> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController upazilaController;
  late final TextEditingController villageController;
  final _picker = ImagePicker();

  @override
  RegisterFormState build() {
    final cachedUser = ref.read(authSessionControllerProvider).user;
    nameController = TextEditingController(text: cachedUser?.name ?? '');
    emailController = TextEditingController(text: cachedUser?.email ?? '');
    upazilaController = TextEditingController(text: cachedUser?.upazila ?? '');
    villageController = TextEditingController(text: cachedUser?.village ?? '');

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      upazilaController.dispose();
      villageController.dispose();
    });

    return RegisterFormState(division: cachedUser?.division, district: cachedUser?.district);
  }

  void setDivision(String? value) {
    if (value == state.division) return;
    state = state.copyWith(division: value, clearDistrict: true);
  }

  void setDistrict(String? value) => state = state.copyWith(district: value);

  Future<void> pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 50, maxWidth: 1200);
    if (file != null) state = state.copyWith(imagePath: file.path);
  }

  void removeImage() => state = state.copyWith(clearImage: true);

  String? validateName(String? value, AppLocalizations l10n) =>
      (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null;

  String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.emailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) return l10n.emailInvalid;
    return null;
  }

  RegisterRepository get _repository => ref.read(registerRepositoryProvider);

  /// POST /profile/complete — the only client call allowed while the
  /// profile is incomplete. Photo, upazila and village are optional.
  Future<bool> submit(AppLocalizations l10n) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final upazila = upazilaController.text.trim();
      final village = villageController.text.trim();

      await _repository.completeProfile(
        name: name,
        email: email,
        division: state.division!,
        district: state.district!,
        upazila: upazila,
        village: village,
        imagePath: state.imagePath,
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
          isProfileComplete: true,
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

final registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, RegisterFormState>(RegisterController.new);

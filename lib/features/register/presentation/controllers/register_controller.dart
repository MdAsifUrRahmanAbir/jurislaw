import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../data/repositories/register_repository.dart';
import '../states/register_state.dart';

/// Dummy data for the address dropdowns, ported as-is from ukil-chaai —
/// the real backend has no address-lookup API yet (see migration notes).
class RegisterAddressData {
  RegisterAddressData._();
  static const divisions = ['Dhaka', 'Chattogram', 'Rajshahi', 'Khulna', 'Barishal', 'Sylhet', 'Rangpur', 'Mymensingh'];
  static const districts = ['Dhaka', 'Gazipur', 'Narayanganj', 'Tangail', 'Faridpur'];
  static const upazilas = ['Savar', 'Dhamrai', 'Kaliakair', 'Sreepur'];
}

class RegisterController extends Notifier<RegisterFormState> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController villageController;
  final _picker = ImagePicker();

  @override
  RegisterFormState build() {
    final cachedUser = ref.read(authSessionControllerProvider).user;
    nameController = TextEditingController(text: cachedUser?.name ?? '');
    emailController = TextEditingController(text: cachedUser?.email ?? '');
    villageController = TextEditingController();

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      villageController.dispose();
    });

    return const RegisterFormState();
  }

  void setDivision(String? value) => state = state.copyWith(division: value);
  void setDistrict(String? value) => state = state.copyWith(district: value);
  void setUpazila(String? value) => state = state.copyWith(upazila: value);

  Future<void> pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 50);
    if (file != null) state = state.copyWith(imagePath: file.path);
  }

  String? validateName(String? value, AppLocalizations l10n) =>
      (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null;

  String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.emailRequired;
    if (!value.contains('@')) return l10n.emailInvalid;
    return null;
  }

  String? validateDivision(String? value, AppLocalizations l10n) =>
      value == null ? l10n.fieldRequired(l10n.division) : null;

  String? validateDistrict(String? value, AppLocalizations l10n) =>
      value == null ? l10n.fieldRequired(l10n.district) : null;

  RegisterRepository get _repository => ref.read(registerRepositoryProvider);

  Future<bool> submit(AppLocalizations l10n) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (state.imagePath == null) {
      state = state.copyWith(errorMessage: l10n.selectProfilePicture);
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();

      await _repository.completeProfile(
        name: name,
        email: email,
        division: state.division!,
        district: state.district!,
        upazila: state.upazila ?? '',
        village: villageController.text.trim(),
        imagePath: state.imagePath!,
      );

      final session = ref.read(authSessionControllerProvider.notifier);
      final currentUser = ref.read(authSessionControllerProvider).user;
      if (currentUser != null) {
        await session.updateUser(currentUser.copyWith(name: name, email: email, isProfileComplete: true));
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/auth_session_controller.dart';
import '../../data/repositories/profile_repository.dart';

/// Pulls GET /profile and writes it into the session's cached [AppUser],
/// so every screen that reads the session (home header, profile, edit
/// profile) shows the server's latest values.
class ProfileController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      final session = ref.read(authSessionControllerProvider.notifier);
      final current = ref.read(authSessionControllerProvider).user;
      final fresh = profile.toAppUser();
      await session.updateUser(fresh.copyWith(
        id: fresh.id.isEmpty ? current?.id : null,
        phone: fresh.phone.isEmpty ? current?.phone : null,
        // GET /profile only works once the profile is complete.
        isProfileComplete: true,
      ));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider = NotifierProvider<ProfileController, AsyncValue<void>>(ProfileController.new);

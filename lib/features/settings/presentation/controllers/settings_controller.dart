import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/settings_state.dart';

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState();
  }

  void setDarkMode(bool value) {
    state = state.copyWith(
      darkMode: value,
    );
  }

  // TODO: no FCM/push wiring yet (matches ukil-chaai source, which has
  // the same TODO) — this only flips local UI state for now.
  void setPushNotifications(bool value) {
    state = state.copyWith(
      pushNotifications: value,
    );
  }

  void setEmailNotifications(bool value) {
    state = state.copyWith(
      emailNotifications: value,
    );
  }

  void setSmsAlerts(bool value) {
    state = state.copyWith(
      smsAlerts: value,
    );
  }

  void setBiometricAuth(bool value) {
    state = state.copyWith(
      biometricAuth: value,
    );
  }

  Future<void> deleteAccount() async {

  }
}

final settingsControllerProvider =
NotifierProvider.autoDispose<
    SettingsController,
    SettingsState>(
  SettingsController.new,
);
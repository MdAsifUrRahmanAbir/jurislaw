class SettingsState {
  final bool darkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsAlerts;
  final bool biometricAuth;

  const SettingsState({
    this.darkMode = false,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsAlerts = false,
    this.biometricAuth = true,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsAlerts,
    bool? biometricAuth,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      pushNotifications:
      pushNotifications ?? this.pushNotifications,
      emailNotifications:
      emailNotifications ?? this.emailNotifications,
      smsAlerts: smsAlerts ?? this.smsAlerts,
      biometricAuth:
      biometricAuth ?? this.biometricAuth,
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/settings_group.dart';
import '../../../../core/widgets/common/settings_tile.dart';

/// Grouped navigation rows shown on the profile screen. Taps are
/// reported up via the individual callbacks so navigation stays in
/// the caller's hands.
class ProfileSettingsSections extends StatelessWidget {
  final VoidCallback? onPersonalInfoTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onLogoutTap;

  const ProfileSettingsSections({
    super.key,
    this.onPersonalInfoTap,
    this.onSettingsTap,
    this.onPrivacyTap,
    this.onHelpCenterTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsGroup(
          label: 'ACCOUNT',
          children: [
            SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Personal Info',
              subtitle: 'Name, email and address',
              onTap: onPersonalInfoTap,
            ),
            SettingsTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences, language and security',
              onTap: onSettingsTap,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsGroup(
          label: 'SUPPORT',
          children: [
            SettingsTile(
              icon: Icons.shield_outlined,
              title: 'Terms & Privacy',
              onTap: onPrivacyTap,
            ),
            SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'Help Center',
              onTap: onHelpCenterTap,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsGroup(
          label: 'ACCOUNT ACTIONS',
          children: [
            SettingsTile(
              icon: Icons.logout_rounded,
              title: AppLocalizations.of(context)!.logOut,
              trailing: SettingsTileTrailing.none,
              onTap: onLogoutTap,
            ),
          ],
        ),
      ],
    );
  }
}

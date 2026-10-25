import 'package:flutter/material.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/settings_group.dart';
import '../../../../core/widgets/common/settings_tile.dart';

/// Grouped navigation rows shown on the profile screen. Taps are
/// reported up via the individual callbacks so navigation stays in
/// the caller's hands.
class ProfileSettingsSections extends StatelessWidget {
  final VoidCallback? onPersonalInfoTap;
  final VoidCallback? onBookingsTap;
  final VoidCallback? onPaymentsTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onLogoutTap;

  const ProfileSettingsSections({
    super.key,
    this.onPersonalInfoTap,
    this.onBookingsTap,
    this.onPaymentsTap,
    this.onNotificationsTap,
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
              subtitle: 'Name, email, address and photo',
              onTap: onPersonalInfoTap,
            ),
            SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Booking, payment and session updates',
              onTap: onNotificationsTap,
            ),
            SettingsTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences and language',
              onTap: onSettingsTap,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsGroup(
          label: 'CONSULTATIONS',
          children: [
            SettingsTile(
              icon: Icons.event_note_outlined,
              title: 'My Bookings',
              subtitle: 'Upcoming and past consultations',
              onTap: onBookingsTap,
            ),
            SettingsTile(
              icon: Icons.receipt_long_outlined,
              title: 'Payment History',
              subtitle: 'Receipts and refunds',
              onTap: onPaymentsTap,
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

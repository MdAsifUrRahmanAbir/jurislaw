import 'package:flutter/material.dart';
import '../../../../core/localization/gen/app_localizations.dart';

/// Icon + label data for one bottom-nav tab. Kept as plain data (not
/// a widget) so the destination list can be built once and reused by
/// both [ShellTabBody] index lookups and the nav bar itself — add or
/// reorder a feature here and both the tab content and the nav icons
/// update together.
class ShellNavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const ShellNavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Home / Lawyers / Bookings / Profile — the center "New Consultation"
/// action lives as a separate FAB on [MainShellMobileView], not a tab
/// (matching ukil-chaai's bottom_nav, which routes its FAB to intake_form).
List<ShellNavItemData> shellNavItemsFor(AppLocalizations l10n) => [
      ShellNavItemData(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: l10n.navHome),
      ShellNavItemData(icon: Icons.gavel_outlined, selectedIcon: Icons.gavel_rounded, label: l10n.navLawyers),
      ShellNavItemData(icon: Icons.event_note_outlined, selectedIcon: Icons.event_note_rounded, label: l10n.navBookings),
      ShellNavItemData(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: l10n.navProfile),
    ];

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_appbar_widget.dart';
import '../../../widgets/toggle_switch_widget.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const PrimaryAppBar(title: AppStrings.settings),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        children: [
          // Appearance
          _SettingsSection(
            title: AppStrings.appearance,
            isDark: isDark,
            children: [
              Obx(
                () => ToggleSwitchWidget(
                  icon: Icons.dark_mode_outlined,
                  label: AppStrings.darkMode,
                  subtitle: 'Switch between light and dark theme',
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Notifications
          _SettingsSection(
            title: AppStrings.notifications,
            isDark: isDark,
            children: [
              Obx(
                () => ToggleSwitchWidget(
                  icon: Icons.notifications_outlined,
                  label: 'Push Notifications',
                  subtitle: 'Receive alerts and updates',
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Security
          _SettingsSection(
            title: AppStrings.privacy,
            isDark: isDark,
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                title: AppStrings.changePassword,
                onTap: controller.goToChangePassword,
                isDark: isDark,
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.security_outlined,
                title: AppStrings.twoFaSecurity,
                onTap: controller.goToTwoFaSecurity,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // About
          _SettingsSection(
            title: 'About',
            isDark: isDark,
            children: [
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                title: AppStrings.helpSupport,
                onTap: () {},
                isDark: isDark,
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: AppStrings.aboutApp,
                trailing: Text(
                  '${AppStrings.version} ${controller.appVersion}',
                  style: const TextStyle(
                    fontSize: AppSizes.fontXS,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {},
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Logout
          _SettingsSection(
            isDark: isDark,
            children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                title: AppStrings.logout,
                iconColor: AppColors.error,
                titleColor: AppColors.error,
                showChevron: false,
                onTap: () => _showLogoutDialog(context),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapXLarge),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: AppStrings.logout,
      middleText: AppStrings.logoutConfirm,
      textConfirm: AppStrings.yes,
      textCancel: AppStrings.cancel,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final bool isDark;

  const _SettingsSection({
    this.title,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.toUpperCase(),
            style: const TextStyle(
              fontSize: AppSizes.fontXS,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSizes.gapXSmall),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardBackground
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;
  final Color? iconColor;
  final Color? titleColor;
  final Widget? trailing;
  final bool showChevron;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
    this.iconColor,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: AppSizes.iconSmall,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w500,
          color:
              titleColor ??
              (isDark ? AppColors.textLight : AppColors.textPrimary),
        ),
      ),
      trailing:
          trailing ??
          (showChevron
              ? const Icon(Icons.chevron_right_rounded, color: AppColors.grey)
              : null),
      onTap: onTap,
    );
  }
}

part of 'settings_view.dart';

class SettingsMobile extends GetView<SettingsController> {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: PrimaryAppBar(title: AppStrings.settings),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        children: [
          // Appearance
          SettingsSection(
            title: AppStrings.appearance,
            isDark: isDark,
            children: [
              Obx(
                () => ToggleSwitchWidget(
                  icon: Icons.dark_mode_outlined,
                  label: AppStrings.darkMode,
                  subtitle: 'dark_mode_subtitle'.tr,
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Language
          SettingsSection(
            title: 'change_language'.tr,
            isDark: isDark,
            children: [
              SettingsTile(
                icon: Icons.language_rounded,
                title: 'select_language'.tr,
                onTap: () => _showLanguageDialog(context),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Notifications
          SettingsSection(
            title: AppStrings.notifications,
            isDark: isDark,
            children: [
              Obx(
                () => ToggleSwitchWidget(
                  icon: Icons.notifications_outlined,
                  label: 'push_notifications'.tr,
                  subtitle: 'notifications_subtitle'.tr,
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // Security
          SettingsSection(
            title: AppStrings.privacy,
            isDark: isDark,
            children: [
              SettingsTile(
                icon: Icons.lock_outline,
                title: AppStrings.changePassword,
                onTap: controller.goToChangePassword,
                isDark: isDark,
              ),
              const Divider(height: 1, indent: 56),
              SettingsTile(
                icon: Icons.security_outlined,
                title: AppStrings.twoFaSecurity,
                onTap: controller.goToTwoFaSecurity,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.gapMid),

          // About
          SettingsSection(
            title: 'about'.tr,
            isDark: isDark,
            children: [
              SettingsTile(
                icon: Icons.help_outline_rounded,
                title: AppStrings.helpSupport,
                onTap: () {},
                isDark: isDark,
              ),
              const Divider(height: 1, indent: 56),
              SettingsTile(
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
          SettingsSection(
            isDark: isDark,
            children: [
              SettingsTile(
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

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('bangla'.tr),
              onTap: () {
                LocalStorage.saveLanguage(name: 'Bangla', langSmall: 'bn', langCap: 'BN');
                Get.updateLocale(const Locale('bn'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                LocalStorage.saveLanguage(name: 'English', langSmall: 'en', langCap: 'EN');
                Get.updateLocale(const Locale('en'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

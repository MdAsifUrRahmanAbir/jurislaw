import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffoldBackground
          : AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSizes.gapMid),
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Obx(
                              () => controller.userAvatar.value.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        controller.userAvatar.value,
                                        fit: BoxFit.cover,
                                        width: 96,
                                        height: 96,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToEditProfile,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.gapSmall),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          style: const TextStyle(
                            fontSize: AppSizes.fontLarge,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.userEmail.value,
                          style: TextStyle(
                            fontSize: AppSizes.fontSmall,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.paddingMid),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSizes.gapSmall),

                // Edit Profile button
                PrimaryButton(
                  text: AppStrings.editProfile,
                  icon: Icons.edit_outlined,
                  onPressed: controller.goToEditProfile,
                ),
                const SizedBox(height: AppSizes.gapLarge),

                // Profile Sections
                _ProfileSection(
                  title: 'Account',
                  items: [
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: AppStrings.editProfile,
                      onTap: controller.goToEditProfile,
                    ),
                    _ProfileTile(
                      icon: Icons.settings_outlined,
                      title: AppStrings.settings,
                      onTap: controller.goToSettings,
                    ),
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: AppSizes.gapMid),
                _ProfileSection(
                  title: 'Support',
                  items: [
                    _ProfileTile(
                      icon: Icons.help_outline_rounded,
                      title: AppStrings.helpSupport,
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.info_outline_rounded,
                      title: AppStrings.aboutApp,
                      onTap: () {},
                    ),
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: AppSizes.gapMid),

                // Logout Button
                PrimaryButton(
                  text: AppStrings.logout,
                  color: AppColors.error,
                  icon: Icons.logout_rounded,
                  onPressed: () => _showLogoutDialog(context),
                ),
                const SizedBox(height: AppSizes.gapXLarge),
              ]),
            ),
          ),
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

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final bool isDark;

  const _ProfileSection({
    required this.title,
    required this.items,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppSizes.fontSmall,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSizes.gapXSmall),
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
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: AppSizes.iconSmall),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textLight : AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
      onTap: onTap,
    );
  }
}

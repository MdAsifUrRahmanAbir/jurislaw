part of 'profile_view.dart';

class ProfileMobile extends GetView<ProfileController> {
  const ProfileMobile({super.key});

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
                ProfileSection(
                  title: 'account'.tr,
                  items: [
                    ProfileTile(
                      icon: Icons.person_outline,
                      title: AppStrings.editProfile,
                      onTap: controller.goToEditProfile,
                    ),
                    ProfileTile(
                      icon: Icons.settings_outlined,
                      title: AppStrings.settings,
                      onTap: controller.goToSettings,
                    ),
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: AppSizes.gapMid),
                ProfileSection(
                  title: 'support'.tr,
                  items: [
                    ProfileTile(
                      icon: Icons.help_outline_rounded,
                      title: AppStrings.helpSupport,
                      onTap: () {},
                    ),
                    ProfileTile(
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/widgets/utility/custom_alert_dialog.dart';
import '../../../../routes/route_names.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_sections.dart';

class ProfileMobileView extends ConsumerWidget {
  const ProfileMobileView({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await CustomAlertDialog.confirm(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
      destructive: true,
    );
    if (confirmed != true) return;
    await ref.read(authSessionControllerProvider.notifier).logout();
    if (!context.mounted) return;
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionControllerProvider).user;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.xl),
        child: Column(
          children: [
            ProfileHeader(
              name: user?.name.isNotEmpty == true ? user!.name : 'Your Profile',
              phone: user?.phone ?? '',
              avatarUrl: user?.profilePhoto,
              onAvatarEditTap: () => context.push(RouteNames.editProfile),
            ),
            const SizedBox(height: AppSizes.lg),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
              child: ProfileSettingsSections(
                onPersonalInfoTap: () => context.push(RouteNames.editProfile),
                onSettingsTap: () => context.push(RouteNames.settings),
                onPrivacyTap: () => context.push(RouteNames.termsPrivacy),
                onHelpCenterTap: () => context.push(RouteNames.helpSupport),
                onLogoutTap: () => _logout(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

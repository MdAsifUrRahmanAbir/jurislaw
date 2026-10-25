import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/widgets/utility/custom_alert_dialog.dart';
import '../../../../routes/route_names.dart';
import '../../../main_shell/presentation/controllers/main_shell_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_sections.dart';

/// Profile tab — reads GET /profile into the session on open and on
/// pull-to-refresh. [maxWidth] centers it on wider screens.
class ProfileMobileView extends ConsumerWidget {
  final double maxWidth;

  const ProfileMobileView({super.key, this.maxWidth = double.infinity});

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
    final profileState = ref.watch(profileControllerProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: ref.read(profileControllerProvider.notifier).refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.xl),
              child: Column(
                children: [
                  ProfileHeader(
                    name: user?.name.isNotEmpty == true ? user!.name : 'Your Profile',
                    phone: user?.phone ?? '',
                    email: user?.email,
                    address: user?.addressLine,
                    avatarUrl: user?.profilePhoto,
                    onAvatarEditTap: () => context.push(RouteNames.editProfile),
                  ),
                  if (profileState.isLoading && user == null)
                    const Padding(padding: EdgeInsets.all(AppSizes.md), child: LinearProgressIndicator()),
                  const SizedBox(height: AppSizes.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: ProfileSettingsSections(
                      onPersonalInfoTap: () => context.push(RouteNames.editProfile),
                      onNotificationsTap: () => context.push(RouteNames.notifications),
                      onBookingsTap: () => ref.read(mainShellControllerProvider.notifier).selectTab(2),
                      onPaymentsTap: () => context.push(RouteNames.receipts),
                      onSettingsTap: () => context.push(RouteNames.settings),
                      onPrivacyTap: () => context.push(RouteNames.termsPrivacy),
                      onHelpCenterTap: () => context.push(RouteNames.helpSupport),
                      onLogoutTap: () => _logout(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

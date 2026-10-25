import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/avatar.dart';

/// Top welcome bar — avatar, greeting + user name, and a notification
/// bell with the unread count.
class HomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final int unreadCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.unreadCount = 0,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.bottomNavBarHeight + AppSizes.sm,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      color: context.appColors.surface,
      child: Row(
        children: [
          AppAvatar(
            imageUrl: avatarUrl,
            label: userName,
            radius: AppSizes.md + AppSizes.xs,
            onTap: onAvatarTap,
          ),
          const SizedBox(width: AppSizes.sm + AppSizes.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_greeting, style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary)),
                Text(
                  'Hello, $userName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNotificationTap,
            tooltip: 'Notifications',
            style: IconButton.styleFrom(side: BorderSide(color: context.appColors.border)),
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              backgroundColor: AppColors.error,
              label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
              child: Icon(Icons.notifications_outlined, color: context.appColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../data/models/notification_model.dart';

/// Single notification row — an icon/color picked from the notification
/// type, title, body and relative time. Unread rows get a tint and a dot.
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  static ({IconData icon, Color color}) styleFor(String type) {
    final t = type.toLowerCase();
    if (t.contains('payment') || t.contains('refund') || t.contains('paid')) {
      return (icon: Icons.payments_rounded, color: AppColors.success);
    }
    if (t.contains('reschedule') || t.contains('propos')) {
      return (icon: Icons.event_repeat_rounded, color: AppColors.warning);
    }
    if (t.contains('cancel') || t.contains('reject') || t.contains('expire')) {
      return (icon: Icons.event_busy_rounded, color: AppColors.error);
    }
    if (t.contains('session') || t.contains('message') || t.contains('join')) {
      return (icon: Icons.forum_rounded, color: AppColors.info);
    }
    if (t.contains('accept') || t.contains('confirm')) {
      return (icon: Icons.event_available_rounded, color: AppColors.success);
    }
    return (icon: Icons.notifications_rounded, color: AppColors.primary);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = styleFor('${notification.type} ${notification.title}');
    final unread = !notification.isRead;

    return CustomCard(
      onTap: onTap,
      accentColor: unread ? style.color : null,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(style.icon, size: AppSizes.iconSm + 4, color: style.color),
          ),
          const SizedBox(width: AppSizes.sm + AppSizes.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: AppSizes.fontMd,
                          fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: AppSizes.sm,
                        height: AppSizes.sm,
                        margin: const EdgeInsets.only(left: AppSizes.xs),
                        decoration: BoxDecoration(color: style.color, shape: BoxShape.circle),
                      ),
                  ],
                ),
                if (notification.body.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppSizes.fontSm, height: 1.35, color: colors.textSecondary),
                  ),
                ],
                if (notification.createdAt != null) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(DateFormatter.relative(notification.createdAt!), style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textHint)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

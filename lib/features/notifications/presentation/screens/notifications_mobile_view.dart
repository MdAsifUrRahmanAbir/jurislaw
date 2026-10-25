import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/common/app_header_bar.dart';
import '../../../../core/widgets/common/custom_filter_bar.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../../../core/widgets/utility/paged_list_view.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/notification_model.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';

/// Notifications (A8). Tapping one marks it read and opens what it is
/// about — routing on type / booking id, not the web `url`.
class NotificationsMobileView extends ConsumerWidget {
  final double maxWidth;

  const NotificationsMobileView({super.key, this.maxWidth = double.infinity});

  void _open(BuildContext context, WidgetRef ref, NotificationModel notification) {
    ref.read(notificationControllerProvider.notifier).markRead(notification);
    final type = notification.type.toLowerCase();
    if (notification.bookingId != null) {
      final isSession = type.contains('session') || type.contains('message') || type.contains('join');
      context.push(isSession ? RouteNames.sessionRoomPath(notification.bookingId!) : RouteNames.bookingDetailsPath(notification.bookingId!));
    } else if (type.contains('payment') || type.contains('refund')) {
      context.push(RouteNames.receipts);
    }
  }

  Future<void> _markAll(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(notificationControllerProvider.notifier).markAllRead();
    } catch (e) {
      if (context.mounted) CustomSnackbar.show(context, getErrorMessage(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final controller = ref.read(notificationControllerProvider.notifier);
    final unreadOnly = ref.watch(notificationUnreadOnlyProvider);
    final int badgeCount = ref.watch(unreadCountProvider);
    final int unread = controller.unreadTotal ?? badgeCount;

    return SafeArea(
      child: Column(
        children: [
          AppHeaderBar(
            title: AppStrings.notificationsTitle,
            backStyle: HeaderBackStyle.circle,
            trailingLabel: unread > 0 ? AppStrings.markAllAsRead : null,
            onTrailingTap: () => _markAll(context, ref),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, 0),
                      child: CustomFilterBar<bool>(
                        filters: const [false, true],
                        selectedFilters: {unreadOnly},
                        labelBuilder: (onlyUnread) => onlyUnread
                            ? '${AppStrings.filterUnread}${unread > 0 ? ' ($unread)' : ''}'
                            : AppStrings.filterAll,
                        onSelected: (value) => ref.read(notificationUnreadOnlyProvider.notifier).setUnreadOnly(value),
                      ),
                    ),
                    Expanded(
                      child: PagedListView<NotificationModel>(
                        state: state,
                        onRefresh: () async {
                          await controller.refresh();
                          ref.read(unreadCountProvider.notifier).refresh();
                        },
                        onLoadMore: controller.loadMore,
                        onRetryMore: controller.retryMore,
                        spacing: AppSizes.sm + AppSizes.xs,
                        empty: EmptyState(
                          title: unreadOnly ? 'You\'re all caught up' : 'No notifications yet',
                          message: 'Booking, payment and session updates will appear here.',
                          icon: Icons.notifications_none_rounded,
                        ),
                        itemBuilder: (context, notification, _) => NotificationTile(
                          notification: notification,
                          onTap: () => _open(context, ref, notification),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

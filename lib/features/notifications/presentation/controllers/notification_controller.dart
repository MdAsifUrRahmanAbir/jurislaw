import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/state/paged_list_state.dart';
import '../../../../core/utils/json_utils.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

/// "all" or "unread" — drives `unread_only` on GET /notifications.
class NotificationFilterController extends Notifier<bool> {
  @override
  bool build() => false;

  void setUnreadOnly(bool value) => state = value;
}

final notificationUnreadOnlyProvider =
    NotifierProvider.autoDispose<NotificationFilterController, bool>(NotificationFilterController.new);

/// GET /notifications (A8.1), with mark-one (A8.3) and mark-all (A8.4).
class NotificationController extends PagedListNotifier<NotificationModel> {
  @override
  PagedListState<NotificationModel> build() {
    ref.listen(notificationUnreadOnlyProvider, (_, _) => refresh());
    return initialLoad();
  }

  NotificationRepository get _repository => ref.read(notificationRepositoryProvider);

  @override
  Future<PaginatedResponse<NotificationModel>> fetchPage(int page) =>
      _repository.fetchNotifications(page: page, unreadOnly: ref.read(notificationUnreadOnlyProvider));

  /// `meta.unread_total` from the last page fetched.
  int? get unreadTotal => Json.intOrNull(state.meta, const ['unread_total', 'unread']);

  Future<void> markRead(NotificationModel notification) async {
    if (notification.isRead) return;
    replaceWhere((n) => n.id == notification.id, (n) => n.markedRead());
    try {
      await _repository.markRead(notification.id);
    } catch (_) {
      // Idempotent on the server; a failed call just leaves it unread there.
    }
    ref.read(unreadCountProvider.notifier).refresh();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    if (ref.read(notificationUnreadOnlyProvider)) {
      await refresh();
    } else {
      state = state.copyWith(items: [for (final n in state.items) n.markedRead()], meta: {...state.meta, 'unread_total': 0});
    }
    ref.read(unreadCountProvider.notifier).set(0);
  }
}

final notificationControllerProvider =
    NotifierProvider.autoDispose<NotificationController, PagedListState<NotificationModel>>(NotificationController.new);

/// Badge count for the bell on the home header (A8.2).
class UnreadCountController extends Notifier<int> {
  @override
  int build() {
    Future.microtask(refresh);
    return 0;
  }

  void set(int value) => state = value;

  Future<void> refresh() async {
    try {
      state = await ref.read(notificationRepositoryProvider).fetchUnreadCount();
    } catch (_) {}
  }
}

final unreadCountProvider = NotifierProvider<UnreadCountController, int>(UnreadCountController.new);

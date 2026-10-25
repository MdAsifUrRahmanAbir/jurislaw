import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
});

/// Notifications — A8.1 to A8.4.
class NotificationRepository {
  final ApiClient _apiClient;
  NotificationRepository(this._apiClient);

  /// GET /notifications — 20 per page; `meta.unread_total` is the badge.
  Future<PaginatedResponse<NotificationModel>> fetchNotifications({int page = 1, bool unreadOnly = false}) async {
    final response = await _apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, if (unreadOnly) 'unread_only': 1},
    );
    return PaginatedResponse.fromBody(
      response.data,
      NotificationModel.fromJson,
      requestedPage: page,
      listKeys: const ['data', 'notifications'],
    );
  }

  /// GET /notifications/unread-count — `{data: {unread: 5}}`.
  Future<int> fetchUnreadCount() async {
    final response = await _apiClient.get(ApiEndpoints.notificationsUnreadCount);
    return Json.integer(Json.data(response.data), const ['unread', 'count', 'unread_count']);
  }

  /// POST /notifications/{id}/read — idempotent.
  Future<void> markRead(String notificationId) async {
    await _apiClient.post(ApiEndpoints.notificationMarkRead(notificationId));
  }

  /// POST /notifications/read-all — `{data: {marked: 5}}`.
  Future<int> markAllRead() async {
    final response = await _apiClient.post(ApiEndpoints.notificationsReadAll);
    return Json.integer(Json.data(response.data), const ['marked']);
  }
}

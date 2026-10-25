import '../../../../core/utils/json_utils.dart';

/// One notification (A8.1). `url` links to the web panel — the app routes
/// on [type] and [bookingId] instead.
class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final String? bookingId;
  final String? transactionId;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
    this.bookingId,
    this.transactionId,
  });

  NotificationModel markedRead() => NotificationModel(
        id: id,
        type: type,
        title: title,
        body: body,
        isRead: true,
        createdAt: createdAt,
        bookingId: bookingId,
        transactionId: transactionId,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Laravel database notifications keep the payload under `data`.
    final payload = Json.map(json, const ['data', 'payload']) ?? const {};
    final readAt = Json.pick(json, const ['read_at']);
    return NotificationModel(
      id: Json.string(json, const ['id']),
      type: Json.stringOrNull(json, const ['type', 'event']) ?? Json.string(payload, const ['type', 'event']),
      title: Json.stringOrNull(json, const ['title', 'subject']) ?? Json.string(payload, const ['title', 'subject'], 'Notification'),
      body: Json.stringOrNull(json, const ['body', 'message', 'text']) ?? Json.string(payload, const ['body', 'message', 'text']),
      isRead: json.containsKey('is_read') || json.containsKey('read')
          ? Json.boolean(json, const ['is_read', 'read'])
          : readAt != null,
      createdAt: Json.date(json, const ['created_at', 'time']),
      bookingId: Json.stringOrNull(json, const ['booking_id']) ?? Json.stringOrNull(payload, const ['booking_id']),
      transactionId: Json.stringOrNull(json, const ['transaction_id']) ?? Json.stringOrNull(payload, const ['transaction_id']),
    );
  }
}

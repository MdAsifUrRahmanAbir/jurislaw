import '../../../../core/utils/json_utils.dart';

/// Booking `status` values from the API reference.
class BookingStatus {
  BookingStatus._();

  static const pendingPayment = 'pending_payment';
  static const pendingAdvocate = 'pending_advocate';
  static const rescheduleOffered = 'reschedule_offered';
  static const confirmed = 'confirmed';
  static const awaitingApproval = 'awaiting_approval';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const rejected = 'rejected';
  static const expired = 'expired';
  static const refunded = 'refunded';

  /// Bookings that are over — shown under the "Past" tab.
  static const finished = {completed, cancelled, rejected, expired, refunded};
}

/// The advocate side of a booking, as embedded in the booking payload.
class BookingAdvocate {
  final String id;
  final String name;
  final String? photoUrl;
  final List<String> practiceAreas;

  const BookingAdvocate({required this.id, required this.name, this.photoUrl, this.practiceAreas = const []});

  factory BookingAdvocate.fromJson(Map<String, dynamic>? json) => BookingAdvocate(
        id: Json.string(json, const ['id', 'advocate_id']),
        name: Json.string(json, const ['name', 'full_name'], 'Advocate'),
        photoUrl: Json.stringOrNull(json, const ['profile_photo_url', 'photo_url', 'photo', 'avatar']),
        practiceAreas: Json.strings(json, const ['practice_areas']),
      );
}

class BookingRefund {
  final String status;
  final double? amount;
  final String? note;

  const BookingRefund({required this.status, this.amount, this.note});

  bool get isPending => status == 'pending' || status == 'requested' || status == 'processing';

  static BookingRefund? fromValue(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final json = Map<String, dynamic>.from(value);
      final status = Json.stringOrNull(json, const ['status', 'state']);
      if (status == null) return null;
      return BookingRefund(
        status: status,
        amount: Json.numberOrNull(json, const ['amount', 'total']),
        note: Json.stringOrNull(json, const ['note', 'admin_note', 'reason']),
      );
    }
    final text = value.toString();
    return text.isEmpty ? null : BookingRefund(status: text);
  }
}

/// A slot the client asked for when declining a reschedule (A5.5).
class ClientRequest {
  final String? scheduleId;
  final DateTime? startsAt;
  final String? status;

  const ClientRequest({this.scheduleId, this.startsAt, this.status});

  static ClientRequest? fromValue(dynamic value) {
    if (value is! Map) return null;
    final json = Map<String, dynamic>.from(value);
    return ClientRequest(
      scheduleId: Json.stringOrNull(json, const ['schedule_id', 'requested_schedule_id', 'id']),
      startsAt: Json.date(json, const ['starts_at', 'start_at']),
      status: Json.stringOrNull(json, const ['status']),
    );
  }
}

/// One booking from A5.1 / A5.2 (also the `upcoming[]` rows of the
/// dashboard). `startsAt`/`endsAt` are the effective time — the accepted
/// reschedule if there is one.
class BookingModel {
  final String id;
  final String status;
  final String statusLabel;
  final String paymentStatus;
  final double amount;
  final bool canCancel;
  final String? cancelBlocked;
  final BookingRefund? refund;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? proposedAt;
  final DateTime? proposedEndsAt;
  final List<String> declinedSlotIds;
  final ClientRequest? clientRequest;
  final String? caseDetails;
  final String? sessionType;
  final String? cancellationReason;
  final DateTime? reservedUntil;
  final DateTime? createdAt;
  final bool needsResponseFlag;
  final BookingAdvocate advocate;

  const BookingModel({
    required this.id,
    required this.status,
    required this.statusLabel,
    this.paymentStatus = '',
    this.amount = 0,
    this.canCancel = false,
    this.cancelBlocked,
    this.refund,
    this.startsAt,
    this.endsAt,
    this.proposedAt,
    this.proposedEndsAt,
    this.declinedSlotIds = const [],
    this.clientRequest,
    this.caseDetails,
    this.sessionType,
    this.cancellationReason,
    this.reservedUntil,
    this.createdAt,
    this.needsResponseFlag = false,
    required this.advocate,
  });

  bool get isPendingPayment => status == BookingStatus.pendingPayment;
  bool get isRescheduleOffered => status == BookingStatus.rescheduleOffered;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isFinished => BookingStatus.finished.contains(status);
  bool get isPaid => paymentStatus == 'paid';

  /// The advocate proposed a new time and the client must accept/decline.
  bool get needsResponse => needsResponseFlag || isRescheduleOffered;

  /// The live session room opens 10 minutes before the start.
  bool get canJoinSession {
    if (!isConfirmed || startsAt == null) return false;
    final opensAt = startsAt!.subtract(const Duration(minutes: 10));
    final closesAt = endsAt ?? startsAt!.add(const Duration(hours: 2));
    final now = DateTime.now();
    return now.isAfter(opensAt) && now.isBefore(closesAt.add(const Duration(hours: 1)));
  }

  /// Chat history stays readable after the session ends.
  bool get hasSessionRoom => isConfirmed || status == BookingStatus.awaitingApproval || status == BookingStatus.completed;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final status = Json.string(json, const ['status'], 'unknown');
    final proposed = Json.map(json, const ['proposal', 'reschedule', 'proposed_slot']);
    return BookingModel(
      id: Json.string(json, const ['id', 'booking_id']),
      status: status,
      statusLabel: Json.stringOrNull(json, const ['status_label']) ?? _humanize(status),
      paymentStatus: Json.string(json, const ['payment_status']),
      amount: Json.number(json, const ['amount', 'total', 'price', 'fee']),
      canCancel: Json.boolean(json, const ['can_cancel']),
      cancelBlocked: _blockedReason(Json.pick(json, const ['cancel_blocked', 'cancel_blocked_reason'])),
      refund: BookingRefund.fromValue(Json.pick(json, const ['refund', 'refund_status'])),
      startsAt: Json.date(json, const ['starts_at', 'start_at', 'scheduled_at']),
      endsAt: Json.date(json, const ['ends_at', 'end_at']),
      proposedAt: Json.date(json, const ['proposed_at', 'proposed_starts_at']) ??
          Json.date(proposed, const ['starts_at', 'start_at', 'proposed_at']),
      proposedEndsAt: Json.date(json, const ['proposed_ends_at']) ?? Json.date(proposed, const ['ends_at', 'end_at']),
      declinedSlotIds: Json.list(json, const ['declined_slot_ids']).map((e) => e.toString()).toList(),
      clientRequest: ClientRequest.fromValue(Json.pick(json, const ['client_request'])),
      caseDetails: Json.stringOrNull(json, const ['case_details', 'description']),
      sessionType: Json.stringOrNull(json, const ['session_type_label', 'session_type']),
      cancellationReason: Json.stringOrNull(json, const ['cancellation_reason']),
      reservedUntil: Json.date(json, const ['reserved_until', 'hold_expires_at']),
      createdAt: Json.date(json, const ['created_at', 'booked_at']),
      needsResponseFlag: Json.boolean(json, const ['needs_response']),
      advocate: BookingAdvocate.fromJson(
        Json.map(json, const ['advocate', 'lawyer']) ??
            {'id': json['advocate_id'], 'name': json['advocate_name'], 'photo': json['advocate_photo']},
      ),
    );
  }

  /// `cancel_blocked` may be a reason string, `false`, or `{reason}`.
  static String? _blockedReason(dynamic value) {
    if (value == null || value == false) return null;
    if (value is Map) return (value['reason'] ?? value['message'])?.toString();
    final text = value.toString();
    return text.isEmpty || text == 'true' ? null : text;
  }

  static String _humanize(String raw) {
    if (raw.isEmpty) return '';
    final text = raw.replaceAll('_', ' ');
    return text[0].toUpperCase() + text.substring(1);
  }
}

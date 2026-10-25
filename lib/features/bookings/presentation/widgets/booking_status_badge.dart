import 'package:flutter/material.dart';
import '../../../../core/widgets/common/status_badge.dart';
import '../../data/models/booking_model.dart';

/// Status pill colored by booking status; text is the API's `status_label`.
class BookingStatusBadge extends StatelessWidget {
  final BookingModel booking;
  final bool compact;

  const BookingStatusBadge({super.key, required this.booking, this.compact = true});

  static StatusBadgeType typeFor(String status) => switch (status) {
        BookingStatus.confirmed || BookingStatus.completed => StatusBadgeType.success,
        BookingStatus.pendingPayment || BookingStatus.rescheduleOffered => StatusBadgeType.warning,
        BookingStatus.pendingAdvocate || BookingStatus.awaitingApproval => StatusBadgeType.info,
        BookingStatus.cancelled || BookingStatus.rejected || BookingStatus.expired => StatusBadgeType.error,
        _ => StatusBadgeType.neutral,
      };

  @override
  Widget build(BuildContext context) {
    return StatusBadge(text: booking.statusLabel, type: typeFor(booking.status), compact: compact);
  }
}

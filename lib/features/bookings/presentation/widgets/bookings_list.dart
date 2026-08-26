import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../data/models/booking_model.dart';
import 'booking_list_item.dart';

class BookingsList extends StatelessWidget {
  final List<BookingModel> bookings;
  final bool isPast;

  const BookingsList({super.key, required this.bookings, required this.isPast});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_rounded,
        title: isPast ? 'No past consultations' : 'No upcoming consultations',
        message: isPast ? 'Consultations you complete will show up here.' : 'Book a lawyer to see your consultations here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.lg),
      itemCount: bookings.length,
      itemBuilder: (context, index) => BookingListItem(booking: bookings[index]),
    );
  }
}
